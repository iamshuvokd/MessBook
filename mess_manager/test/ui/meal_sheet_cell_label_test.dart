import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/core/utils/bd_formatter.dart';
import 'package:mess_manager/domain/models/meal.dart';
import 'package:mess_manager/ui/screens/meals/meal_grid_screen.dart';

Meal _meal({required double count, double guest = 0}) => Meal(
      id: 'x',
      groupId: 'g',
      memberId: 'm',
      date: DateTime(2026, 7, 21),
      count: count,
      guestCount: guest,
      updatedAt: DateTime(2026, 7, 21),
    );

void main() {
  final fmt = BdFormatter(useBanglaDigits: false, locale: 'en');

  test('shows the combined total of own meals and guest meals', () {
    // Own 2 + guest 1 = 3 — the whole point: the cell reflects guests too,
    // not just the member's own meals.
    expect(mealSheetCellLabel(fmt, 2, 1), '3');
  });

  test('own meals only (no guests) shows the own count', () {
    expect(mealSheetCellLabel(fmt, 2, 0), '2');
  });

  test('guest-only day still shows a number, not the empty placeholder', () {
    expect(mealSheetCellLabel(fmt, 0, 1), '1');
  });

  test('an empty day (no meals, no guests) shows the placeholder', () {
    expect(mealSheetCellLabel(fmt, 0, 0), '·');
  });

  test('fractional halves render with one decimal', () {
    expect(mealSheetCellLabel(fmt, 1.5, 0.5), '2'); // 2.0 -> whole number
    expect(mealSheetCellLabel(fmt, 0.5, 0), '0.5');
    expect(mealSheetCellLabel(fmt, 1, 0.5), '1.5');
  });

  test('renders Bangla digits when that formatter is used', () {
    final bn = BdFormatter(useBanglaDigits: true, locale: 'bn');
    expect(bn.digits('3'), mealSheetCellLabel(bn, 2, 1));
  });

  group('mealDaySummary (today total for the manager)', () {
    test('sums own + guest meals across members and counts the eaters', () {
      final s = mealDaySummary([
        _meal(count: 2),
        _meal(count: 1, guest: 1),
        _meal(count: 0, guest: 1), // guest-only still counts as eating
      ]);
      expect(s.total, 5); // 2 + (1+1) + 1
      expect(s.guests, 2);
      expect(s.eaters, 3);
    });

    test('an empty day summarizes to all zeros', () {
      final s = mealDaySummary(const []);
      expect(s.total, 0);
      expect(s.guests, 0);
      expect(s.eaters, 0);
    });

    test('handles fractional (half) meals', () {
      final s = mealDaySummary([_meal(count: 0.5), _meal(count: 1.5, guest: 0.5)]);
      expect(s.total, 2.5);
      expect(s.guests, 0.5);
      expect(s.eaters, 2);
    });
  });
}
