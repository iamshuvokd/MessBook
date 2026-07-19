import 'package:drift/drift.dart';

import '../../domain/engines/balance_engine.dart';
import '../../domain/engines/debt_simplifier.dart';
import '../../domain/models/ledger_purpose.dart';
import '../db/app_database.dart';

/// Aggregates expenses, deposits and settlements into per-member balances
/// and a minimal settle-up transaction list. Computes across the group's
/// full (non-deleted) history — month-window scoping arrives with M6.
///
/// When [ledger] is passed, only that ledger's entries are counted (used by
/// groups with `mealLedgerSeparate` on): the meal ledger contains
/// meal-category expenses plus deposits/settlements marked `purpose='meal'`;
/// the general ledger contains everything else. With [ledger] null the whole
/// history is combined, exactly the single-ledger behavior.
class BalancesRepository {
  BalancesRepository(this._db);

  final AppDatabase _db;

  Future<Set<String>> _mealCategoryIds() async {
    final rows = await (_db.select(_db.categories)..where((c) => c.isMealCategory.equals(true))).get();
    return rows.map((c) => c.id).toSet();
  }

  Future<List<MemberBalance>> computeBalances(String groupId, {LedgerPurpose? ledger}) async {
    final members = await (_db.select(_db.members)
          ..where((m) => m.groupId.equals(groupId) & m.active.equals(true)))
        .get();
    final memberIds = members.map((m) => m.id).toList();

    var expenseQuery = _db.select(_db.expenses)
      ..where((e) => e.groupId.equals(groupId) & e.deleted.equals(false));
    final expenseRows = await expenseQuery.get();

    List<String> expenseIds;
    if (ledger == null) {
      expenseIds = expenseRows.map((e) => e.id).toList();
    } else {
      final mealCategories = await _mealCategoryIds();
      expenseIds = expenseRows
          .where((e) => mealCategories.contains(e.categoryId) == (ledger == LedgerPurpose.meal))
          .map((e) => e.id)
          .toList();
    }

    final totalPaid = <String, int>{};
    final totalShare = <String, int>{};

    if (expenseIds.isNotEmpty) {
      final payerRows =
          await (_db.select(_db.expensePayers)..where((p) => p.expenseId.isIn(expenseIds))).get();
      for (final p in payerRows) {
        totalPaid[p.memberId] = (totalPaid[p.memberId] ?? 0) + p.amountPaidPaisa;
      }
      final splitRows =
          await (_db.select(_db.expenseSplits)..where((s) => s.expenseId.isIn(expenseIds))).get();
      for (final s in splitRows) {
        totalShare[s.memberId] = (totalShare[s.memberId] ?? 0) + s.amountPaisa;
      }
    }

    var depositQuery = _db.select(_db.deposits)..where((d) => d.groupId.equals(groupId));
    if (ledger != null) {
      depositQuery = depositQuery..where((d) => d.purpose.equals(ledger.name));
    }
    final depositRows = await depositQuery.get();
    final deposits = <String, int>{};
    for (final d in depositRows) {
      deposits[d.memberId] = (deposits[d.memberId] ?? 0) + d.amountPaisa;
    }

    var settlementQuery = _db.select(_db.settlements)..where((s) => s.groupId.equals(groupId));
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

    return BalanceEngine.compute(
      memberIds: memberIds,
      totalPaidByMember: totalPaid,
      totalShareByMember: totalShare,
      depositsByMember: deposits,
      settlementsPaidByMember: settlementsPaid,
      settlementsReceivedByMember: settlementsReceived,
    );
  }

  Future<List<DebtTransaction>> computeSimplifiedDebts(String groupId, {LedgerPurpose? ledger}) async {
    final balances = await computeBalances(groupId, ledger: ledger);
    final netByMember = {for (final b in balances) b.memberId: b.net};
    return DebtSimplifier.simplify(netByMember);
  }
}
