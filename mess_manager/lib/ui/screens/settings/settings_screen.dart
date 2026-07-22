import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/app_settings_repository.dart';
import '../../../domain/models/member_permission.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/pin_setup_dialog.dart';
import '../../widgets/section_header.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final lockEnabled = ref.watch(appLockEnabledProvider).value ?? false;
    final lastBackup = ref.watch(lastBackupAtProvider).value;
    final premium = ref.watch(premiumUnlockedProvider).value ?? false;
    final rolesConfigured = ref.watch(rolesConfiguredProvider);
    final isAppAdmin = ref.watch(actingAsMemberProvider)?.role == MemberRole.appAdmin;
    final mealEnabled = ref.watch(selectedGroupProvider)?.mealEnabled ?? true;

    return Scaffold(
      drawer: AppDrawer(groupId: groupId),
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            onTap: premium ? null : () => context.push('/premium/paywall'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(AppRadius.xl)),
              child: Row(
                children: [
                  Icon(premium ? Icons.check_circle_rounded : Icons.workspace_premium_rounded, color: const Color(0xFF3D2C05), size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          premium ? l10n.paywallAlreadyUnlocked : l10n.settingsPremiumBanner,
                          style: const TextStyle(color: Color(0xFF3D2C05), fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                        if (!premium)
                          Text(l10n.settingsPremiumBannerSub, style: const TextStyle(color: Color(0xFF6B4E0E), fontSize: 11.5)),
                      ],
                    ),
                  ),
                  if (!premium) const Icon(Icons.chevron_right_rounded, color: Color(0xFF3D2C05)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          SectionHeader(l10n.settingsMessSection),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.storefront_rounded),
                  title: Text(l10n.settingsEditMess),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/groups/$groupId/edit'),
                ),
                if (mealEnabled)
                  ListTile(
                    leading: const Icon(Icons.restaurant_menu_rounded),
                    title: Text(l10n.mealSlotsTitle),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/groups/$groupId/meal-slots'),
                  ),
                ListTile(
                  leading: const Icon(Icons.wifi_tethering_rounded),
                  title: Text(l10n.onlineSectionTitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/groups/$groupId/online'),
                ),
              ],
            ),
          ),
          if (isAppAdmin) ...[
            const SizedBox(height: 18),
            SectionHeader(l10n.settingsRolesSection),
            Card(
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings_rounded),
                title: Text(l10n.settingsRolesManage),
                subtitle: Text(
                  rolesConfigured ? l10n.settingsRolesConfiguredSub : l10n.settingsRolesNotConfiguredSub,
                  style: const TextStyle(fontSize: 11.5),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/groups/$groupId/roles'),
              ),
            ),
          ],
          const SizedBox(height: 18),
          SectionHeader(l10n.settingsLanguageAppearanceSection),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.translate_rounded),
                  title: Text('${l10n.settingsLanguage} · ভাষা'),
                  trailing: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'en', label: Text(l10n.onboardLanguageEnglish)),
                      ButtonSegment(value: 'bn', label: Text(l10n.onboardLanguageBangla)),
                    ],
                    selected: {locale.languageCode},
                    onSelectionChanged: (s) => ref.read(localeProvider.notifier).setLocale(Locale(s.first)),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.pin_rounded),
                  title: Text(l10n.settingsBanglaDigits),
                  value: banglaDigits,
                  onChanged: (_) => ref.read(banglaDigitsProvider.notifier).toggle(),
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode_rounded),
                  title: Text(l10n.settingsDarkMode),
                  subtitle: Text(l10n.settingsFollowSystem, style: const TextStyle(fontSize: 11.5)),
                  trailing: DropdownButton<ThemeMode>(
                    value: themeMode,
                    underline: const SizedBox.shrink(),
                    items: [
                      DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.settingsThemeSystem)),
                      DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.settingsThemeLight)),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.settingsThemeDark)),
                    ],
                    onChanged: (v) => v != null ? ref.read(themeModeProvider.notifier).set(v) : null,
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded),
                  title: Text(l10n.settingsAppLock),
                  subtitle: Text(l10n.settingsPinBiometric, style: const TextStyle(fontSize: 11.5)),
                  value: lockEnabled,
                  onChanged: (v) => _toggleLock(context, ref, v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionHeader(l10n.settingsRemindersSection),
          Card(
            child: Column(
              children: [
                Builder(builder: (tileContext) {
                  final stored = ref.watch(dailyMealReminderProvider).value ?? defaultDailyMealReminder;
                  final parsed = parseReminderTime(stored);
                  final asTimeOfDay = TimeOfDay(hour: parsed.hour, minute: parsed.minute);
                  return ListTile(
                    leading: const Icon(Icons.restaurant_rounded),
                    title: Text(l10n.settingsDailyMealReminder),
                    subtitle: Text(l10n.settingsEveryNight, style: const TextStyle(fontSize: 11.5)),
                    trailing: Text(
                      asTimeOfDay.format(tileContext),
                      style: const TextStyle(fontFamily: moneyFontFamily, fontWeight: FontWeight.w700),
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(context: tileContext, initialTime: asTimeOfDay);
                      if (picked == null) return;
                      await ref
                          .read(appSettingsRepositoryProvider)
                          .set(dailyMealReminderSettingKey, formatReminderTime(picked.hour, picked.minute));
                      // Re-arm the notification straight away so the new time
                      // applies tonight, not from the next app open.
                      await ref.read(notificationServiceProvider).scheduleDailyMealReminder(
                            hour: picked.hour,
                            minute: picked.minute,
                            title: l10n.notifyMealReminderTitle,
                            body: l10n.notifyMealReminderBody,
                          );
                    },
                  );
                }),
                ListTile(
                  leading: const Icon(Icons.event_available_rounded),
                  title: Text(l10n.settingsMonthCloseReminder),
                  subtitle: Text(l10n.settingsLastDayOfMonth, style: const TextStyle(fontSize: 11.5)),
                  trailing: const Icon(Icons.check_circle_rounded, color: AppColors.teal600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionHeader(l10n.settingsDataSection),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_upload_rounded),
                  title: Text(l10n.settingsBackupRestore),
                  subtitle: lastBackup != null ? Text(l10n.backupBackedUpOn('')) : Text(l10n.backupNeverBackedUp, style: const TextStyle(fontSize: 11.5)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/backup'),
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline_rounded),
                  title: Text(l10n.helpTitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/help'),
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever_rounded, color: Theme.of(context).colorScheme.error),
                  title: Text(l10n.settingsResetData, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  subtitle: Text(l10n.settingsResetDataSub, style: const TextStyle(fontSize: 11.5)),
                  onTap: () => _showResetDialog(context, ref),
                ),
              ],
            ),
          ),
          // Deleting the whole mess is App-Admin-only and non-delegable —
          // the server refuses it for anyone else, so it isn't offered here
          // either. Kept in its own section at the very bottom, away from
          // everyday settings.
          if (isAppAdmin) ...[
            const SizedBox(height: 18),
            SectionHeader(l10n.settingsDangerSection),
            Card(
              child: ListTile(
                leading: Icon(Icons.delete_forever_rounded, color: Theme.of(context).colorScheme.error),
                title: Text(l10n.settingsDeleteMess, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                subtitle: Text(l10n.settingsDeleteMessSub, style: const TextStyle(fontSize: 11.5)),
                onTap: () => _showDeleteMessDialog(context, ref),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: AppBottomNav(groupId: groupId, current: AppTab.settings),
    );
  }

  /// Deleting a mess wipes every member's data, so it asks for the same
  /// typed confirmation as a full reset rather than a tap-through dialog.
  Future<void> _showDeleteMessDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final group = ref.read(selectedGroupProvider);
    if (group == null) return;
    final isOnline = group.inviteCode != null;
    final controller = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
          title: Text(l10n.deleteMessConfirmTitle(group.name)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.deleteMessConfirmBody, style: const TextStyle(fontSize: 12.5)),
              if (isOnline) ...[
                const SizedBox(height: 8),
                Text(l10n.deleteMessOfflineNote,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 12),
              Text(l10n.deleteMessConfirmHint, style: const TextStyle(fontSize: 12.5)),
              const SizedBox(height: 6),
              TextField(
                controller: controller,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [UpperCaseTextFormatter()],
                decoration: InputDecoration(hintText: l10n.settingsResetTypeHere),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.commonCancel)),
            FilledButton(
              onPressed: controller.text.trim() == 'DELETE' ? () => Navigator.of(dialogContext).pop(true) : null,
              style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
              child: Text(l10n.deleteMessButton),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;

    // Server first: if it refuses (offline, or no longer App Admin there),
    // stop and keep the local copy rather than destroying the only remaining
    // data and leaving the mess alive for everyone else.
    if (isOnline) {
      try {
        await ref.read(syncApiServiceProvider).deleteGroupRemote(groupId);
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.deleteMessFailed)));
        return;
      }
    }

    await ref.read(groupsRepositoryProvider).deleteGroupLocal(groupId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.deleteMessDone)));
    context.go('/groups');
  }

  Future<void> _toggleLock(BuildContext context, WidgetRef ref, bool enable) async {
    final service = ref.read(appLockServiceProvider);
    if (enable) {
      final hasPin = await service.hasPin();
      if (!context.mounted) return;
      if (hasPin) {
        await service.enable();
      } else {
        await showPinSetupDialog(context, ref);
      }
    } else {
      await service.disable();
    }
  }

  Future<void> _showResetDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
          title: Text(l10n.settingsResetData),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.settingsResetConfirmHint, style: const TextStyle(fontSize: 12.5)),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [UpperCaseTextFormatter()],
                decoration: InputDecoration(hintText: l10n.settingsResetTypeHere),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.commonCancel)),
            FilledButton(
              onPressed: controller.text.trim() == 'RESET' ? () => Navigator.of(dialogContext).pop(true) : null,
              style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
              child: Text(l10n.settingsResetData),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;
    final db = ref.read(databaseProvider);
    await db.transaction(() async {
      await db.delete(db.auditLog).go();
      await db.delete(db.mealPollVotes).go();
      await db.delete(db.mealPolls).go();
      await db.delete(db.memberMealRoutines).go();
      await db.delete(db.mealLeaves).go();
      await db.delete(db.mealSlots).go();
      await db.delete(db.recurringRules).go();
      await db.delete(db.months).go();
      await db.delete(db.settlements).go();
      await db.delete(db.deposits).go();
      await db.delete(db.meals).go();
      await db.delete(db.expenseSplits).go();
      await db.delete(db.expensePayers).go();
      await db.delete(db.expenses).go();
      await db.delete(db.categories).go();
      await db.delete(db.members).go();
      await db.delete(db.groups).go();
      await db.delete(db.appSettings).go();
    });
    if (context.mounted) context.go('/onboarding');
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
