import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/bazar_duty.dart' as domain;
import '../db/app_database.dart';

const _uuid = Uuid();

/// Bazar (grocery) duty roster per group. A plain schedule of who shops
/// when — no money involved; recording the actual cost stays in Expenses.
class BazarRepository {
  BazarRepository(this._db);

  final AppDatabase _db;

  domain.BazarDuty _toDomain(BazarDuty row) => domain.BazarDuty(
        id: row.id,
        groupId: row.groupId,
        memberId: row.memberId,
        date: DateTime.fromMillisecondsSinceEpoch(row.date),
        note: row.note,
        done: row.done,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  int _dayKey(DateTime d) => DateTime(d.year, d.month, d.day).millisecondsSinceEpoch;

  /// All duties for the group, soonest date first.
  Stream<List<domain.BazarDuty>> watchDuties(String groupId) {
    final query = _db.select(_db.bazarDuties)
      ..where((b) => b.groupId.equals(groupId))
      ..orderBy([(b) => OrderingTerm.asc(b.date)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> addDuty({
    required String groupId,
    required String memberId,
    required DateTime date,
    String? note,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.bazarDuties).insert(
          BazarDutiesCompanion.insert(
            id: _uuid.v4(),
            groupId: groupId,
            memberId: memberId,
            date: _dayKey(date),
            note: Value(note),
            updatedAt: now,
          ),
        );
  }

  Future<void> setDone(String dutyId, bool done) async {
    await (_db.update(_db.bazarDuties)..where((b) => b.id.equals(dutyId))).write(
      BazarDutiesCompanion(
        done: Value(done),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> deleteDuty(String dutyId) async {
    await (_db.delete(_db.bazarDuties)..where((b) => b.id.equals(dutyId))).go();
  }
}
