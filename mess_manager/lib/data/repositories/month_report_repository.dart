import 'package:drift/drift.dart';

import '../../domain/engines/balance_engine.dart';
import '../../domain/engines/meal_rate_engine.dart';
import '../../domain/models/ledger_purpose.dart';
import '../../domain/models/month_report.dart';
import '../db/app_database.dart';
import 'months_repository.dart';

/// Builds the month summary. With [ledger] null everything is combined
/// (single-ledger groups). With a ledger passed (groups that keep the meal
/// system separate), only that ledger's expenses, deposits, settlements and
/// carry-forward are included: meal-category expenses belong to the meal
/// ledger, everything else to general. Meal counts/rate only appear on the
/// combined or meal reports — the general report has no meal component.
class MonthReportRepository {
  MonthReportRepository(this._db) : _monthsRepository = MonthsRepository(_db);

  final AppDatabase _db;
  final MonthsRepository _monthsRepository;

  Future<MonthReport> compute(String groupId, DateTime month, {LedgerPurpose? ledger}) async {
    final monthStart = DateTime(month.year, month.month, 1);
    final monthEnd = DateTime(month.year, month.month + 1, 1);
    final startKey = monthStart.millisecondsSinceEpoch;
    final endKey = monthEnd.millisecondsSinceEpoch;

    final members = await (_db.select(_db.members)
          ..where((m) => m.groupId.equals(groupId) & m.active.equals(true)))
        .get();
    final memberIds = members.map((m) => m.id).toList();

    final categoriesById = <String, Category>{
      for (final c in await _db.select(_db.categories).get()) c.id: c,
    };
    bool isMealExpense(Expense e) => categoriesById[e.categoryId]?.isMealCategory ?? false;

    final allExpenseRows = await (_db.select(_db.expenses)
          ..where((e) =>
              e.groupId.equals(groupId) &
              e.deleted.equals(false) &
              e.date.isBiggerOrEqualValue(startKey) &
              e.date.isSmallerThanValue(endKey)))
        .get();
    final expenseRows = switch (ledger) {
      null => allExpenseRows,
      LedgerPurpose.meal => allExpenseRows.where(isMealExpense).toList(),
      LedgerPurpose.general => allExpenseRows.where((e) => !isMealExpense(e)).toList(),
    };
    final expenseIds = expenseRows.map((e) => e.id).toList();

    final totalPaid = <String, int>{};
    final totalShare = <String, int>{};
    if (expenseIds.isNotEmpty) {
      final payerRows = await (_db.select(_db.expensePayers)..where((p) => p.expenseId.isIn(expenseIds))).get();
      for (final p in payerRows) {
        totalPaid[p.memberId] = (totalPaid[p.memberId] ?? 0) + p.amountPaidPaisa;
      }
      final splitRows = await (_db.select(_db.expenseSplits)..where((s) => s.expenseId.isIn(expenseIds))).get();
      for (final s in splitRows) {
        totalShare[s.memberId] = (totalShare[s.memberId] ?? 0) + s.amountPaisa;
      }
    }

    final totalMealExpense = expenseRows.where(isMealExpense).fold<int>(0, (a, e) => a + e.amountPaisa);
    final totalSpent = expenseRows.fold<int>(0, (a, e) => a + e.amountPaisa);

    final includeMeals = ledger != LedgerPurpose.general;
    final mealCounts = <String, double>{for (final id in memberIds) id: 0};
    if (includeMeals) {
      final mealRows = await (_db.select(_db.meals)
            ..where((m) =>
                m.groupId.equals(groupId) &
                m.date.isBiggerOrEqualValue(startKey) &
                m.date.isSmallerThanValue(endKey)))
          .get();
      for (final m in mealRows) {
        mealCounts[m.memberId] = (mealCounts[m.memberId] ?? 0) + m.count + m.guestCount;
      }
    }
    final mealResult = MealRateEngine.compute(totalMealExpensePaisa: totalMealExpense, memberMealCounts: mealCounts);

    var depositQuery = _db.select(_db.deposits)
      ..where((d) => d.groupId.equals(groupId) & d.date.isBiggerOrEqualValue(startKey) & d.date.isSmallerThanValue(endKey));
    if (ledger != null) {
      depositQuery = depositQuery..where((d) => d.purpose.equals(ledger.name));
    }
    final depositRows = await depositQuery.get();
    final deposits = <String, int>{};
    for (final d in depositRows) {
      deposits[d.memberId] = (deposits[d.memberId] ?? 0) + d.amountPaisa;
    }

    var settlementQuery = _db.select(_db.settlements)
      ..where((s) => s.groupId.equals(groupId) & s.date.isBiggerOrEqualValue(startKey) & s.date.isSmallerThanValue(endKey));
    if (ledger != null) {
      settlementQuery = settlementQuery..where((s) => s.purpose.equals(ledger.name));
    }
    final settlementRows = await settlementQuery.get();
    final settlementsPaid = <String, int>{};
    final settlementsReceived = <String, int>{};
    for (final s in settlementRows) {
      settlementsPaid[s.fromMemberId] = (settlementsPaid[s.fromMemberId] ?? 0) + s.amountPaisa;
      settlementsReceived[s.toMemberId] = (settlementsReceived[s.toMemberId] ?? 0) + s.amountPaisa;
    }

    final carriedForward = await _monthsRepository.previousMonthClosingNets(
      groupId,
      month,
      ledger: ledger ?? LedgerPurpose.general,
    );

    final balances = BalanceEngine.compute(
      memberIds: memberIds,
      totalPaidByMember: totalPaid,
      totalShareByMember: totalShare,
      depositsByMember: deposits,
      settlementsPaidByMember: settlementsPaid,
      settlementsReceivedByMember: settlementsReceived,
      carriedForwardByMember: carriedForward,
    );
    final balanceByMember = {for (final b in balances) b.memberId: b};

    final rows = [
      for (final id in memberIds)
        MonthReportRow(
          memberId: id,
          meals: mealCounts[id] ?? 0,
          mealBillPaisa: mealResult.memberBillsPaisa[id] ?? 0,
          sharedCostsPaisa: totalShare[id] ?? 0,
          paidPlusDepositsPaisa: (totalPaid[id] ?? 0) + (deposits[id] ?? 0),
          duePaisa: balanceByMember[id]?.net ?? 0,
        ),
    ];

    return MonthReport(
      yearMonth: yearMonthKey(month),
      totalSpentPaisa: totalSpent,
      totalMeals: mealCounts.values.fold<double>(0, (a, b) => a + b),
      mealRatePaisaX100: mealResult.mealRatePaisaX100,
      rows: rows,
    );
  }
}
