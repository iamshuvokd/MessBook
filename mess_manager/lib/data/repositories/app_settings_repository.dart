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

const lastBackupAtSettingKey = 'lastBackupAt';
const backupOverduePromptedAtSettingKey = 'backupOverduePromptedAt';
const premiumUnlockedSettingKey = 'premiumUnlocked';
const driveAutoBackupEnabledSettingKey = 'driveAutoBackupEnabled';
const apiBaseUrlSettingKey = 'apiBaseUrl';
