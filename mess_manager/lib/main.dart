import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workmanager/workmanager.dart';

import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'data/db/app_database.dart';
import 'data/repositories/app_settings_repository.dart';
import 'data/repositories/groups_repository.dart';
import 'data/services/api_client.dart';
import 'data/services/backup_service.dart';
import 'data/services/drive_auto_backup_task.dart';
import 'data/services/drive_backup_service.dart';
import 'data/services/sync_api_service.dart';
import 'data/services/sync_background_task.dart';
import 'data/services/sync_service.dart';
import 'ui/providers/app_providers.dart';
import 'ui/providers/repository_providers.dart';
import 'ui/router/app_router.dart';
import 'ui/screens/lock/app_lock_screen.dart';

/// Runs in a separate background isolate/engine spawned by WorkManager, with
/// no access to the app's Riverpod container — everything each task needs
/// (DB connection, Drive/API sign-in) is created fresh here. Dispatches by
/// task name since WorkManager only allows one registered callback per app.
@pragma('vm:entry-point')
void backgroundTaskDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case driveAutoBackupTaskName:
        return _runDriveAutoBackup();
      case syncTaskName:
        return _runBackgroundSync();
      default:
        return true;
    }
  });
}

Future<bool> _runDriveAutoBackup() async {
  final db = AppDatabase();
  try {
    final drive = DriveBackupService(BackupService(db));
    // Background isolate: no UI, so only a silent (previously-authorized)
    // sign-in is attempted — never an interactive prompt.
    final account = await drive.signIn(interactive: false);
    if (account == null) return false;
    await drive.backupNow(interactive: false);
    return true;
  } catch (_) {
    return false;
  } finally {
    await db.close();
  }
}

Future<bool> _runBackgroundSync() async {
  final db = AppDatabase();
  try {
    final storage = const FlutterSecureStorage();
    final settings = AppSettingsRepository(db);
    final baseUrl = await settings.get(apiBaseUrlSettingKey) ?? kDefaultApiBaseUrl;
    final api = ApiClient(storage, baseUrlProvider: () => baseUrl);
    if (!await api.isSignedIn) return true; // nothing to do, not a failure
    final sync = SyncService(SyncApiService(api, db), GroupsRepository(db), settings);
    await sync.syncAllOnlineGroups();
    return true;
  } catch (_) {
    return false;
  } finally {
    await db.close();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(backgroundTaskDispatcher);
  runApp(const ProviderScope(child: MessManagerApp()));
}

class MessManagerApp extends ConsumerWidget {
  const MessManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    final lockEnabled = ref.watch(appLockEnabledProvider).value ?? false;
    ref.watch(purchaseStreamListenerProvider);

    return MaterialApp.router(
      title: 'MessBook',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: themeMode,
      theme: buildAppTheme(brightness: Brightness.light, localeCode: locale.languageCode),
      darkTheme: buildAppTheme(brightness: Brightness.dark, localeCode: locale.languageCode),
      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();
        return lockEnabled ? AppLockScreen(child: content) : content;
      },
    );
  }
}
