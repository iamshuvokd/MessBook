import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../data/repositories/app_settings_repository.dart';
import '../../../data/services/backup_service.dart';
import '../../../data/services/drive_auto_backup_task.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _exporting = false;
  bool _importing = false;
  bool _drivePending = false;
  String? _driveEmail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final lastBackup = ref.watch(lastBackupAtProvider).value;
    final premium = ref.watch(premiumUnlockedProvider).value ?? false;
    final driveEnabled = ref.watch(driveAutoBackupEnabledProvider).value ?? false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(l10n.backupTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
              border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(AppRadius.xxl),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Icon(lastBackup != null ? Icons.cloud_done_rounded : Icons.cloud_off_rounded),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    lastBackup != null ? l10n.backupBackedUpOn(fmt.day(lastBackup)) : l10n.backupNeverBackedUp,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _exporting ? null : _export,
                  icon: _exporting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.upload_file_rounded),
                  label: Text(l10n.backupExport),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _importing ? null : _pickAndPreviewImport,
                  icon: _importing
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.download_rounded),
                  label: Text(l10n.backupImport),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(l10n.backupDriveSection, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.4, color: Colors.grey)),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: _drivePending
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.cloud_sync_rounded),
              title: Text(l10n.backupDriveToggleTitle),
              subtitle: Text(
                !premium
                    ? l10n.backupDrivePremiumNote
                    : (driveEnabled && _driveEmail != null)
                        ? l10n.backupDriveSignedInAs(_driveEmail!)
                        : l10n.backupDriveToggleSub,
                style: const TextStyle(fontSize: 11.5),
              ),
              value: driveEnabled,
              onChanged: (!premium || _drivePending) ? null : (v) => _toggleDrive(v),
            ),
          ),
          if (!premium)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: TextButton(onPressed: () => context.push('/premium/paywall'), child: Text(l10n.settingsPremiumBanner)),
            ),
        ],
      ),
    );
  }

  Future<void> _toggleDrive(bool enable) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _drivePending = true);
    try {
      final settings = ref.read(appSettingsRepositoryProvider);
      if (enable) {
        final drive = ref.read(driveBackupServiceProvider);
        final account = await drive.signIn(interactive: true);
        if (account == null) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.backupDriveSignInFailed)));
          return;
        }
        _driveEmail = account.email;
        await scheduleDriveAutoBackup();
        await settings.set(driveAutoBackupEnabledSettingKey, 'true');
        await drive.backupNow(interactive: true);
        await settings.set(lastBackupAtSettingKey, DateTime.now().millisecondsSinceEpoch.toString());
      } else {
        await cancelDriveAutoBackup();
        await settings.set(driveAutoBackupEnabledSettingKey, 'false');
      }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.backupDriveSignInFailed)));
    } finally {
      if (mounted) setState(() => _drivePending = false);
    }
  }

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      final service = ref.read(backupServiceProvider);
      final json = await service.exportJson();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${service.suggestedFileName()}');
      await file.writeAsString(json);
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
      await ref
          .read(appSettingsRepositoryProvider)
          .set(lastBackupAtSettingKey, DateTime.now().millisecondsSinceEpoch.toString());
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _pickAndPreviewImport() async {
    setState(() => _importing = true);
    try {
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (picked == null || picked.path == null) return;
      final content = await File(picked.path!).readAsString();
      if (!mounted) return;

      final l10n = AppLocalizations.of(context);
      final service = ref.read(backupServiceProvider);
      BackupPreview preview;
      try {
        preview = service.preview(content);
      } on BackupValidationError catch (e) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(l10n.backupInvalidTitle),
            content: Text(e.message),
            actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonClose))],
          ),
        );
        return;
      }

      if (!mounted) return;
      final confirmed = await _showImportPreviewSheet(preview);
      if (confirmed != true) return;

      await service.importReplaceAll(content);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.backupImportSuccess)));
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<bool?> _showImportPreviewSheet(BackupPreview preview) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.read(localeProvider);
    final banglaDigits = ref.read(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);

    return showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.backupImportPreviewTitle, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Row(children: [
              Icon(Icons.verified_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(l10n.backupChecksumValid(preview.schemaVersion), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 4),
            Text(l10n.backupExportedOn(fmt.day(preview.exportedAt)), style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                Chip(label: Text(l10n.backupPreviewGroups(fmt.number(preview.groupCount)))),
                Chip(label: Text(l10n.backupPreviewMembers(fmt.number(preview.memberCount)))),
                Chip(label: Text(l10n.backupPreviewExpenses(fmt.number(preview.expenseCount)))),
                Chip(label: Text(l10n.backupPreviewMeals(fmt.number(preview.mealCount)))),
                Chip(label: Text(l10n.backupPreviewDeposits(fmt.number(preview.depositCount)))),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
                border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 18, color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(child: Text(l10n.backupImportWarning, style: const TextStyle(fontSize: 12))),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.of(sheetContext).pop(false), child: Text(l10n.commonCancel))),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => Navigator.of(sheetContext).pop(true),
                    style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                    child: Text(l10n.backupImportConfirm),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
