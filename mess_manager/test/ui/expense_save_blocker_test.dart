import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/ui/screens/expenses/add_edit_expense_screen.dart';

void main() {
  // A fully valid expense: ৳100 paid by one member, split to add up exactly.
  ExpenseSaveBlocker blockerFor({
    int amount = 10000,
    bool hasCategory = true,
    bool hasPayer = true,
    int? payersSum,
    int? splitsSum = 10000,
  }) =>
      expenseSaveBlocker(
        amountPaisa: amount,
        hasCategory: hasCategory,
        hasPayer: hasPayer,
        payersSumPaisa: payersSum ?? amount,
        splitsSumPaisa: splitsSum,
      );

  test('a complete expense has nothing blocking Save', () {
    expect(blockerFor(), ExpenseSaveBlocker.none);
  });

  test('reports the missing amount first', () {
    expect(blockerFor(amount: 0), ExpenseSaveBlocker.amount);
  });

  test('reports a missing category', () {
    expect(blockerFor(hasCategory: false), ExpenseSaveBlocker.category);
  });

  test('reports a missing payer', () {
    expect(blockerFor(hasPayer: false), ExpenseSaveBlocker.payer);
  });

  test('reports payer amounts that do not add up to the total', () {
    expect(blockerFor(payersSum: 9000), ExpenseSaveBlocker.payerSum);
  });

  test('reports an unconfigured split — the trap that used to leave Save dead', () {
    expect(blockerFor(splitsSum: null), ExpenseSaveBlocker.split);
  });

  test('reports a split that does not add up to the total', () {
    expect(blockerFor(splitsSum: 9500), ExpenseSaveBlocker.splitSum);
  });

  test('surfaces the earliest problem when several are wrong at once', () {
    // Nothing filled in at all should point at the amount, not the split.
    expect(
      expenseSaveBlocker(
        amountPaisa: 0,
        hasCategory: false,
        hasPayer: false,
        payersSumPaisa: 0,
        splitsSumPaisa: null,
      ),
      ExpenseSaveBlocker.amount,
    );
  });
}
