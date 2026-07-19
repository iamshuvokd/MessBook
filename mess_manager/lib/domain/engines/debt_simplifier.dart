/// Reduces a set of net balances to the minimal number of settling
/// transactions, using greedy max-creditor/max-debtor matching.
library;

class DebtTransaction {
  const DebtTransaction({required this.fromMemberId, required this.toMemberId, required this.amountPaisa});

  final String fromMemberId;
  final String toMemberId;
  final int amountPaisa;
}

class DebtSimplifier {
  const DebtSimplifier._();

  /// [netBalances] maps memberId to net paisa (positive = owed money,
  /// negative = owes money). Entries at exactly zero are ignored.
  ///
  /// Returns transactions where the debtor (negative net) pays the creditor
  /// (positive net) the minimum amount needed to zero out the larger side of
  /// each pair, repeated until all balances settle. The sum of transaction
  /// amounts always equals the sum of the positive balances.
  static List<DebtTransaction> simplify(Map<String, int> netBalances) {
    final creditors = <MapEntry<String, int>>[];
    final debtors = <MapEntry<String, int>>[];
    for (final entry in netBalances.entries) {
      if (entry.value > 0) {
        creditors.add(entry);
      } else if (entry.value < 0) {
        debtors.add(MapEntry(entry.key, -entry.value)); // store debt as positive magnitude
      }
    }

    final transactions = <DebtTransaction>[];

    while (creditors.isNotEmpty && debtors.isNotEmpty) {
      creditors.sort((a, b) => b.value.compareTo(a.value));
      debtors.sort((a, b) => b.value.compareTo(a.value));

      final creditor = creditors.first;
      final debtor = debtors.first;
      final amount = creditor.value < debtor.value ? creditor.value : debtor.value;

      transactions.add(DebtTransaction(fromMemberId: debtor.key, toMemberId: creditor.key, amountPaisa: amount));

      creditors[0] = MapEntry(creditor.key, creditor.value - amount);
      debtors[0] = MapEntry(debtor.key, debtor.value - amount);

      creditors.removeWhere((e) => e.value == 0);
      debtors.removeWhere((e) => e.value == 0);
    }

    return transactions;
  }
}
