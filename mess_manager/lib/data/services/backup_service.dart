import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart' as intl;

import '../db/app_database.dart';

const backupSchemaVersion = 1;
const backupAppVersion = '1.0.0';

class BackupValidationError implements Exception {
  BackupValidationError(this.message);
  final String message;
  @override
  String toString() => message;
}

class BackupPreview {
  const BackupPreview({
    required this.schemaVersion,
    required this.exportedAt,
    required this.groupCount,
    required this.memberCount,
    required this.expenseCount,
    required this.mealCount,
    required this.depositCount,
  });

  final int schemaVersion;
  final DateTime exportedAt;
  final int groupCount;
  final int memberCount;
  final int expenseCount;
  final int mealCount;
  final int depositCount;
}

/// Full JSON export/import per spec §6. `data` holds every table's rows as
/// plain JSON (Drift's generated `toJson`/`fromJson`/`toCompanion`), wrapped
/// in an envelope with a sha256 checksum of the data payload so imports can
/// detect corruption, and a schemaVersion gate so a newer export can't be
/// silently mis-imported into an older app build.
class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  String suggestedFileName([DateTime? now]) {
    final ts = intl.DateFormat('yyyyMMdd_HHmm').format(now ?? DateTime.now());
    return 'messbook_backup_$ts.json';
  }

  Future<Map<String, dynamic>> _collectData() async {
    return {
      'groups': [for (final r in await _db.select(_db.groups).get()) r.toJson()],
      'members': [for (final r in await _db.select(_db.members).get()) r.toJson()],
      'categories': [for (final r in await _db.select(_db.categories).get()) r.toJson()],
      'expenses': [for (final r in await _db.select(_db.expenses).get()) r.toJson()],
      'expensePayers': [for (final r in await _db.select(_db.expensePayers).get()) r.toJson()],
      'expenseSplits': [for (final r in await _db.select(_db.expenseSplits).get()) r.toJson()],
      'meals': [for (final r in await _db.select(_db.meals).get()) r.toJson()],
      'bazarDuties': [for (final r in await _db.select(_db.bazarDuties).get()) r.toJson()],
      'deposits': [for (final r in await _db.select(_db.deposits).get()) r.toJson()],
      'settlements': [for (final r in await _db.select(_db.settlements).get()) r.toJson()],
      'months': [for (final r in await _db.select(_db.months).get()) r.toJson()],
      'recurringRules': [for (final r in await _db.select(_db.recurringRules).get()) r.toJson()],
      'mealSlots': [for (final r in await _db.select(_db.mealSlots).get()) r.toJson()],
      'memberMealRoutines': [for (final r in await _db.select(_db.memberMealRoutines).get()) r.toJson()],
      'mealLeaves': [for (final r in await _db.select(_db.mealLeaves).get()) r.toJson()],
      'mealPolls': [for (final r in await _db.select(_db.mealPolls).get()) r.toJson()],
      'mealPollVotes': [for (final r in await _db.select(_db.mealPollVotes).get()) r.toJson()],
    };
  }

  /// Builds the full backup envelope as a JSON string, ready to write to a file.
  Future<String> exportJson() async {
    final data = await _collectData();
    final payloadJson = jsonEncode(data);
    final checksum = sha256.convert(utf8.encode(payloadJson)).toString();
    final envelope = {
      'schemaVersion': backupSchemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'appVersion': backupAppVersion,
      'checksum': checksum,
      'data': data,
    };
    return jsonEncode(envelope);
  }

  Map<String, dynamic> _parseAndValidate(String content) {
    final Map<String, dynamic> envelope;
    try {
      envelope = jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      throw BackupValidationError('This file is not a valid backup (malformed JSON).');
    }

    final schemaVersion = envelope['schemaVersion'];
    if (schemaVersion is! int || schemaVersion > backupSchemaVersion) {
      throw BackupValidationError('This backup was made by a newer app version and cannot be imported here.');
    }

    final data = envelope['data'];
    if (data is! Map<String, dynamic>) {
      throw BackupValidationError('This file is not a valid backup (missing data).');
    }

    final payloadJson = jsonEncode(data);
    final checksum = sha256.convert(utf8.encode(payloadJson)).toString();
    if (checksum != envelope['checksum']) {
      throw BackupValidationError('Checksum mismatch — this backup file may be corrupted.');
    }

    return envelope;
  }

  BackupPreview preview(String content) {
    final envelope = _parseAndValidate(content);
    final data = envelope['data'] as Map<String, dynamic>;
    return BackupPreview(
      schemaVersion: envelope['schemaVersion'] as int,
      exportedAt: DateTime.parse(envelope['exportedAt'] as String),
      groupCount: (data['groups'] as List).length,
      memberCount: (data['members'] as List).length,
      expenseCount: (data['expenses'] as List).length,
      mealCount: (data['meals'] as List).length,
      depositCount: (data['deposits'] as List).length,
    );
  }

  /// Wipes every table and replaces its contents with the backup's data.
  /// Throws [BackupValidationError] without touching the database if the
  /// file fails checksum/schema validation.
  Future<void> importReplaceAll(String content) async {
    final envelope = _parseAndValidate(content);
    final data = envelope['data'] as Map<String, dynamic>;

    List<Map<String, dynamic>> rows(String key) =>
        (data[key] as List).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      // Children before parents so foreign keys never dangle mid-wipe.
      await _db.delete(_db.auditLog).go();
      await _db.delete(_db.mealPollVotes).go();
      await _db.delete(_db.mealPolls).go();
      await _db.delete(_db.memberMealRoutines).go();
      await _db.delete(_db.mealLeaves).go();
      await _db.delete(_db.mealSlots).go();
      await _db.delete(_db.recurringRules).go();
      await _db.delete(_db.months).go();
      await _db.delete(_db.settlements).go();
      await _db.delete(_db.deposits).go();
      await _db.delete(_db.bazarDuties).go();
      await _db.delete(_db.meals).go();
      await _db.delete(_db.expenseSplits).go();
      await _db.delete(_db.expensePayers).go();
      await _db.delete(_db.expenses).go();
      await _db.delete(_db.categories).go();
      await _db.delete(_db.members).go();
      await _db.delete(_db.groups).go();

      await _db.batch((batch) {
        batch.insertAll(_db.groups, [for (final r in rows('groups')) Group.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.members, [for (final r in rows('members')) Member.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.categories, [for (final r in rows('categories')) Category.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.expenses, [for (final r in rows('expenses')) Expense.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.expensePayers, [for (final r in rows('expensePayers')) ExpensePayer.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.expenseSplits, [for (final r in rows('expenseSplits')) ExpenseSplit.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.meals, [for (final r in rows('meals')) Meal.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.bazarDuties, [for (final r in rows('bazarDuties')) BazarDuty.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.deposits, [for (final r in rows('deposits')) Deposit.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.settlements, [for (final r in rows('settlements')) Settlement.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.months, [for (final r in rows('months')) Month.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.recurringRules, [for (final r in rows('recurringRules')) RecurringRule.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.mealSlots, [for (final r in rows('mealSlots')) MealSlot.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.memberMealRoutines, [for (final r in rows('memberMealRoutines')) MemberMealRoutine.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.mealLeaves, [for (final r in rows('mealLeaves')) MealLeave.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.mealPolls, [for (final r in rows('mealPolls')) MealPoll.fromJson(r).toCompanion(false)]);
        batch.insertAll(_db.mealPollVotes, [for (final r in rows('mealPollVotes')) MealPollVote.fromJson(r).toCompanion(false)]);
      });
    });
  }
}
