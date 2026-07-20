import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/data/db/app_database.dart';
import 'package:mess_manager/data/repositories/app_settings_repository.dart';
import 'package:mess_manager/data/repositories/groups_repository.dart';
import 'package:mess_manager/data/services/api_client.dart';
import 'package:mess_manager/data/services/sync_api_service.dart';
import 'package:mess_manager/data/services/sync_service.dart';
import 'package:mess_manager/domain/models/group.dart';

/// Stands in for the real network calls [SyncApiService] would make, while
/// still writing through the real (in-memory) [AppDatabase] for the parts
/// that matter to [SyncService.restoreOnlineGroups] — same "real objects,
/// no mocking framework" style as backup_service_test.dart, just applied to
/// a class whose real implementation talks to a server.
class _FakeSyncApiService extends SyncApiService {
  _FakeSyncApiService(this.db, this._remoteGroups, {Set<String> failGroupIds = const {}})
      : _failGroupIds = failGroupIds,
        super(ApiClient(const FlutterSecureStorage(), baseUrlProvider: () => 'http://unused'), db);

  // SyncApiService's own `_db` field is private to that class, so the fake
  // keeps its own reference for the overrides below to write through.
  final AppDatabase db;
  final List<({String id, String? inviteCode})> _remoteGroups;
  final Set<String> _failGroupIds;
  final List<String> pulledGroupIds = [];

  @override
  Future<List<({String id, String? inviteCode})>> listMyOnlineGroups() async => _remoteGroups;

  @override
  Future<({int serverTimeMs, String? myMemberId})> pullAll(String groupId, {int sinceMs = 0}) async {
    pulledGroupIds.add(groupId);
    if (_failGroupIds.contains(groupId)) {
      throw Exception('simulated pull failure for $groupId');
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.into(db.groups).insertOnConflictUpdate(
          GroupsCompanion.insert(id: groupId, name: 'Restored $groupId', createdAt: now, updatedAt: now),
        );
    return (serverTimeMs: now, myMemberId: null);
  }
}

void main() {
  // Plain `test()` blocks — see backup_service_test.dart's note on why a
  // real Drift NativeDatabase only works reliably outside `testWidgets`.

  late AppDatabase db;
  late GroupsRepository groupsRepo;
  late AppSettingsRepository settings;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    groupsRepo = GroupsRepository(db);
    settings = AppSettingsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('restores a remote group that is not yet known locally, including its invite code', () async {
    final api = _FakeSyncApiService(db, [(id: 'g1', inviteCode: 'MESS-ABCD1')]);
    final sync = SyncService(api, groupsRepo, settings);

    final restored = await sync.restoreOnlineGroups();

    expect(restored, 1);
    final group = await groupsRepo.getGroup('g1');
    expect(group, isNotNull);
    expect(group!.inviteCode, 'MESS-ABCD1');
  });

  test('skips a remote group that already exists locally, without re-pulling it', () async {
    await groupsRepo.createGroup(name: 'Already Here', type: GroupType.mess);
    final existing = (await groupsRepo.watchActiveGroups().first).single;

    final api = _FakeSyncApiService(db, [(id: existing.id, inviteCode: 'MESS-XYZ99')]);
    final sync = SyncService(api, groupsRepo, settings);

    final restored = await sync.restoreOnlineGroups();

    expect(restored, 0);
    expect(api.pulledGroupIds, isEmpty);
    // Untouched: skipping means it never adopts a remote invite code either.
    final group = await groupsRepo.getGroup(existing.id);
    expect(group!.inviteCode, isNull);
  });

  test('one group failing to pull does not block the rest from restoring', () async {
    final api = _FakeSyncApiService(
      db,
      [(id: 'g-bad', inviteCode: 'MESS-BAD0001'), (id: 'g-good', inviteCode: 'MESS-GOOD001')],
      failGroupIds: {'g-bad'},
    );
    final sync = SyncService(api, groupsRepo, settings);

    final restored = await sync.restoreOnlineGroups();

    expect(restored, 1);
    expect(await groupsRepo.getGroup('g-bad'), isNull);
    final good = await groupsRepo.getGroup('g-good');
    expect(good, isNotNull);
    expect(good!.inviteCode, 'MESS-GOOD001');
  });

  test('zero remote groups is a clean no-op', () async {
    final api = _FakeSyncApiService(db, const []);
    final sync = SyncService(api, groupsRepo, settings);

    final restored = await sync.restoreOnlineGroups();

    expect(restored, 0);
    expect(await groupsRepo.watchActiveGroups().first, isEmpty);
  });
}
