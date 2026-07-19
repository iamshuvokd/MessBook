import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/group.dart' as domain;
import '../../domain/models/non_voter_policy.dart';
import '../db/app_database.dart';

const _uuid = Uuid();

class GroupsRepository {
  GroupsRepository(this._db);

  final AppDatabase _db;

  domain.Group _toDomain(Group row) => domain.Group(
        id: row.id,
        name: row.name,
        type: domain.GroupType.fromDb(row.type),
        currencySymbol: row.currencySymbol,
        monthStartDay: row.monthStartDay,
        mealEnabled: row.mealEnabled,
        mealLedgerSeparate: row.mealLedgerSeparate,
        defaultNonVoterPolicy: NonVoterPolicy.fromDb(row.defaultNonVoterPolicy),
        archived: row.archived,
        createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
        inviteCode: row.inviteCode,
      );

  Stream<List<domain.Group>> watchActiveGroups() {
    final query = _db.select(_db.groups)
      ..where((g) => g.archived.equals(false))
      ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<domain.Group?> getGroup(String id) async {
    final row = await (_db.select(_db.groups)..where((g) => g.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Stream<List<domain.Group>> watchArchivedGroups() {
    final query = _db.select(_db.groups)
      ..where((g) => g.archived.equals(true))
      ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<domain.Group> createGroup({
    required String name,
    required domain.GroupType type,
    String currencySymbol = '৳',
    int monthStartDay = 1,
    bool mealEnabled = true,
    bool mealLedgerSeparate = false,
    String? managerName,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = _uuid.v4();
    await _db.into(_db.groups).insert(
          GroupsCompanion.insert(
            id: id,
            name: name,
            type: Value(type.name),
            currencySymbol: Value(currencySymbol),
            monthStartDay: Value(monthStartDay),
            mealEnabled: Value(mealEnabled),
            mealLedgerSeparate: Value(mealLedgerSeparate),
            createdAt: now,
            updatedAt: now,
          ),
        );
    if (mealEnabled) {
      await seedDefaultMealSlots(_db, id);
    }
    // The creator (mess manager) becomes the App Admin member of their own
    // mess. Without this the group has no owner member row, which silently
    // breaks two things: roles never take effect (nothing is a non-member
    // role, so permission checks stay permissive), and online sync is
    // rejected server-side ("not_a_member") because the manager isn't a
    // member of the mess they own. Also record them as the acting-as member
    // so the app resolves to them by default.
    final trimmedManager = managerName?.trim();
    if (trimmedManager != null && trimmedManager.isNotEmpty) {
      final managerId = _uuid.v4();
      await _db.into(_db.members).insert(
            MembersCompanion.insert(
              id: managerId,
              groupId: id,
              name: trimmedManager,
              joinDate: now,
              role: const Value('appAdmin'),
              updatedAt: now,
            ),
          );
      await _db.into(_db.appSettings).insertOnConflictUpdate(
            AppSettingsCompanion.insert(key: 'actingAs_$id', value: Value(managerId)),
          );
    }
    final row = await (_db.select(_db.groups)..where((g) => g.id.equals(id))).getSingle();
    return _toDomain(row);
  }

  Future<void> updateGroup(domain.Group group) async {
    await (_db.update(_db.groups)..where((g) => g.id.equals(group.id))).write(
      GroupsCompanion(
        name: Value(group.name),
        type: Value(group.type.name),
        currencySymbol: Value(group.currencySymbol),
        monthStartDay: Value(group.monthStartDay),
        mealEnabled: Value(group.mealEnabled),
        mealLedgerSeparate: Value(group.mealLedgerSeparate),
        defaultNonVoterPolicy: Value(group.defaultNonVoterPolicy.name),
        archived: Value(group.archived),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
    if (group.mealEnabled) {
      final existingSlots = await (_db.select(_db.mealSlots)..where((s) => s.groupId.equals(group.id))).get();
      if (existingSlots.isEmpty) {
        await seedDefaultMealSlots(_db, group.id);
      }
    }
  }

  /// Groups already "brought online" (have an invite code), excluding
  /// archived ones — the set [SyncService] syncs at app open and on the
  /// periodic background task.
  Future<List<domain.Group>> getOnlineGroups() async {
    final rows = await (_db.select(_db.groups)
          ..where((g) => g.inviteCode.isNotNull() & g.archived.equals(false)))
        .get();
    return rows.map(_toDomain).toList();
  }

  Future<void> setArchived(String groupId, bool archived) async {
    await (_db.update(_db.groups)..where((g) => g.id.equals(groupId))).write(
      GroupsCompanion(
        archived: Value(archived),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Records the invite code minted by the server when this mess is
  /// "brought online" — marks the group as online locally.
  Future<void> setInviteCode(String groupId, String inviteCode) async {
    await (_db.update(_db.groups)..where((g) => g.id.equals(groupId))).write(
      GroupsCompanion(
        inviteCode: Value(inviteCode),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Inserts a group row exactly as pulled from the server (used when
  /// joining a mess that only exists remotely so far).
  Future<void> upsertFromRemote(domain.Group group) async {
    await _db.into(_db.groups).insertOnConflictUpdate(
          GroupsCompanion.insert(
            id: group.id,
            name: group.name,
            type: Value(group.type.name),
            currencySymbol: Value(group.currencySymbol),
            monthStartDay: Value(group.monthStartDay),
            mealEnabled: Value(group.mealEnabled),
            mealLedgerSeparate: Value(group.mealLedgerSeparate),
            defaultNonVoterPolicy: Value(group.defaultNonVoterPolicy.name),
            archived: Value(group.archived),
            createdAt: group.createdAt.millisecondsSinceEpoch,
            updatedAt: group.updatedAt.millisecondsSinceEpoch,
            inviteCode: Value(group.inviteCode),
          ),
        );
  }
}
