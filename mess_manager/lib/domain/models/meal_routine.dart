/// One line of a member's standing meal routine: "take slot [slotId],
/// [weekday or every day]". Several rows per member (typically one per
/// slot, or one per slot+weekday for finer control).
class MemberMealRoutine {
  const MemberMealRoutine({
    required this.id,
    required this.memberId,
    required this.slotId,
    this.weekday,
    required this.enabled,
    required this.updatedAt,
  });

  final String id;
  final String memberId;
  final String slotId;

  /// 1=Monday..7=Sunday (`DateTime.weekday`), or null for every day.
  final int? weekday;
  final bool enabled;
  final DateTime updatedAt;
}

/// A date-range pause ("going home 20–25th") — zeroes the routine for every
/// day in [fromDate, toDate] inclusive.
class MealLeave {
  const MealLeave({
    required this.id,
    required this.memberId,
    required this.fromDate,
    required this.toDate,
    this.note,
    required this.updatedAt,
  });

  final String id;
  final String memberId;
  final DateTime fromDate;
  final DateTime toDate;
  final String? note;
  final DateTime updatedAt;

  bool covers(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    final from = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final to = DateTime(toDate.year, toDate.month, toDate.day);
    return !d.isBefore(from) && !d.isAfter(to);
  }
}
