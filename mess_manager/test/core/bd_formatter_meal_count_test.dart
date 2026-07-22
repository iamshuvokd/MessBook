// Regression: the month report rendered meal counts with the default
// `number()` (0 decimals), so a member with 2.5 meals was shown as "3" —
// their meals looked wrong even though the stored double was correct.
// `mealCount()` is now the one way meal counts reach the screen.
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/core/utils/bd_formatter.dart';

void main() {
  final en = BdFormatter(useBanglaDigits: false, locale: 'en');
  final bn = BdFormatter(useBanglaDigits: true, locale: 'bn');

  group('mealCount keeps fractions visible', () {
    test('half meals are NOT rounded away', () {
      expect(en.mealCount(2.5), '2.5');
      expect(en.mealCount(0.5), '0.5');
      expect(en.mealCount(1.5), '1.5');
      // The exact bug reported: plain number() rounds 2.5 up to "3".
      expect(en.number(2.5), '3', reason: 'documents why mealCount exists');
    });

    test('whole counts stay clean, with no trailing .0', () {
      expect(en.mealCount(3), '3');
      expect(en.mealCount(0), '0');
      expect(en.mealCount(3.0), '3');
    });

    test('a month total with many halves keeps its half', () {
      expect(en.mealCount(62.5), '62.5');
      expect(en.mealCount(90), '90');
    });

    test('thousands separators still apply', () {
      expect(en.mealCount(1234.5), '1,234.5');
      expect(en.mealCount(1234), '1,234');
    });

    test('renders in Bangla digits when that setting is on', () {
      expect(bn.mealCount(2.5), '২.৫');
      expect(bn.mealCount(3), '৩');
    });
  });
}
