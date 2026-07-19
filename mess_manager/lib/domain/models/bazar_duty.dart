class BazarDuty {
  const BazarDuty({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.date,
    this.note,
    required this.done,
    required this.updatedAt,
  });

  final String id;
  final String groupId;
  final String memberId;
  final DateTime date;
  final String? note;
  final bool done;
  final DateTime updatedAt;
}
