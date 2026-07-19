enum SplitType {
  equal,
  unequal,
  shares,
  percent,
  meal;

  static SplitType fromDb(String value) => SplitType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => SplitType.equal,
      );
}

class ExpensePayerEntry {
  const ExpensePayerEntry({required this.memberId, required this.amountPaisa});
  final String memberId;
  final int amountPaisa;
}

class ExpenseSplitEntry {
  const ExpenseSplitEntry({required this.memberId, required this.amountPaisa});
  final String memberId;
  final int amountPaisa;
}

class Expense {
  const Expense({
    required this.id,
    required this.groupId,
    required this.amountPaisa,
    required this.date,
    required this.categoryId,
    this.note,
    this.receiptPath,
    required this.isRecurringInstance,
    required this.deleted,
    required this.updatedAt,
  });

  final String id;
  final String groupId;
  final int amountPaisa;
  final DateTime date;
  final String categoryId;
  final String? note;
  final String? receiptPath;
  final bool isRecurringInstance;
  final bool deleted;
  final DateTime updatedAt;
}

/// Expense joined with its category and payers, for list/detail display.
class ExpenseDetail {
  const ExpenseDetail({
    required this.expense,
    required this.categoryDefaultKey,
    required this.categoryRawName,
    required this.categoryIcon,
    required this.categoryIsMeal,
    required this.payers,
    required this.splitType,
  });

  final Expense expense;
  final String? categoryDefaultKey;
  final String categoryRawName;
  final String categoryIcon;
  final bool categoryIsMeal;
  final List<ExpensePayerEntry> payers;
  final SplitType splitType;
}

/// Full editable state of an expense: the row, its payers and its splits.
class ExpenseDraft {
  const ExpenseDraft({
    required this.expense,
    required this.payers,
    required this.splits,
    required this.splitType,
  });

  final Expense expense;
  final List<ExpensePayerEntry> payers;
  final List<ExpenseSplitEntry> splits;
  final SplitType splitType;
}
