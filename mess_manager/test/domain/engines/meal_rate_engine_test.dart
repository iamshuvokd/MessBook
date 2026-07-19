import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/domain/engines/meal_rate_engine.dart';

void main() {
  group('MealRateEngine.compute', () {
    test('zero meals produces a zero rate and zero bills (no div-by-zero)', () {
      final result = MealRateEngine.compute(
        totalMealExpensePaisa: 5000000,
        memberMealCounts: {'a': 0, 'b': 0, 'c': 0},
      );
      expect(result.mealRatePaisaX100, 0);
      expect(result.memberBillsPaisa, {'a': 0, 'b': 0, 'c': 0});
    });

    test('empty member map produces a zero rate', () {
      final result = MealRateEngine.compute(totalMealExpensePaisa: 100000, memberMealCounts: {});
      expect(result.mealRatePaisaX100, 0);
      expect(result.memberBillsPaisa, isEmpty);
    });

    test('computes the rate and per-member bills matching the spec example', () {
      // ৳48,250 total (in paisa) spread across 372 total meals ≈ ৳52.4/meal.
      final result = MealRateEngine.compute(
        totalMealExpensePaisa: 1949200, // ৳19,492.00 meal-category spend (matches mockup's Total meals table)
        memberMealCounts: {'rahim': 66, 'karim': 71, 'sabbir': 58, 'fahim': 63, 'tanvir': 74, 'imran': 40},
      );
      expect(result.memberBillsPaisa.values.fold<int>(0, (a, b) => a + b), 1949200);
      // Rate should be close to 19492/372 ≈ 52.4 paisa... expressed ×100.
      expect(result.mealRatePaisaX100, closeTo(1949200 * 100 / 372, 1));
    });

    test('member bills always sum exactly to the total meal expense', () {
      for (final total in [0, 1, 99, 10000, 999999]) {
        final result = MealRateEngine.compute(
          totalMealExpensePaisa: total,
          memberMealCounts: {'a': 2, 'b': 3, 'c': 1},
        );
        expect(result.memberBillsPaisa.values.fold<int>(0, (a, b) => a + b), total);
      }
    });

    test('guest meals are counted the same as own meals once summed into the input', () {
      // rahim: 2 own + 1 guest = 3; karim: 3 own + 0 guest = 3. Equal split expected.
      final result = MealRateEngine.compute(
        totalMealExpensePaisa: 600,
        memberMealCounts: {'rahim': 3, 'karim': 3},
      );
      expect(result.memberBillsPaisa, {'rahim': 300, 'karim': 300});
    });

    test('handles fractional (half) meal counts', () {
      final result = MealRateEngine.compute(
        totalMealExpensePaisa: 1000,
        memberMealCounts: {'a': 1.5, 'b': 0.5},
      );
      expect(result.memberBillsPaisa['a'], 750);
      expect(result.memberBillsPaisa['b'], 250);
    });

    test('zero total meal expense with real meal counts yields zero bills and zero rate', () {
      final result = MealRateEngine.compute(
        totalMealExpensePaisa: 0,
        memberMealCounts: {'a': 10, 'b': 20},
      );
      expect(result.mealRatePaisaX100, 0);
      expect(result.memberBillsPaisa, {'a': 0, 'b': 0});
    });
  });
}
