import 'ledger_purpose.dart';

class Deposit {
  const Deposit({
    required this.id,
    required this.groupId,
    required this.memberId,
    required this.amountPaisa,
    required this.date,
    this.note,
    this.purpose = LedgerPurpose.general,
    required this.updatedAt,
  });

  final String id;
  final String groupId;
  final String memberId;
  final int amountPaisa;
  final DateTime date;
  final String? note;
  final LedgerPurpose purpose;
  final DateTime updatedAt;
}
