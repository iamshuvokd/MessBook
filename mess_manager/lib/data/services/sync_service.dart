import '../repositories/app_settings_repository.dart';
import '../repositories/groups_repository.dart';
import 'sync_api_service.dart';

/// Orchestrates [SyncApiService] across every online group and tracks a
/// per-group last-synced timestamp (reused as the pull side's `sinceMs`, so
/// only the push has to send full rows — pulls stay incremental after the
/// first one). Runs at app open, on pull-to-refresh, and from the periodic
/// background task; every entry point funnels through here rather than
/// [SyncApiService] directly, so the timestamp bookkeeping never drifts.
class SyncService {
  SyncService(this._api, this._groupsRepo, this._settings);

  final SyncApiService _api;
  final GroupsRepository _groupsRepo;
  final AppSettingsRepository _settings;

  static String _lastSyncKey(String groupId) => 'lastSyncAt_$groupId';
  static String _healedKey(String groupId) => 'syncCursorHealed_$groupId';

  /// Overlap re-pulled on every incremental sync. Rows are upserted
  /// idempotently, so re-pulling a minute of history is free — while a
  /// cursor that lands even slightly past a row's `updated_at` loses that
  /// row forever.
  static const _cursorSafetyMs = 60 * 1000;

  Future<DateTime?> lastSyncedAt(String groupId) async {
    final raw = await _settings.get(_lastSyncKey(groupId));
    return raw == null ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(raw));
  }

  Future<String> bringOnline(String groupId) async {
    final inviteCode = await _api.bringOnline(groupId);
    // No pull happens inside bringOnline, so there's no server timestamp to
    // adopt yet — cursor 0 makes the next sync do one full pull and start
    // the incremental chain from the server's clock.
    await _settings.set(_lastSyncKey(groupId), '0');
    return inviteCode;
  }

  Future<InviteCodeLookup> lookupInviteCode(String code) => _api.lookupInviteCode(code);

  /// Pulls down every online mess this signed-in account owns or has
  /// already joined that isn't yet known on this device — restores a
  /// returning App Admin's/member's messes after a fresh install or new
  /// device instead of making them create a mess from scratch. Safe to call
  /// on every sign-in: a no-op for messes already present locally. Returns
  /// how many messes were newly restored, so a caller can decide what to
  /// show the user.
  Future<int> restoreOnlineGroups() async {
    final remote = await _api.listMyOnlineGroups();
    var restored = 0;
    for (final g in remote) {
      final existing = await _groupsRepo.getGroup(g.id);
      if (existing != null) continue;
      try {
        await pullGroup(g.id);
        // The generic sync payload never carries inviteCode (server-managed,
        // client-local-only — see SyncApiService._applyPulled) so a
        // freshly-restored mess needs it set explicitly, otherwise it would
        // locally look offline despite being the account's own online mess.
        if (g.inviteCode != null) await _groupsRepo.setInviteCode(g.id, g.inviteCode!);
        restored++;
      } catch (_) {
        // Best-effort per mess; one failure shouldn't block restoring the rest.
      }
    }
    return restored;
  }

  Future<JoinResult> joinGroup({required String code, String? memberName, String? existingMemberId}) async {
    final result = await _api.joinGroup(code: code, memberName: memberName, existingMemberId: existingMemberId);
    await _markSynced(result.groupId, result.serverTimeMs - _cursorSafetyMs);
    return result;
  }

  /// Pushes local changes, then pulls anything newer — the pull naturally
  /// overwrites the local copy of any row the push reported as a conflict,
  /// since the server's version is by definition the newer one at that point.
  ///
  /// The cursor stored afterwards is the SERVER's clock (returned by the
  /// pull), never this device's — the server compares `updated_at > sinceMs`
  /// against its own time, so a fast phone clock would silently skip rows
  /// written by other members in the gap.
  Future<void> syncGroup(String groupId) async {
    await _api.pushAll(groupId);
    await pullGroup(groupId);
  }

  /// The pull half of [syncGroup], on its own — used by the near-live
  /// foreground refresh, where a passive viewer only needs to SEE others'
  /// changes and re-uploading all their local rows every tick would just
  /// hammer the server. Local writes still push via [triggerBackgroundSync].
  ///
  /// Self-heal (one-time per group): cursors written before the server-clock
  /// fix came from the phone's clock — on a fast device they sit past rows
  /// other members had already written, which the incremental pull then
  /// skipped forever. The first pull after upgrading does one full pull to
  /// recover anything lost, then resumes incrementally from the server clock.
  Future<void> pullGroup(String groupId) async {
    final healed = await _settings.get(_healedKey(groupId)) == '1';
    final since = healed ? await lastSyncedAt(groupId) : null;
    final result = await _api.pullAll(groupId, sinceMs: since?.millisecondsSinceEpoch ?? 0);
    await _markSynced(groupId, result.serverTimeMs - _cursorSafetyMs);
    if (!healed) await _settings.set(_healedKey(groupId), '1');
    await _ensureActingAs(groupId, result.myMemberId);
  }

  /// Resolves this device's own identity in [groupId] from the server's
  /// authoritative answer (which member row belongs to the signed-in user).
  /// Only fills it in when nothing is set, so an explicit "Preview as"
  /// selection is never overwritten. Without this, a member's device whose
  /// identity was never recorded (e.g. joined on an older build) falls back
  /// to acting as the App Admin and ignores its own assigned role.
  Future<void> _ensureActingAs(String groupId, String? myMemberId) async {
    if (myMemberId == null) return;
    final current = await _settings.get('actingAs_$groupId');
    if (current == null || current.isEmpty) {
      await _settings.set('actingAs_$groupId', myMemberId);
    }
  }

  /// Syncs every group already brought online, skipping ones still purely
  /// local. One group's failure (offline, server unreachable) never blocks
  /// the rest — this is a best-effort background operation, not a
  /// user-initiated action that should surface an error.
  Future<void> syncAllOnlineGroups() async {
    final groups = await _groupsRepo.getOnlineGroups();
    for (final group in groups) {
      try {
        await syncGroup(group.id);
      } catch (_) {
        // Best-effort; see doc comment above.
      }
    }
  }

  Future<void> _markSynced(String groupId, int cursorMs) async {
    await _settings.set(_lastSyncKey(groupId), cursorMs.toString());
  }
}
