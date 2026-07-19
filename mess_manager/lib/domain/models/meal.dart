class Meal {
  const Meal({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.date,
    required this.count,
    required this.guestCount,
    this.slotIds,
    required this.updatedAt,
  });

  final String id;
  final String groupId;
  final String memberId;
  final DateTime date;
  final double count;
  final double guestCount;

  /// Which meal slots (auto-fill or a 'slots'-type poll) produced [count];
  /// null means this entry was set manually.
  final List<String>? slotIds;
  final DateTime updatedAt;

  double get total => count + guestCount;
}
