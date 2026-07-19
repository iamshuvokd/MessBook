import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/domain/engines/proration_engine.dart';

void main() {
  final monthStart = DateTime(2026, 7, 1);
  final monthEnd = DateTime(2026, 8, 1); // 31-day July

  group('ProrationEngine.presentDays', () {
    test('a member present the whole month gets the full day count', () {
      final days = ProrationEngine.presentDays(
        monthStart: monthStart,
        monthEnd: monthEnd,
        joinDates: {'a': DateTime(2026, 1, 1)},
        leaveDates: {'a': null},
      );
      expect(days['a'], 31);
    });

    test('a member who joined mid-month is only present from their join date', () {
      final days = ProrationEngine.presentDays(
        monthStart: monthStart,
        monthEnd: monthEnd,
        joinDates: {'a': DateTime(2026, 7, 16)},
        leaveDates: {'a': null},
      );
      expect(days['a'], 16); // 16th through 31st inclusive = 16 days
    });

    test('a member who leaves mid-month is only present until their leave date', () {
      final days = ProrationEngine.presentDays(
        monthStart: monthStart,
        monthEnd: monthEnd,
        joinDates: {'a': DateTime(2026, 1, 1)},
        leaveDates: {'a': DateTime(2026, 7, 16)},
      );
      expect(days['a'], 15); // 1st through 15th = 15 days
    });

    test('a member who joins and leaves within the same month is clamped correctly', () {
      final days = ProrationEngine.presentDays(
        monthStart: monthStart,
        monthEnd: monthEnd,
        joinDates: {'a': DateTime(2026, 7, 10)},
        leaveDates: {'a': DateTime(2026, 7, 20)},
      );
      expect(days['a'], 10);
    });

    test('a member who left before this month starts gets zero days (never negative)', () {
      final days = ProrationEngine.presentDays(
        monthStart: monthStart,
        monthEnd: monthEnd,
        joinDates: {'a': DateTime(2026, 1, 1)},
        leaveDates: {'a': DateTime(2026, 6, 1)},
      );
      expect(days['a'], 0);
    });
  });

  group('ProrationEngine.prorate', () {
    test('splits a fixed cost proportionally to days present', () {
      // a: full month (31 days), b: joined on the 16th (16 days).
      final result = ProrationEngine.prorate(12000000, {'a': 31, 'b': 16});
      expect(result.values.fold<int>(0, (x, y) => x + y), 12000000);
      expect(result['a']! > result['b']!, isTrue);
    });

    test('members with zero days present get exactly zero and do not skew the split', () {
      final result = ProrationEngine.prorate(10000, {'a': 30, 'b': 0});
      expect(result['b'], 0);
      expect(result['a'], 10000);
    });

    test('all members with zero days present returns all zeros without crashing', () {
      final result = ProrationEngine.prorate(5000, {'a': 0, 'b': 0});
      expect(result, {'a': 0, 'b': 0});
    });

    test('reconciles exactly to the input amount across many day-count combinations', () {
      for (final amount in [100, 12000000, 999999]) {
        final result = ProrationEngine.prorate(amount, {'a': 31, 'b': 15, 'c': 3});
        expect(result.values.fold<int>(0, (x, y) => x + y), amount);
      }
    });
  });
}
