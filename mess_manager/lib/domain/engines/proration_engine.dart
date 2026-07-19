import 'split_calculator.dart';

/// Prorates fixed costs (rent, WiFi, etc.) by each member's days present in
/// the month window, aware of mid-month joins/leaves.
class ProrationEngine {
  const ProrationEngine._();

  /// Computes each member's present-day count within [monthStart, monthEnd)
  /// given their join/leave dates. A null leave date means still active.
  static Map<String, int> presentDays({
    required DateTime monthStart,
    required DateTime monthEnd,
    required Map<String, DateTime> joinDates,
    required Map<String, DateTime?> leaveDates,
  }) {
    final result = <String, int>{};
    for (final id in joinDates.keys) {
      final join = joinDates[id]!;
      final leave = leaveDates[id];
      final presentStart = join.isAfter(monthStart) ? join : monthStart;
      final presentEnd = (leave != null && leave.isBefore(monthEnd)) ? leave : monthEnd;
      final days = presentEnd.difference(presentStart).inDays;
      result[id] = days < 0 ? 0 : days;
    }
    return result;
  }

  /// Splits [amountPaisa] proportionally to each member's present-day count.
  /// Members with zero days present get zero and are excluded from the
  /// weighting (never crash on all-zero the way a naive division would).
  static Map<String, int> prorate(int amountPaisa, Map<String, int> presentDays) {
    final activeDays = {
      for (final e in presentDays.entries)
        if (e.value > 0) e.key: e.value,
    };
    if (activeDays.isEmpty) {
      return {for (final k in presentDays.keys) k: 0};
    }
    final prorated = SplitCalculator.byShares(amountPaisa, activeDays);
    return {for (final k in presentDays.keys) k: prorated[k] ?? 0};
  }
}
