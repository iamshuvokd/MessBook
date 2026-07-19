/// Pure-Dart split calculation engine. All amounts in integer paisa.
///
/// Every split method distributes the exact total with zero drift: the
/// largest-remainder method allocates each member's floor share, then hands
/// the leftover paisa one at a time to the members with the largest
/// fractional remainder (ties broken by input order) until it's gone.
library;

class SplitValidationError implements Exception {
  SplitValidationError(this.message);
  final String message;
  @override
  String toString() => message;
}

class SplitCalculator {
  const SplitCalculator._();

  /// Splits [amountPaisa] equally across [memberIds]. Order of [memberIds]
  /// breaks remainder ties (earlier members get the extra paisa first).
  static Map<String, int> equal(int amountPaisa, List<String> memberIds) {
    if (memberIds.isEmpty) {
      throw SplitValidationError('At least one member is required for an equal split');
    }
    return _byWeights(amountPaisa, {for (final id in memberIds) id: 1});
  }

  /// Splits [amountPaisa] proportionally to integer [shares] per member
  /// (e.g. {a: 2, b: 1} → a gets twice b's share).
  static Map<String, int> byShares(int amountPaisa, Map<String, int> shares) {
    if (shares.isEmpty) {
      throw SplitValidationError('At least one member is required for a shares split');
    }
    if (shares.values.any((s) => s <= 0)) {
      throw SplitValidationError('Shares must be positive');
    }
    return _byWeights(amountPaisa, shares);
  }

  /// Splits [amountPaisa] by percentage per member; percentages must sum to 100
  /// (within a small floating-point tolerance).
  static Map<String, int> byPercent(int amountPaisa, Map<String, double> percents) {
    if (percents.isEmpty) {
      throw SplitValidationError('At least one member is required for a percent split');
    }
    final total = percents.values.fold<double>(0, (a, b) => a + b);
    if ((total - 100).abs() > 0.01) {
      throw SplitValidationError('Percentages must sum to 100 (got ${total.toStringAsFixed(2)})');
    }
    // Scale to integer weights (basis points) so the largest-remainder math stays exact.
    final weights = {for (final e in percents.entries) e.key: (e.value * 100).round()};
    return _byWeights(amountPaisa, weights);
  }

  /// Validates a caller-supplied unequal/manual split: amounts must be
  /// non-negative and sum exactly to [amountPaisa].
  static Map<String, int> unequal(int amountPaisa, Map<String, int> amounts) {
    if (amounts.isEmpty) {
      throw SplitValidationError('At least one member is required for an unequal split');
    }
    if (amounts.values.any((a) => a < 0)) {
      throw SplitValidationError('Split amounts cannot be negative');
    }
    final sum = amounts.values.fold<int>(0, (a, b) => a + b);
    if (sum != amountPaisa) {
      throw SplitValidationError('Split amounts (৳${sum / 100}) must sum to the expense total (৳${amountPaisa / 100})');
    }
    return Map.of(amounts);
  }

  /// Splits [amountPaisa] by each member's meal count (own + guest meals)
  /// relative to the group's total meals in the period.
  static Map<String, int> byMeals(int amountPaisa, Map<String, double> mealCounts) {
    if (mealCounts.isEmpty) {
      throw SplitValidationError('At least one member is required for a meal-based split');
    }
    final totalMeals = mealCounts.values.fold<double>(0, (a, b) => a + b);
    if (totalMeals <= 0) {
      // No meals recorded yet — split falls back to equal to avoid a div-by-zero.
      return equal(amountPaisa, mealCounts.keys.toList());
    }
    // Scale meal counts (which may be fractional, e.g. 0.5) to integer weights.
    final weights = {for (final e in mealCounts.entries) e.key: (e.value * 100).round()};
    return _byWeights(amountPaisa, weights);
  }

  /// Core largest-remainder allocator: distributes [amountPaisa] proportionally
  /// to [weights], guaranteeing the output sums exactly to [amountPaisa].
  static Map<String, int> _byWeights(int amountPaisa, Map<String, int> weights) {
    final totalWeight = weights.values.fold<int>(0, (a, b) => a + b);
    if (totalWeight <= 0) {
      throw SplitValidationError('Total weight must be positive');
    }

    final keys = weights.keys.toList();
    final floors = <String, int>{};
    final remainders = <String, int>{}; // remainder numerator, out of totalWeight

    var allocated = 0;
    for (final key in keys) {
      final weight = weights[key]!;
      final raw = amountPaisa * weight; // stays integer; avoid float drift
      final floor = raw ~/ totalWeight;
      floors[key] = floor;
      remainders[key] = raw % totalWeight;
      allocated += floor;
    }

    var leftover = amountPaisa - allocated;

    // Largest remainder first; stable tie-break by original key order.
    final order = List<String>.from(keys)
      ..sort((a, b) {
        final cmp = remainders[b]!.compareTo(remainders[a]!);
        if (cmp != 0) return cmp;
        return keys.indexOf(a).compareTo(keys.indexOf(b));
      });

    var i = 0;
    while (leftover > 0) {
      final key = order[i % order.length];
      floors[key] = floors[key]! + 1;
      leftover -= 1;
      i += 1;
    }

    return floors;
  }
}
