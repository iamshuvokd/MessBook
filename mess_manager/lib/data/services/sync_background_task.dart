import 'package:workmanager/workmanager.dart';

/// Shared identifiers + scheduling helpers for the periodic background sync
/// job (online groups only — a no-op when nobody's signed in or no group has
/// been brought online). The callback dispatcher that actually runs it lives
/// in `main.dart` (must be a top-level function per the workmanager plugin's
/// isolate-entry-point requirement), alongside the Drive auto-backup one.
const syncTaskName = 'syncTask';
const syncUniqueName = 'syncUnique';

/// 15 minutes is WorkManager's own minimum periodic interval on Android.
Future<void> schedulePeriodicSync() {
  return Workmanager().registerPeriodicTask(
    syncUniqueName,
    syncTaskName,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}

Future<void> cancelPeriodicSync() {
  return Workmanager().cancelByUniqueName(syncUniqueName);
}
