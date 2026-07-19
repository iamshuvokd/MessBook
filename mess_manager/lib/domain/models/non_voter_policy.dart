/// What happens to a poll's non-voters at close time — a mess-level default
/// (on `Group`), overridable per poll. 'routine' (use their standing
/// auto-routine) is the recommended default; the others exist because not
/// every mess wants that (user decision).
enum NonVoterPolicy {
  routine,
  pending,
  zero,
  repeatYesterday;

  static NonVoterPolicy fromDb(String value) => NonVoterPolicy.values.firstWhere(
        (e) => e.name == value,
        orElse: () => NonVoterPolicy.routine,
      );
}
