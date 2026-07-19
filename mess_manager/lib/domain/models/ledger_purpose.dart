/// Which independent balance ledger a deposit, settlement, or month-close
/// belongs to when a group has `mealLedgerSeparate` turned on. Ignored
/// entirely (everything treated as one combined ledger) when that group
/// setting is off.
enum LedgerPurpose {
  meal,
  general;

  static LedgerPurpose fromDb(String value) => LedgerPurpose.values.firstWhere(
        (e) => e.name == value,
        orElse: () => LedgerPurpose.general,
      );
}
