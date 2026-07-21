import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/core/utils/bd_formatter.dart';

void main() {
  final en = BdFormatter(useBanglaDigits: false, locale: 'en');
  final bn = BdFormatter(useBanglaDigits: true, locale: 'bn');

  group('time (poll close time members need to see)', () {
    test('formats afternoon/evening times as 12-hour PM', () {
      expect(en.time(DateTime(2026, 7, 21, 21, 0)), '9:00 PM');
      expect(en.time(DateTime(2026, 7, 21, 13, 5)), '1:05 PM');
    });

    test('formats morning times as AM', () {
      expect(en.time(DateTime(2026, 7, 21, 9, 30)), '9:30 AM');
    });

    test('midnight and noon use 12, not 0', () {
      expect(en.time(DateTime(2026, 7, 21, 0, 15)), '12:15 AM');
      expect(en.time(DateTime(2026, 7, 21, 12, 0)), '12:00 PM');
    });

    test('pads minutes', () {
      expect(en.time(DateTime(2026, 7, 21, 8, 7)), '8:07 AM');
    });

    test('uses Bangla digits when enabled', () {
      expect(bn.time(DateTime(2026, 7, 21, 21, 0)), '৯:০০ PM');
    });
  });

  group('dayTime', () {
    test('combines date and clock time', () {
      expect(en.dayTime(DateTime(2026, 7, 21, 21, 0)), '21 Jul, 9:00 PM');
    });
  });
}
