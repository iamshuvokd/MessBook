import 'package:drift/drift.dart';

import '../db/app_database.dart';
import 'api_client.dart';

class JoinResult {
  const JoinResult({required this.groupId, required this.memberId, required this.serverTimeMs});
  final String groupId;
  final String memberId;

  /// Server clock at the initial pull — the caller's first sync cursor.
  final int serverTimeMs;
}

class UnclaimedMember {
  const UnclaimedMember({required this.id, required this.name});
  final String id;
  final String name;
}

class InviteCodeLookup {
  const InviteCodeLookup({required this.groupId, required this.groupName, required this.unclaimedMembers});
  final String groupId;
  final String groupName;
  final List<UnclaimedMember> unclaimedMembers;
}

/// Push/pull against the sync server for a single group, using Drift's
/// generated `toJson`/`fromJson`/`toCompanion` on every row — the same
/// pattern [BackupService] already uses for local export/import. The app
/// stays offline-first: nothing here runs unless the user explicitly brings
/// a mess online or joins one.
class SyncApiService {
  SyncApiService(this._api, this._db);

  final ApiClient _api;
  final AppDatabase _db;

  /// "Bring mess online": registers the group with the server (minting an
  /// invite code), records it locally, then pushes everything else.
  ///
  /// Includes the local App Admin member's id so the server can link it to
  /// the caller's account as part of the same call — otherwise the very
  /// next call (the push below) would 403, since registering the group
  /// alone doesn't make its owner a *member* of it server-side yet.
  Future<String> bringOnline(String groupId) async {
    final group = await (_db.select(_db.groups)..where((g) => g.id.equals(groupId))).getSingle();
    final appAdmin = await (_db.select(_db.members)
          ..where((m) => m.groupId.equals(groupId) & m.role.equals('appAdmin')))
        .getSingleOrNull();

    final response = await _api.post('/groups', {
      ...group.toJson(),
      'appAdminMemberId': ?appAdmin?.id,
      // Send the manager's real name so the server's placeholder member row
      // uses it instead of the mess name — otherwise last-write-wins can
      // keep the placeholder (named after the mess) and clobber the name.
      'appAdminName': ?appAdmin?.name,
    });
    final inviteCode = response['inviteCode'] as String;
    await (_db.update(_db.groups)..where((g) => g.id.equals(groupId))).write(
      GroupsCompanion(inviteCode: Value(inviteCode)),
    );
    await pushAll(groupId);
    return inviteCode;
  }

  /// Looks up an invite code before joining, so the app can offer "is this
  /// you?" against members already created offline instead of always
  /// creating a duplicate member row. Uses [ApiClient.get] (authed but not
  /// group-scoped — the caller isn't a member yet).
  Future<InviteCodeLookup> lookupInviteCode(String code) async {
    final response = await _api.get('/groups/join/${Uri.encodeComponent(code)}/members');
    final members = (response['members'] as List).cast<Map<String, dynamic>>();
    return InviteCodeLookup(
      groupId: response['groupId'] as String,
      groupName: response['groupName'] as String,
      unclaimedMembers: [for (final m in members) UnclaimedMember(id: m['id'] as String, name: m['name'] as String)],
    );
  }

  /// Joins an already-online mess by invite code — either as a brand-new
  /// member ([memberName]) or by claiming an existing unlinked member row
  /// ([existingMemberId]) — then pulls everything down.
  Future<JoinResult> joinGroup({
    required String code,
    String? memberName,
    String? existingMemberId,
  }) async {
    final response = await _api.post('/groups/join', {
      'code': code,
      'memberName': ?memberName,
      'existingMemberId': ?existingMemberId,
    });
    final groupId = response['groupId'] as String;
    final memberId = response['memberId'] as String;
    final pull = await pullAll(groupId);
    return JoinResult(groupId: groupId, memberId: memberId, serverTimeMs: pull.serverTimeMs);
  }

  /// Tells the server to drop (or, if it turns out to have history there
  /// too, deactivate) a member that was just permanently deleted locally.
  /// A hard local delete alone would silently reappear on the next pull —
  /// sync only ever upserts by `updated_at`, it never learns a row is gone.
  Future<void> deleteMemberRemote(String groupId, String memberId) async {
    await _api.delete('/groups/$groupId/members/$memberId');
  }

  /// Tells the server to drop a poll (and its votes, which cascade) that was
  /// just deleted locally — without this the poll would silently reappear on
  /// the next pull, since sync only ever upserts by `updated_at`.
  Future<void> deletePollRemote(String groupId, String pollId) async {
    await _api.delete('/groups/$groupId/polls/$pollId');
  }

  /// Same deal for a bazar duty — a local-only delete reappears on the next
  /// pull, which is why the cross button looked like it did nothing.
  Future<void> deleteBazarDutyRemote(String groupId, String dutyId) async {
    await _api.delete('/groups/$groupId/bazar/$dutyId');
  }

  /// Deletes the entire mess server-side, including every member's copy of
  /// it. App-Admin-only and enforced there, not here. Irreversible.
  Future<void> deleteGroupRemote(String groupId) async {
    await _api.delete('/groups/$groupId');
  }

  /// Hands the App Admin role (and server-side mess ownership) to another
  /// already-joined member. The server does the role swap + `owner_user_id`
  /// move in one call; the caller must still be the App Admin server-side at
  /// call time (so call this before pushing any local demotion of self).
  Future<void> transferOwnershipRemote(String groupId, String newOwnerMemberId) async {
    await _api.post('/groups/$groupId/transfer-ownership', {'newOwnerMemberId': newOwnerMemberId});
  }

  /// Every online mess this signed-in account owns or has already joined —
  /// the source of truth for restoring a returning user's messes on a new
  /// device/reinstall instead of making them create one from scratch.
  Future<List<({String id, String? inviteCode})>> listMyOnlineGroups() async {
    final response = await _api.get('/groups');
    final rows = (response['groups'] as List).cast<Map<String, dynamic>>();
    return [for (final r in rows) (id: r['id'] as String, inviteCode: r['invite_code'] as String?)];
  }

  Future<void> pushAll(String groupId) async {
    final changes = await _collectChanges(groupId);
    await _api.post('/groups/$groupId/sync/push', {'changes': changes});
  }

  /// Returns the server's own clock at pull time (the next incremental
  /// cursor — never the phone's clock; the server filters `updated_at >
  /// sinceMs` against its clock, so a fast phone would permanently skip rows
  /// written in the gap) plus which member row IS this caller in the group,
  /// so the device can resolve its own identity instead of guessing.
  Future<({int serverTimeMs, String? myMemberId})> pullAll(String groupId, {int sinceMs = 0}) async {
    final response = await _api.post('/groups/$groupId/sync/pull', {'sinceMs': sinceMs});
    final tables = (response['tables'] as Map).cast<String, dynamic>();
    await _applyPulled(tables);
    return (
      serverTimeMs: (response['serverTimeMs'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      myMemberId: response['myMemberId'] as String?,
    );
  }

  Future<Map<String, dynamic>> _collectChanges(String groupId) async {
    final expenseIds = await (_db.selectOnly(_db.expenses)
          ..addColumns([_db.expenses.id])
          ..where(_db.expenses.groupId.equals(groupId)))
        .map((row) => row.read(_db.expenses.id)!)
        .get();
    final memberIds = await (_db.selectOnly(_db.members)
          ..addColumns([_db.members.id])
          ..where(_db.members.groupId.equals(groupId)))
        .map((row) => row.read(_db.members.id)!)
        .get();
    final pollIds = await (_db.selectOnly(_db.mealPolls)
          ..addColumns([_db.mealPolls.id])
          ..where(_db.mealPolls.groupId.equals(groupId)))
        .map((row) => row.read(_db.mealPolls.id)!)
        .get();

    final group = await (_db.select(_db.groups)..where((g) => g.id.equals(groupId))).getSingle();
    final members = await (_db.select(_db.members)..where((m) => m.groupId.equals(groupId))).get();
    final categories = await (_db.select(_db.categories)..where((c) => c.groupId.equals(groupId))).get();
    final expenses = await (_db.select(_db.expenses)..where((e) => e.groupId.equals(groupId))).get();
    final expensePayers = await (_db.select(_db.expensePayers)..where((p) => p.expenseId.isIn(expenseIds))).get();
    final expenseSplits = await (_db.select(_db.expenseSplits)..where((s) => s.expenseId.isIn(expenseIds))).get();
    final meals = await (_db.select(_db.meals)..where((m) => m.groupId.equals(groupId))).get();
    final bazarDuties = await (_db.select(_db.bazarDuties)..where((b) => b.groupId.equals(groupId))).get();
    final deposits = await (_db.select(_db.deposits)..where((d) => d.groupId.equals(groupId))).get();
    final settlements = await (_db.select(_db.settlements)..where((s) => s.groupId.equals(groupId))).get();
    final months = await (_db.select(_db.months)..where((m) => m.groupId.equals(groupId))).get();
    final recurringRules = await (_db.select(_db.recurringRules)..where((rr) => rr.groupId.equals(groupId))).get();
    final mealSlots = await (_db.select(_db.mealSlots)..where((s) => s.groupId.equals(groupId))).get();
    final memberMealRoutines =
        await (_db.select(_db.memberMealRoutines)..where((r) => r.memberId.isIn(memberIds))).get();
    final mealLeaves = await (_db.select(_db.mealLeaves)..where((l) => l.memberId.isIn(memberIds))).get();
    final mealPolls = await (_db.select(_db.mealPolls)..where((p) => p.groupId.equals(groupId))).get();
    final mealPollVotes = await (_db.select(_db.mealPollVotes)..where((v) => v.pollId.isIn(pollIds))).get();

    return {
      'groups': [group.toJson()],
      'members': [for (final r in members) r.toJson()],
      'categories': [for (final r in categories) r.toJson()],
      'expenses': [for (final r in expenses) r.toJson()],
      'expensePayers': [for (final r in expensePayers) r.toJson()],
      'expenseSplits': [for (final r in expenseSplits) r.toJson()],
      'meals': [for (final r in meals) r.toJson()],
      'bazarDuties': [for (final r in bazarDuties) r.toJson()],
      'deposits': [for (final r in deposits) r.toJson()],
      'settlements': [for (final r in settlements) r.toJson()],
      'months': [for (final r in months) r.toJson()],
      'recurringRules': [for (final r in recurringRules) r.toJson()],
      'mealSlots': [for (final r in mealSlots) r.toJson()],
      'memberMealRoutines': [for (final r in memberMealRoutines) r.toJson()],
      'mealLeaves': [for (final r in mealLeaves) r.toJson()],
      'mealPolls': [for (final r in mealPolls) r.toJson()],
      'mealPollVotes': [for (final r in mealPollVotes) r.toJson()],
    };
  }

  /// Upserts every pulled row by primary key (never deletes), so a re-pull
  /// is always safe to run alongside data created locally in the meantime.
  Future<void> _applyPulled(Map<String, dynamic> tables) async {
    List<Map<String, dynamic>> rows(String key) => ((tables[key] as List?) ?? const []).cast<Map<String, dynamic>>();

    await _db.batch((batch) {
      // `inviteCode` is never part of the server payload (server-managed,
      // client-local-only) — nullToAbsent:true keeps a pull from wiping out
      // the locally-recorded invite code on the App Admin's own device.
      batch.insertAllOnConflictUpdate(_db.groups, [for (final r in rows('groups')) Group.fromJson(r).toCompanion(true)]);
      batch.insertAllOnConflictUpdate(_db.members, [for (final r in rows('members')) Member.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(
          _db.categories, [for (final r in rows('categories')) Category.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(_db.expenses, [for (final r in rows('expenses')) Expense.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(
          _db.expensePayers, [for (final r in rows('expensePayers')) ExpensePayer.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(
          _db.expenseSplits, [for (final r in rows('expenseSplits')) ExpenseSplit.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(_db.meals, [for (final r in rows('meals')) Meal.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(
          _db.bazarDuties, [for (final r in rows('bazarDuties')) BazarDuty.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(_db.deposits, [for (final r in rows('deposits')) Deposit.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(
          _db.settlements, [for (final r in rows('settlements')) Settlement.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(_db.months, [for (final r in rows('months')) Month.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(
          _db.recurringRules, [for (final r in rows('recurringRules')) RecurringRule.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(_db.mealSlots, [for (final r in rows('mealSlots')) MealSlot.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(_db.memberMealRoutines,
          [for (final r in rows('memberMealRoutines')) MemberMealRoutine.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(
          _db.mealLeaves, [for (final r in rows('mealLeaves')) MealLeave.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(_db.mealPolls, [for (final r in rows('mealPolls')) MealPoll.fromJson(r).toCompanion(false)]);
      batch.insertAllOnConflictUpdate(
          _db.mealPollVotes, [for (final r in rows('mealPollVotes')) MealPollVote.fromJson(r).toCompanion(false)]);
    });
  }
}
