import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/domain/engines/split_calculator.dart';

void main() {
  group('SplitCalculator.equal', () {
    test('divides evenly when the amount is a multiple of member count', () {
      final result = SplitCalculator.equal(300, ['a', 'b', 'c']);
      expect(result, {'a': 100, 'b': 100, 'c': 100});
      expect(result.values.fold<int>(0, (a, b) => a + b), 300);
    });

    test('100 ÷ 3 sums exactly and distributes the remainder deterministically', () {
      final result = SplitCalculator.equal(100, ['a', 'b', 'c']);
      expect(result.values.fold<int>(0, (a, b) => a + b), 100);
      // Each share is within 1 paisa of the others; exactly one gets the extra.
      final values = result.values.toList()..sort();
      expect(values, [33, 33, 34]);
    });

    test('single member gets the full amount', () {
      final result = SplitCalculator.equal(1250, ['solo']);
      expect(result, {'solo': 1250});
    });

    test('zero amount splits to all zeros', () {
      final result = SplitCalculator.equal(0, ['a', 'b']);
      expect(result, {'a': 0, 'b': 0});
    });

    test('throws for an empty member list', () {
      expect(() => SplitCalculator.equal(100, []), throwsA(isA<SplitValidationError>()));
    });
  });

  group('SplitCalculator.byShares', () {
    test('splits proportionally to integer shares', () {
      final result = SplitCalculator.byShares(1000, {'a': 2, 'b': 1});
      expect(result['a'], 667);
      expect(result['b'], 333);
      expect(result.values.fold<int>(0, (a, b) => a + b), 1000);
    });

    test('handles an uneven three-way ratio without drift', () {
      final result = SplitCalculator.byShares(1001, {'a': 1, 'b': 1, 'c': 1});
      expect(result.values.fold<int>(0, (a, b) => a + b), 1001);
    });

    test('throws for a non-positive share', () {
      expect(() => SplitCalculator.byShares(100, {'a': 1, 'b': 0}), throwsA(isA<SplitValidationError>()));
    });
  });

  group('SplitCalculator.byPercent', () {
    test('splits by percentage and sums exactly', () {
      final result = SplitCalculator.byPercent(9999, {'a': 33.33, 'b': 33.33, 'c': 33.34});
      expect(result.values.fold<int>(0, (a, b) => a + b), 9999);
    });

    test('accepts percentages that sum to 100 within tolerance', () {
      final result = SplitCalculator.byPercent(500, {'a': 50.0, 'b': 50.0});
      expect(result, {'a': 250, 'b': 250});
    });

    test('throws when percentages do not sum to 100', () {
      expect(
        () => SplitCalculator.byPercent(500, {'a': 40.0, 'b': 40.0}),
        throwsA(isA<SplitValidationError>()),
      );
    });
  });

  group('SplitCalculator.unequal', () {
    test('accepts amounts that sum exactly to the total', () {
      final result = SplitCalculator.unequal(2500, {'a': 600, 'b': 500, 'c': 1400});
      expect(result, {'a': 600, 'b': 500, 'c': 1400});
    });

    test('throws when amounts do not sum to the total', () {
      expect(
        () => SplitCalculator.unequal(2500, {'a': 600, 'b': 500}),
        throwsA(isA<SplitValidationError>()),
      );
    });

    test('throws for a negative amount', () {
      expect(
        () => SplitCalculator.unequal(100, {'a': -10, 'b': 110}),
        throwsA(isA<SplitValidationError>()),
      );
    });
  });

  group('SplitCalculator.byMeals', () {
    test('splits proportionally to meal counts including fractional halves', () {
      final result = SplitCalculator.byMeals(1000, {'a': 1.5, 'b': 0.5});
      expect(result['a'], 750);
      expect(result['b'], 250);
    });

    test('falls back to equal split when total meals is zero (no div-by-zero)', () {
      final result = SplitCalculator.byMeals(300, {'a': 0.0, 'b': 0.0, 'c': 0.0});
      expect(result.values.fold<int>(0, (a, b) => a + b), 300);
      expect(result, {'a': 100, 'b': 100, 'c': 100});
    });
  });

  group('property: splits always reconcile exactly', () {
    test('equal split sums to the input for a range of amounts and member counts', () {
      for (final amount in [0, 1, 7, 99, 100, 101, 999, 100000]) {
        for (final memberCount in [1, 2, 3, 5, 7]) {
          final members = List.generate(memberCount, (i) => 'm$i');
          final result = SplitCalculator.equal(amount, members);
          expect(
            result.values.fold<int>(0, (a, b) => a + b),
            amount,
            reason: 'amount=$amount members=$memberCount',
          );
        }
      }
    });
  });
}
