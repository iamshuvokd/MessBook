/// Pure-Dart balance computation. All amounts in integer paisa.
library;

class MemberBalance {
  const MemberBalance({
    required this.memberId,
    required this.totalPaid,
    required this.totalShare,
    required this.totalDeposits,
    required this.totalSettlementsPaid,
    required this.totalSettlementsReceived,
    this.carriedForward = 0,
  });

  final String memberId;

  /// Sum of amounts this member paid directly for expenses (expense_payers).
  final int totalPaid;

  /// Sum of this member's allocated share of expenses (expense_splits).
  final int totalShare;

  /// Cash this member has handed to the manager (not tied to a specific expense).
  final int totalDeposits;

  /// Settlements this member has paid out to other members.
  final int totalSettlementsPaid;

  /// Settlements this member has received from other members.
  final int totalSettlementsReceived;

  /// Opening balance carried forward from the previous closed month (M6).
  final int carriedForward;

  /// Positive = the group owes this member money. Negative = this member owes the group.
  int get net =>
      totalPaid + totalDeposits - totalShare + totalSettlementsPaid - totalSettlementsReceived + carriedForward;
}

class BalanceEngine {
  const BalanceEngine._();

  /// Computes each member's balance from raw ledger entries.
  ///
  /// [payers] and [splits] are `{memberId: amountPaisa}` sums already
  /// aggregated across all (non-deleted) expenses in the period being
  /// reported. [deposits], [settlementsPaid] and [settlementsReceived] are
  /// likewise pre-aggregated per member.
  static List<MemberBalance> compute({
    required List<String> memberIds,
    required Map<String, int> totalPaidByMember,
    required Map<String, int> totalShareByMember,
    Map<String, int> depositsByMember = const {},
    Map<String, int> settlementsPaidByMember = const {},
    Map<String, int> settlementsReceivedByMember = const {},
    Map<String, int> carriedForwardByMember = const {},
  }) {
    return [
      for (final id in memberIds)
        MemberBalance(
          memberId: id,
          totalPaid: totalPaidByMember[id] ?? 0,
          totalShare: totalShareByMember[id] ?? 0,
          totalDeposits: depositsByMember[id] ?? 0,
          totalSettlementsPaid: settlementsPaidByMember[id] ?? 0,
          totalSettlementsReceived: settlementsReceivedByMember[id] ?? 0,
          carriedForward: carriedForwardByMember[id] ?? 0,
        ),
    ];
  }
}
