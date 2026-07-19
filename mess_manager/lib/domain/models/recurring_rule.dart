class RecurringTemplate {
  const RecurringTemplate({
    required this.amountPaisa,
    required this.categoryId,
    this.note,
    required this.payerMemberId,
    this.lastGeneratedYearMonth,
  });

  final int amountPaisa;
  final String categoryId;
  final String? note;
  final String payerMemberId;
  final String? lastGeneratedYearMonth;

  factory RecurringTemplate.fromJson(Map<String, dynamic> json) => RecurringTemplate(
        amountPaisa: json['amountPaisa'] as int,
        categoryId: json['categoryId'] as String,
        note: json['note'] as String?,
        payerMemberId: json['payerMemberId'] as String,
        lastGeneratedYearMonth: json['lastGeneratedYearMonth'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'amountPaisa': amountPaisa,
        'categoryId': categoryId,
        'note': note,
        'payerMemberId': payerMemberId,
        'lastGeneratedYearMonth': lastGeneratedYearMonth,
      };

  RecurringTemplate copyWith({String? lastGeneratedYearMonth}) => RecurringTemplate(
        amountPaisa: amountPaisa,
        categoryId: categoryId,
        note: note,
        payerMemberId: payerMemberId,
        lastGeneratedYearMonth: lastGeneratedYearMonth ?? this.lastGeneratedYearMonth,
      );
}

class RecurringRule {
  const RecurringRule({
    required this.id,
    required this.groupId,
    required this.template,
    required this.dayOfMonth,
    required this.active,
    required this.updatedAt,
  });

  final String id;
  final String groupId;
  final RecurringTemplate template;
  final int dayOfMonth;
  final bool active;
  final DateTime updatedAt;
}
