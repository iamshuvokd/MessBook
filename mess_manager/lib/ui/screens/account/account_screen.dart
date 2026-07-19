import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../data/repositories/app_settings_repository.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/section_header.dart';

/// Google sign-in for the online layer (accounts, sync, joining a mess on
/// another device). Purely opt-in — every offline feature works without
/// ever visiting this screen.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_circle_rounded),
              title: Text(user?.name ?? user?.email ?? l10n.accountNotSignedIn),
              subtitle: Text(
                user != null ? l10n.accountSignedInAs(user.email) : l10n.accountSignInSubtitle,
                style: const TextStyle(fontSize: 11.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: authState.isLoading ? null : () => user != null ? _signOut(ref) : _signIn(context, ref),
            icon: authState.isLoading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(user != null ? Icons.logout_rounded : Icons.login_rounded),
            label: Text(user != null ? l10n.accountSignOut : l10n.accountSignInButton),
          ),
          const SizedBox(height: 24),
          SectionHeader(l10n.accountServerSection),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _ServerUrlField(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signIn(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signIn();
    if (!context.mounted) return;
    final state = ref.read(authControllerProvider);
    if (state.hasError) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.accountSignInFailed)),
      );
    }
  }

  Future<void> _signOut(WidgetRef ref) => ref.read(authControllerProvider.notifier).signOut();
}

class _ServerUrlField extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ServerUrlField> createState() => _ServerUrlFieldState();
}

class _ServerUrlFieldState extends ConsumerState<_ServerUrlField> {
  final _controller = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = ref.watch(apiBaseUrlProvider).value ?? kDefaultApiBaseUrl;
    if (!_initialized) {
      _controller.text = current;
      _initialized = true;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(labelText: l10n.accountServerUrlLabel, hintText: l10n.accountServerUrlHint),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.check_rounded),
          onPressed: () async {
            await ref.read(appSettingsRepositoryProvider).set(apiBaseUrlSettingKey, _controller.text.trim());
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.accountServerUrlSaved)));
            }
          },
        ),
      ],
    );
  }
}
