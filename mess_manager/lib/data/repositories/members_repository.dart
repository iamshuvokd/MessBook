import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/member.dart' as domain;
import '../../domain/models/member_permission.dart';
import '../db/app_database.dart';

const _uuid = Uuid();

/// Name + phone pulled from a picked phone contact, used for bulk import.
typedef ContactDraft = ({String name, String? phone});

class MembersRepository {
  MembersRepository(this._db);

  final AppDatabase _db;

  domain.Member _toDomain(Member row) => domain.Member(
        id: row.id,
        groupId: row.groupId,
        name: row.name,
        phone: row.phone,
        photoPath: row.photoPath,
        joinDate: DateTime.fromMillisecondsSinceEpoch(row.joinDate),
        leaveDate: row.leaveDate == null ? null : DateTime.fromMillisecondsSinceEpoch(row.leaveDate!),
        active: row.active,
        role: MemberRole.fromDb(row.role),
        permissions: MemberPermission.setFromDb(row.permissions),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  Stream<List<domain.Member>> watchMembers(String groupId, {bool activeOnly = false}) {
    final query = _db.select(_db.members)..where((m) => m.groupId.equals(groupId));
    if (activeOnly) {
      query.where((m) => m.active.equals(true));
    }
    query.orderBy([(m) => OrderingTerm.asc(m.joinDate)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<domain.Member> addMember({
    required String groupId,
    required String name,
    String? phone,
    DateTime? joinDate,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    // The first member added to a fresh group is, in practice, the mess
    // owner — make them App Admin automatically so the group always has one.
    final existingCount = await (_db.selectOnly(_db.members)
          ..addColumns([_db.members.id.count()])
          ..where(_db.members.groupId.equals(groupId)))
        .map((row) => row.read(_db.members.id.count()) ?? 0)
        .getSingle();
    final role = existingCount == 0 ? MemberRole.appAdmin : MemberRole.member;

    await _db.into(_db.members).insert(
          MembersCompanion.insert(
            id: id,
            groupId: groupId,
            name: name,
            phone: Value(phone),
            joinDate: (joinDate ?? now).millisecondsSinceEpoch,
            role: Value(role.name),
            updatedAt: now.millisecondsSinceEpoch,
          ),
        );
    final row = await (_db.select(_db.members)..where((m) => m.id.equals(id))).getSingle();
    return _toDomain(row);
  }

  /// Bulk-inserts members picked from the phone contact book.
  Future<void> addMembersFromContacts(String groupId, List<ContactDraft> contacts) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.batch((batch) {
      batch.insertAll(
        _db.members,
        [
          for (final c in contacts)
            MembersCompanion.insert(
              id: _uuid.v4(),
              groupId: groupId,
              name: c.name,
              phone: Value(c.phone),
              joinDate: now,
              updatedAt: now,
            ),
        ],
      );
    });
  }

  Future<void> updateMember(domain.Member member) async {
    await (_db.update(_db.members)..where((m) => m.id.equals(member.id))).write(
      MembersCompanion(
        name: Value(member.name),
        phone: Value(member.phone),
        photoPath: Value(member.photoPath),
        leaveDate: Value(member.leaveDate?.millisecondsSinceEpoch),
        active: Value(member.active),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> deactivateMember(String memberId, {DateTime? leaveDate}) async {
    await (_db.update(_db.members)..where((m) => m.id.equals(memberId))).write(
      MembersCompanion(
        active: const Value(false),
        leaveDate: Value((leaveDate ?? DateTime.now()).millisecondsSinceEpoch),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> reactivateMember(String memberId) async {
    await (_db.update(_db.members)..where((m) => m.id.equals(memberId))).write(
      MembersCompanion(
        active: const Value(true),
        leaveDate: const Value(null),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Assigns a role. Setting `appAdmin` clears that member's explicit
  /// permission flags (the role alone grants everything); demoting away
  /// from `appAdmin` clears them too, so a fresh grant is deliberate.
  Future<void> setRole(String memberId, MemberRole role, {Set<MemberPermission>? permissions}) async {
    await (_db.update(_db.members)..where((m) => m.id.equals(memberId))).write(
      MembersCompanion(
        role: Value(role.name),
        permissions: Value(role == MemberRole.subAdmin ? MemberPermission.setToDb(permissions ?? const {}) : ''),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> setPermissions(String memberId, Set<MemberPermission> permissions) async {
    await (_db.update(_db.members)..where((m) => m.id.equals(memberId))).write(
      MembersCompanion(
        permissions: Value(MemberPermission.setToDb(permissions)),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// True if this member has any meal, expense, deposit, settlement, or poll
  /// record attached — i.e. deleting them would orphan real mess history.
  /// Deactivating is always safe; permanently deleting is only offered when
  /// this comes back false, so the ledger can never be corrupted.
  Future<bool> hasHistory(String memberId) async {
    final counts = await Future.wait([
      (_db.selectOnly(_db.expensePayers)..addColumns([_db.expensePayers.expenseId.count()])..where(_db.expensePayers.memberId.equals(memberId))).map((r) => r.read(_db.expensePayers.expenseId.count()) ?? 0).getSingle(),
      (_db.selectOnly(_db.expenseSplits)..addColumns([_db.expenseSplits.expenseId.count()])..where(_db.expenseSplits.memberId.equals(memberId))).map((r) => r.read(_db.expenseSplits.expenseId.count()) ?? 0).getSingle(),
      (_db.selectOnly(_db.meals)..addColumns([_db.meals.id.count()])..where(_db.meals.memberId.equals(memberId))).map((r) => r.read(_db.meals.id.count()) ?? 0).getSingle(),
      (_db.selectOnly(_db.deposits)..addColumns([_db.deposits.id.count()])..where(_db.deposits.memberId.equals(memberId))).map((r) => r.read(_db.deposits.id.count()) ?? 0).getSingle(),
      (_db.selectOnly(_db.settlements)..addColumns([_db.settlements.id.count()])..where(_db.settlements.fromMemberId.equals(memberId) | _db.settlements.toMemberId.equals(memberId))).map((r) => r.read(_db.settlements.id.count()) ?? 0).getSingle(),
      (_db.selectOnly(_db.mealPolls)..addColumns([_db.mealPolls.id.count()])..where(_db.mealPolls.createdByMemberId.equals(memberId))).map((r) => r.read(_db.mealPolls.id.count()) ?? 0).getSingle(),
      (_db.selectOnly(_db.mealPollVotes)..addColumns([_db.mealPollVotes.pollId.count()])..where(_db.mealPollVotes.memberId.equals(memberId))).map((r) => r.read(_db.mealPollVotes.pollId.count()) ?? 0).getSingle(),
    ]);
    return counts.any((c) => c > 0);
  }

  /// Permanently removes a member added by mistake. Refuses (returns false,
  /// no change made) if [hasHistory] is true — history-bearing members can
  /// only be deactivated, never deleted, so past meals/expenses/settlements
  /// always still resolve to a real name.
  Future<bool> deleteMemberPermanently(String memberId) async {
    if (await hasHistory(memberId)) return false;
    await _db.transaction(() async {
      await (_db.delete(_db.memberMealRoutines)..where((t) => t.memberId.equals(memberId))).go();
      await (_db.delete(_db.mealLeaves)..where((t) => t.memberId.equals(memberId))).go();
      await (_db.delete(_db.members)..where((m) => m.id.equals(memberId))).go();
    });
    return true;
  }
}
