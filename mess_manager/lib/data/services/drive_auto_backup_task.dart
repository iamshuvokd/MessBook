import 'package:workmanager/workmanager.dart';

/// Shared identifiers + scheduling helpers for the daily Drive auto-backup
/// background job (premium). The callback dispatcher that actually runs the
/// backup on a schedule lives in `main.dart` (must be a top-level function
/// per the workmanager plugin's isolate-entry-point requirement).
const driveAutoBackupTaskName = 'driveAutoBackupTask';
const driveAutoBackupUniqueName = 'driveAutoBackupUnique';

Future<void> scheduleDriveAutoBackup() {
  return Workmanager().registerPeriodicTask(
    driveAutoBackupUniqueName,
    driveAutoBackupTaskName,
    frequency: const Duration(hours: 24),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
  );
}

Future<void> cancelDriveAutoBackup() {
  return Workmanager().cancelByUniqueName(driveAutoBackupUniqueName);
}
