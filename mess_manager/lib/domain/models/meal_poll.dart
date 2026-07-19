import 'dart:convert';

import 'non_voter_policy.dart';

/// Chosen by the poll's creator (user decision — "enable all features as
/// customizable for the meal manager"). 'slots' ticks which meal slots
/// (Breakfast/Lunch/Dinner/...) to take; 'count' is a plain meal-count vote;
/// 'menu' is informational only (doesn't touch the meal grid).
enum PollType {
  slots,
  count,
  menu;

  static PollType fromDb(String value) => PollType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => PollType.slots,
      );
}

class MealPoll {
  const MealPoll({
    required this.id,
    required this.groupId,
    required this.date,
    required this.type,
    this.title,
    this.options = const [],
    required this.closeAt,
    required this.createdByMemberId,
    this.nonVoterPolicy,
    required this.closed,
    required this.updatedAt,
  });

  final String id;
  final String groupId;
  final DateTime date;
  final PollType type;
  final String? title;

  /// Choices for a 'menu' poll; empty for other types.
  final List<String> options;
  final DateTime closeAt;
  final String createdByMemberId;

  /// Null = use the group's `defaultNonVoterPolicy`.
  final NonVoterPolicy? nonVoterPolicy;
  final bool closed;
  final DateTime updatedAt;

  bool get isPastCloseTime => DateTime.now().isAfter(closeAt);

  static List<String> decodeOptions(String? json) =>
      json == null ? const [] : List<String>.from(jsonDecode(json) as List);

  static String encodeOptions(List<String> options) => jsonEncode(options);
}

/// A single member's vote. [value] holds exactly the field matching the
/// poll's type: [slotIds] for 'slots', [count] for 'count', [optionIndex]
/// for 'menu'.
class PollVote {
  const PollVote({
    required this.pollId,
    required this.memberId,
    this.slotIds = const [],
    this.count,
    this.optionIndex,
    required this.votedAt,
  });

  final String pollId;
  final String memberId;
  final List<String> slotIds;
  final double? count;
  final int? optionIndex;
  final DateTime votedAt;

  static PollVote fromJson({
    required String pollId,
    required String memberId,
    required String valueJson,
    required DateTime votedAt,
  }) {
    final value = jsonDecode(valueJson) as Map<String, dynamic>;
    return PollVote(
      pollId: pollId,
      memberId: memberId,
      slotIds: value['slotIds'] == null ? const [] : List<String>.from(value['slotIds'] as List),
      count: (value['count'] as num?)?.toDouble(),
      optionIndex: value['optionIndex'] as int?,
      votedAt: votedAt,
    );
  }

  String toValueJson() => jsonEncode({
        if (slotIds.isNotEmpty) 'slotIds': slotIds,
        if (count != null) 'count': count,
        if (optionIndex != null) 'optionIndex': optionIndex,
      });
}
