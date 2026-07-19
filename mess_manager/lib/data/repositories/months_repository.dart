import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/ledger_purpose.dart';
import '../../domain/models/month_report.dart';
import '../db/app_database.dart';

const _uuid = Uuid();

String yearMonthKey(DateTime month) =>
    '${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';

/// Month lifecycle per group. Combined-ledger groups only ever touch the
/// general (`closedAt`/`snapshotJson`) pair; groups with `mealLedgerSeparate`
/// close their meal ledger independently via the `mealClosedAt`/
/// `mealSnapshotJson` pair on the same row.
class MonthsRepository {
  MonthsRepository(this._db);

  final AppDatabase _db;

  Stream<List<Month>> watchMonths(String groupId) {
    final query = _db.select(_db.months)
      ..where((m) => m.groupId.equals(groupId))
      ..orderBy([(m) => OrderingTerm.desc(m.yearMonth)]);
    return query.watch();
  }

  Future<Month?> getMonth(String groupId, String yearMonth) {
    return (_db.select(_db.months)
          ..where((m) => m.groupId.equals(groupId) & m.yearMonth.equals(yearMonth)))
        .getSingleOrNull();
  }

  Future<bool> isClosed(String groupId, DateTime month,
      {LedgerPurpose ledger = LedgerPurpose.general}) async {
    final row = await getMonth(groupId, yearMonthKey(month));
    if (row == null) return false;
    return ledger == LedgerPurpose.meal ? row.mealClosedAt != null : row.closedAt != null;
  }

  /// Returns the previous calendar month's closing net balances (memberId ->
  /// paisa) for the given ledger, or an empty map if that ledger's month was
  /// never closed. Used to carry unsettled balances forward into the next
  /// month's opening figures.
  Future<Map<String, int>> previousMonthClosingNets(String groupId, DateTime month,
      {LedgerPurpose ledger = LedgerPurpose.general}) async {
    final prevMonth = DateTime(month.year, month.month - 1, 1);
    final row = await getMonth(groupId, yearMonthKey(prevMonth));
    if (row == null) return {};
    final snapshotJson = ledger == LedgerPurpose.meal ? row.mealSnapshotJson : row.snapshotJson;
    final closedAt = ledger == LedgerPurpose.meal ? row.mealClosedAt : row.closedAt;
    if (closedAt == null || snapshotJson == null) return {};
    final report = MonthReport.fromJson(jsonDecode(snapshotJson) as Map<String, dynamic>);
    return {for (final r in report.rows) r.memberId: r.duePaisa};
  }

  Future<void> closeMonth({
    required String groupId,
    required DateTime month,
    required MonthReport report,
    LedgerPurpose ledger = LedgerPurpose.general,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final key = yearMonthKey(month);
    final existing = await getMonth(groupId, key);
    final snapshotJson = jsonEncode(report.toJson());
    final mealRatePaisa = (report.mealRatePaisaX100 / 100).round();

    final companion = ledger == LedgerPurpose.meal
        ? MonthsCompanion(
            mealClosedAt: Value(now),
            mealRatePaisa: Value(mealRatePaisa),
            mealSnapshotJson: Value(snapshotJson),
          )
        : MonthsCompanion(
            closedAt: Value(now),
            // In combined mode the general snapshot carries the meal rate; in
            // separate mode it's 0 here and must not clobber the meal close's.
            mealRatePaisa: report.mealRatePaisaX100 == 0 ? const Value.absent() : Value(mealRatePaisa),
            snapshotJson: Value(snapshotJson),
          );

    if (existing != null) {
      await (_db.update(_db.months)..where((m) => m.id.equals(existing.id))).write(companion);
    } else {
      await _db.into(_db.months).insert(
            MonthsCompanion.insert(
              id: _uuid.v4(),
              groupId: groupId,
              yearMonth: key,
            ).copyWith(
              closedAt: companion.closedAt,
              mealClosedAt: companion.mealClosedAt,
              mealRatePaisa: companion.mealRatePaisa,
              snapshotJson: companion.snapshotJson,
              mealSnapshotJson: companion.mealSnapshotJson,
            ),
          );
    }
  }
}
