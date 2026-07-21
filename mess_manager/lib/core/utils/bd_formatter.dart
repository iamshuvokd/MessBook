import 'package:intl/intl.dart' as intl;

/// Single source of truth for rendering money and numbers app-wide.
/// All currency is stored as integer paisa; this is the only place
/// that converts paisa -> a displayable taka string.
class BdFormatter {
  BdFormatter({required this.useBanglaDigits, required this.locale});

  final bool useBanglaDigits;
  final String locale;

  static const _enDigits = '0123456789';
  static const _bnDigits = '০১২৩৪৫৬৭৮৯';

  String _toBanglaDigits(String input) {
    final buffer = StringBuffer();
    for (final ch in input.split('')) {
      final idx = _enDigits.indexOf(ch);
      buffer.write(idx == -1 ? ch : _bnDigits[idx]);
    }
    return buffer.toString();
  }

  /// Converts digits in [value] to Bangla numerals if the setting is on.
  String digits(String value) => useBanglaDigits ? _toBanglaDigits(value) : value;

  /// Formats paisa as a currency string, e.g. 250000 -> "৳2,500" (or "৳২,৫০০").
  String currency(int amountPaisa, {String symbol = '৳'}) {
    final taka = amountPaisa / 100;
    final isWhole = amountPaisa % 100 == 0;
    final formatted = intl.NumberFormat(
      isWhole ? '#,##0' : '#,##0.00',
      'en_US',
    ).format(taka);
    return '$symbol${digits(formatted)}';
  }

  /// Plain integer/decimal formatting with thousands separators, no currency symbol.
  String number(num value, {int decimals = 0}) {
    final formatted = intl.NumberFormat(
      decimals == 0 ? '#,##0' : '#,##0.${'0' * decimals}',
      'en_US',
    ).format(value);
    return digits(formatted);
  }

  static const _bnMonths = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
  ];

  /// Formats a date's day, respecting Bangla digits and month names.
  String monthYear(DateTime date) {
    if (locale == 'bn') {
      final month = _bnMonths[date.month - 1];
      return '$month ${digits(date.year.toString())}';
    }
    return intl.DateFormat('MMMM yyyy', 'en_US').format(date);
  }

  String day(DateTime date) {
    if (locale == 'bn') {
      final month = _bnMonths[date.month - 1];
      return '${digits(date.day.toString())} $month';
    }
    return intl.DateFormat('d MMM', 'en_US').format(date);
  }

  /// Clock time only, 12-hour with am/pm — e.g. `9:00 PM` / `৯:০০ PM`.
  String time(DateTime date) {
    final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final suffix = date.hour < 12 ? 'AM' : 'PM';
    return '${digits(hour12.toString())}:${digits(minute)} $suffix';
  }

  /// Date + clock time — used where the exact moment matters (a poll's
  /// closing time, which members need to see to know when to vote by).
  String dayTime(DateTime date) => '${day(date)}, ${time(date)}';
}
