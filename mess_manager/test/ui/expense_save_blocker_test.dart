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
    bool paidFromFund = false,
  }) =>
      expenseSaveBlocker(
        amountPaisa: amount,
        hasCategory: hasCategory,
        hasPayer: hasPayer,
        payersSumPaisa: payersSum ?? amount,
        splitsSumPaisa: splitsSum,
        paidFromFund: paidFromFund,
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

  // This mess collects deposits up front and the manager spends from that
  // pot, so a bazar expense has no individual payer to name. Requiring one
  // made those expenses impossible to save.
  group('paid from the mess fund', () {
    test('saves with no payer at all', () {
      expect(blockerFor(paidFromFund: true, hasPayer: false, payersSum: 0), ExpenseSaveBlocker.none);
    });

    test('does not demand that payer amounts add up, since there are none', () {
      expect(blockerFor(paidFromFund: true, hasPayer: false, payersSum: 0, splitsSum: 10000),
          ExpenseSaveBlocker.none);
    });

    test('still enforces the amount, category and split rules', () {
      expect(blockerFor(paidFromFund: true, hasPayer: false, amount: 0), ExpenseSaveBlocker.amount);
      expect(blockerFor(paidFromFund: true, hasPayer: false, hasCategory: false), ExpenseSaveBlocker.category);
      expect(blockerFor(paidFromFund: true, hasPayer: false, splitsSum: null), ExpenseSaveBlocker.split);
      expect(blockerFor(paidFromFund: true, hasPayer: false, splitsSum: 9000), ExpenseSaveBlocker.splitSum);
    });

    test('a member-paid expense still requires a payer', () {
      expect(blockerFor(paidFromFund: false, hasPayer: false), ExpenseSaveBlocker.payer);
      expect(blockerFor(paidFromFund: false, payersSum: 5000), ExpenseSaveBlocker.payerSum);
    });
  });

  group('defaultPaidFromFundForCategory', () {
    test('bazar/meal categories default to the mess fund', () {
      expect(defaultPaidFromFundForCategory(isMealCategory: true), isTrue);
    });

    test('rent/wifi and friends default to a member paying', () {
      expect(defaultPaidFromFundForCategory(isMealCategory: false), isFalse);
    });
  });
}
