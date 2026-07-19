import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/ledger_purpose.dart';
import '../../domain/models/settlement.dart' as domain;
import '../db/app_database.dart';

const _uuid = Uuid();

class SettlementsRepository {
  SettlementsRepository(this._db);

  final AppDatabase _db;

  domain.Settlement _toDomain(Settlement row) => domain.Settlement(
        id: row.id,
        groupId: row.groupId,
        fromMemberId: row.fromMemberId,
        toMemberId: row.toMemberId,
        amountPaisa: row.amountPaisa,
        date: DateTime.fromMillisecondsSinceEpoch(row.date),
        method: row.method,
        note: row.note,
        purpose: LedgerPurpose.fromDb(row.purpose),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  Stream<List<domain.Settlement>> watchSettlements(String groupId) {
    final query = _db.select(_db.settlements)
      ..where((s) => s.groupId.equals(groupId))
      ..orderBy([(s) => OrderingTerm.desc(s.date)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> recordSettlement({
    required String groupId,
    required String fromMemberId,
    required String toMemberId,
    required int amountPaisa,
    DateTime? date,
    String? method,
    String? note,
    LedgerPurpose purpose = LedgerPurpose.general,
  }) async {
    final now = DateTime.now();
    await _db.into(_db.settlements).insert(
          SettlementsCompanion.insert(
            id: _uuid.v4(),
            groupId: groupId,
            fromMemberId: fromMemberId,
            toMemberId: toMemberId,
            amountPaisa: amountPaisa,
            date: (date ?? now).millisecondsSinceEpoch,
            method: Value(method),
            note: Value(note),
            purpose: Value(purpose.name),
            updatedAt: now.millisecondsSinceEpoch,
          ),
        );
  }
}
