import 'non_voter_policy.dart';

enum GroupType {
  mess,
  flat,
  trip,
  other;

  static GroupType fromDb(String value) => GroupType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => GroupType.other,
      );
}

class Group {
  const Group({
    required this.id,
    required this.name,
    required this.type,
    required this.currencySymbol,
    required this.monthStartDay,
    required this.mealEnabled,
    this.mealLedgerSeparate = false,
    this.defaultNonVoterPolicy = NonVoterPolicy.routine,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
    this.inviteCode,
  });

  final String id;
  final String name;
  final GroupType type;
  final String currencySymbol;
  final int monthStartDay;
  final bool mealEnabled;

  /// When true, meal costs and rent/other shared costs are two fully
  /// independent balances (own settle-up, own month-close) instead of one
  /// combined net per member.
  final bool mealLedgerSeparate;

  /// What happens to a poll's non-voters when it closes, unless the poll
  /// overrides it itself.
  final NonVoterPolicy defaultNonVoterPolicy;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Set once this mess is "brought online"; null means it's still purely local.
  final String? inviteCode;

  bool get isOnline => inviteCode != null;

  Group copyWith({
    String? name,
    GroupType? type,
    String? currencySymbol,
    int? monthStartDay,
    bool? mealEnabled,
    bool? mealLedgerSeparate,
    NonVoterPolicy? defaultNonVoterPolicy,
    bool? archived,
    String? inviteCode,
  }) {
    return Group(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      monthStartDay: monthStartDay ?? this.monthStartDay,
      mealEnabled: mealEnabled ?? this.mealEnabled,
      mealLedgerSeparate: mealLedgerSeparate ?? this.mealLedgerSeparate,
      defaultNonVoterPolicy: defaultNonVoterPolicy ?? this.defaultNonVoterPolicy,
      archived: archived ?? this.archived,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }
}
