import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// In-memory for M1; persisted to the `settings` table starting M2 (settings screen).
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  void setLocale(Locale locale) => state = locale;
  void toggle() => state = state.languageCode == 'en' ? const Locale('bn') : const Locale('en');
}

final localeProvider = NotifierProvider<LocaleController, Locale>(LocaleController.new);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void toggle() => state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  void set(ThemeMode mode) => state = mode;
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class BanglaDigitsController extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final banglaDigitsProvider = NotifierProvider<BanglaDigitsController, bool>(BanglaDigitsController.new);

final categoriesStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.categories).watch();
});

final groupsStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.groups).watch();
});

final membersStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.members).watch();
});
