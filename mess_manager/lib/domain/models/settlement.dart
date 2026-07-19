import 'ledger_purpose.dart';

class Settlement {
  const Settlement({
    required this.id,
    required this.groupId,
    required this.fromMemberId,
    required this.toMemberId,
    required this.amountPaisa,
    required this.date,
    this.method,
    this.note,
    this.purpose = LedgerPurpose.general,
    required this.updatedAt,
  });

  final String id;
  final String groupId;
  final String fromMemberId;
  final String toMemberId;
  final int amountPaisa;
  final DateTime date;
  final String? method;
  final String? note;
  final LedgerPurpose purpose;
  final DateTime updatedAt;
}
