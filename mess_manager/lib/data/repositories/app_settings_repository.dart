import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// Thin key/value wrapper over the `settings` table for small app-level
/// state (last backup timestamp, notification preferences, etc.).
class AppSettingsRepository {
  AppSettingsRepository(this._db);

  final AppDatabase _db;

  Future<String?> get(String key) async {
    final row = await (_db.select(_db.appSettings)..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> set(String key, String value) async {
    await _db.into(_db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: Value(value)),
        );
  }

  Stream<String?> watch(String key) {
    final query = _db.select(_db.appSettings)..where((s) => s.key.equals(key));
    return query.watchSingleOrNull().map((row) => row?.value);
  }
}

/// Time of the nightly "set your meals" reminder, stored as `HH:mm`. Kept a
/// per-device setting rather than a synced mess policy: it's a personal
/// nudge, and members legitimately want different times.
const dailyMealReminderSettingKey = 'dailyMealReminderTime';
const defaultDailyMealReminder = '22:00';

/// Parses a stored `HH:mm` reminder time, falling back to the default for
/// anything missing or malformed so a bad value can never break scheduling.
({int hour, int minute}) parseReminderTime(String? raw) {
  final parts = (raw ?? '').split(':');
  if (parts.length == 2) {
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h != null && m != null && h >= 0 && h < 24 && m >= 0 && m < 60) {
      return (hour: h, minute: m);
    }
  }
  return (hour: 22, minute: 0);
}

String formatReminderTime(int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

const lastBackupAtSettingKey = 'lastBackupAt';
const backupOverduePromptedAtSettingKey = 'backupOverduePromptedAt';
const premiumUnlockedSettingKey = 'premiumUnlocked';
const driveAutoBackupEnabledSettingKey = 'driveAutoBackupEnabled';
const apiBaseUrlSettingKey = 'apiBaseUrl';
