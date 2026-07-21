import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/domain/models/expense.dart';
import 'package:mess_manager/ui/screens/expenses/add_edit_expense_screen.dart';

void main() {
  test('a meal category (bazar/grocery) defaults to a by-meals split', () {
    // This is what makes "meal rate x my meals, deducted from my deposit"
    // the actual behavior instead of everyone paying an equal share.
    expect(defaultSplitForCategory(isMealCategory: true), SplitType.meal);
  });

  test('a non-meal category (rent, wifi) stays an equal split', () {
    expect(defaultSplitForCategory(isMealCategory: false), SplitType.equal);
  });
}
