import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/deposit.dart' as domain;
import '../../domain/models/ledger_purpose.dart';
import '../db/app_database.dart';

const _uuid = Uuid();

class DepositsRepository {
  DepositsRepository(this._db);

  final AppDatabase _db;

  domain.Deposit _toDomain(Deposit row) => domain.Deposit(
        id: row.id,
        groupId: row.groupId,
        memberId: row.memberId,
        amountPaisa: row.amountPaisa,
        date: DateTime.fromMillisecondsSinceEpoch(row.date),
        note: row.note,
        purpose: LedgerPurpose.fromDb(row.purpose),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  Stream<List<domain.Deposit>> watchDeposits(String groupId) {
    final query = _db.select(_db.deposits)
      ..where((d) => d.groupId.equals(groupId))
      ..orderBy([(d) => OrderingTerm.desc(d.date)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> addDeposit({
    required String groupId,
    required String memberId,
    required int amountPaisa,
    DateTime? date,
    String? note,
    LedgerPurpose purpose = LedgerPurpose.general,
  }) async {
    final now = DateTime.now();
    await _db.into(_db.deposits).insert(
          DepositsCompanion.insert(
            id: _uuid.v4(),
            groupId: groupId,
            memberId: memberId,
            amountPaisa: amountPaisa,
            date: (date ?? now).millisecondsSinceEpoch,
            note: Value(note),
            purpose: Value(purpose.name),
            updatedAt: now.millisecondsSinceEpoch,
          ),
        );
  }

  Future<void> deleteDeposit(String id) async {
    await (_db.delete(_db.deposits)..where((d) => d.id.equals(id))).go();
  }
}
