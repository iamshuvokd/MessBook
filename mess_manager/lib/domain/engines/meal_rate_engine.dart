import 'split_calculator.dart';

/// mealRatePaisa is the price of one meal, expressed as paisa scaled by
/// 100 for precision (i.e. actual rate = mealRatePaisaX100 / 100, paisa).
/// Kept as an int so the engine never touches floating point for money.
class MealRateResult {
  const MealRateResult({required this.mealRatePaisaX100, required this.memberBillsPaisa});

  /// Meal rate in paisa, scaled ×100 for two decimal places of precision
  /// (e.g. a rate of 52.4 paisa/meal is stored as 5240). Zero when there
  /// were no meals in the period.
  final int mealRatePaisaX100;

  /// Each member's meal bill in paisa; sums exactly to the total meal
  /// expense (or to zero when there were no meals).
  final Map<String, int> memberBillsPaisa;
}

class MealRateEngine {
  const MealRateEngine._();

  /// [totalMealExpensePaisa] is the sum of all expenses in meal-flagged
  /// categories for the period. [memberMealCounts] is each member's own +
  /// guest meal count for the same period (fractional counts allowed, e.g.
  /// 0.5 for a half meal).
  static MealRateResult compute({
    required int totalMealExpensePaisa,
    required Map<String, double> memberMealCounts,
  }) {
    final totalMeals = memberMealCounts.values.fold<double>(0, (a, b) => a + b);

    if (totalMeals <= 0) {
      return MealRateResult(
        mealRatePaisaX100: 0,
        memberBillsPaisa: {for (final id in memberMealCounts.keys) id: 0},
      );
    }

    final ratePaisaX100 = (totalMealExpensePaisa * 100 / totalMeals).round();

    final bills = totalMealExpensePaisa == 0
        ? {for (final id in memberMealCounts.keys) id: 0}
        : SplitCalculator.byMeals(totalMealExpensePaisa, memberMealCounts);

    return MealRateResult(mealRatePaisaX100: ratePaisaX100, memberBillsPaisa: bills);
  }
}
