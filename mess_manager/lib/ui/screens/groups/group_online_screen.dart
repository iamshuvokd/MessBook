import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/repository_providers.dart';

/// "Bring this mess online" (mints an invite code + first full push) and
/// manual re-sync, once it already is. Offline-first: nothing here is
/// required for the mess to keep working.
class GroupOnlineScreen extends ConsumerStatefulWidget {
  const GroupOnlineScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupOnlineScreen> createState() => _GroupOnlineScreenState();
}

class _GroupOnlineScreenState extends ConsumerState<GroupOnlineScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _bringOnline() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(syncServiceProvider).bringOnline(widget.groupId);
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).onlineBringOnlineError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _syncNow() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(syncServiceProvider).syncGroup(widget.groupId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).onlineSyncSuccess)));
      }
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).onlineSyncError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final signedIn = ref.watch(isSignedInProvider);
    final groups = ref.watch(activeGroupsProvider).value ?? const [];
    final matching = groups.where((g) => g.id == widget.groupId);
    final group = matching.isEmpty ? null : matching.first;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.onlineSectionTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!signedIn)
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_outline_rounded),
                title: Text(l10n.onlineSignInRequired),
                trailing: FilledButton(
                  onPressed: () => context.push('/account'),
                  child: Text(l10n.accountSignInButton),
                ),
              ),
            )
          else if (group?.isOnline ?? false)
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.cloud_done_rounded, color: AppColors.teal600),
                    title: Text(l10n.onlineAlreadyOnline),
                    subtitle: Text('${l10n.onlineInviteCodeLabel}: ${group!.inviteCode}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.share_rounded),
                    title: Text(l10n.onlineShareInvite),
                    onTap: () => SharePlus.instance.share(ShareParams(text: group.inviteCode!)),
                  ),
                  ListTile(
                    leading: _busy
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.sync_rounded),
                    title: Text(l10n.onlineSyncNow),
                    onTap: _busy ? null : _syncNow,
                  ),
                ],
              ),
            )
          else
            Card(
              child: ListTile(
                leading: const Icon(Icons.cloud_upload_rounded),
                title: Text(l10n.onlineBringOnlineTitle),
                subtitle: Text(l10n.onlineBringOnlineSub, style: const TextStyle(fontSize: 11.5)),
                trailing: FilledButton(
                  onPressed: _busy ? null : _bringOnline,
                  child: _busy
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l10n.onlineBringOnlineButton),
                ),
              ),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
        ],
      ),
    );
  }
}
