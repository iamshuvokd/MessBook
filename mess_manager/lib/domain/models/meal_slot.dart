class MealSlot {
  const MealSlot({
    required this.id,
    required this.groupId,
    required this.name,
    this.defaultKey,
    required this.weight,
    required this.sortOrder,
    required this.active,
    required this.updatedAt,
  });

  final String id;
  final String groupId;
  final String name;
  final String? defaultKey;
  final double weight;
  final int sortOrder;
  final bool active;
  final DateTime updatedAt;

  MealSlot copyWith({String? name, String? defaultKey, double? weight, int? sortOrder, bool? active}) {
    return MealSlot(
      id: id,
      groupId: groupId,
      name: name ?? this.name,
      // Renaming clears the default-key link (custom name from here on).
      defaultKey: name != null ? null : (defaultKey ?? this.defaultKey),
      weight: weight ?? this.weight,
      sortOrder: sortOrder ?? this.sortOrder,
      active: active ?? this.active,
      updatedAt: DateTime.now(),
    );
  }
}
