import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/data/repositories/app_settings_repository.dart';

void main() {
  group('parseReminderTime', () {
    test('parses a stored HH:mm value', () {
      final t = parseReminderTime('07:05');
      expect(t.hour, 7);
      expect(t.minute, 5);
    });

    test('parses a late-evening time', () {
      final t = parseReminderTime('22:30');
      expect(t.hour, 22);
      expect(t.minute, 30);
    });

    test('falls back to 22:00 when nothing is stored yet', () {
      final t = parseReminderTime(null);
      expect(t.hour, 22);
      expect(t.minute, 0);
    });

    test('falls back rather than crashing on malformed or out-of-range values', () {
      for (final bad in ['', 'not-a-time', '25:00', '10:99', '10', '10:00:00', 'aa:bb']) {
        final t = parseReminderTime(bad);
        expect(t.hour, 22, reason: 'input "$bad" should fall back');
        expect(t.minute, 0, reason: 'input "$bad" should fall back');
      }
    });
  });

  group('formatReminderTime', () {
    test('zero-pads hours and minutes', () {
      expect(formatReminderTime(7, 5), '07:05');
      expect(formatReminderTime(0, 0), '00:00');
    });

    test('round-trips through parseReminderTime', () {
      for (final pair in [(6, 45), (13, 0), (23, 59)]) {
        final parsed = parseReminderTime(formatReminderTime(pair.$1, pair.$2));
        expect(parsed.hour, pair.$1);
        expect(parsed.minute, pair.$2);
      }
    });
  });
}
