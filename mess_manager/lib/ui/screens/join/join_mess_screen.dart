import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/sync_api_service.dart';
import '../../providers/repository_providers.dart';
import '../settings/settings_screen.dart' show UpperCaseTextFormatter;

/// Joins an already-online mess by invite code. Two steps: look up the code
/// (offering "is this you?" against members already created offline, so
/// joining doesn't always spawn a duplicate row), then either claim one of
/// those or add yourself as new. Requires being signed in — the rest of the
/// app never needs it.
class JoinMessScreen extends ConsumerStatefulWidget {
  const JoinMessScreen({super.key});

  @override
  ConsumerState<JoinMessScreen> createState() => _JoinMessScreenState();
}

enum _JoinStep { code, identity }

class _JoinMessScreenState extends ConsumerState<JoinMessScreen> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  _JoinStep _step = _JoinStep.code;
  InviteCodeLookup? _lookup;
  String? _selectedMemberId; // null while _isNew is true
  bool _isNew = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _lookupCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final lookup = await ref.read(syncServiceProvider).lookupInviteCode(code);
      if (!mounted) return;
      setState(() {
        _lookup = lookup;
        _isNew = lookup.unclaimedMembers.isEmpty;
        _selectedMemberId = null;
        _step = _JoinStep.identity;
      });
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).joinLookupError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _join() async {
    final code = _codeController.text.trim();
    final name = _nameController.text.trim();
    if (!_isNew && _selectedMemberId == null) return;
    if (_isNew && name.isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await ref.read(syncServiceProvider).joinGroup(
            code: code,
            memberName: _isNew ? name : null,
            existingMemberId: _isNew ? null : _selectedMemberId,
          );
      // Without this, "acting as" would default to the App Admin on this
      // device (the offline single-shared-phone default) — meaning this
      // member would see full admin permissions locally regardless of the
      // role they were actually given, until someone manually switched it
      // in Settings. Joining on your own device should mean acting as
      // *yourself* from the start.
      await ref.read(appSettingsRepositoryProvider).set('actingAs_${result.groupId}', result.memberId);
      if (!mounted) return;
      ref.read(selectedGroupIdProvider.notifier).select(result.groupId);
      context.go('/groups/${result.groupId}/dashboard');
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context).joinError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final signedIn = ref.watch(isSignedInProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.joinTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: !signedIn
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.joinSignInRequired, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: () => context.push('/account'), child: Text(l10n.accountSignInButton)),
                  ],
                ),
              )
            : _step == _JoinStep.code
                ? _buildCodeStep(l10n)
                : _buildIdentityStep(l10n),
      ),
    );
  }

  Widget _buildCodeStep(AppLocalizations l10n) {
    return ListView(
      children: [
        TextField(
          controller: _codeController,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [UpperCaseTextFormatter()],
          decoration: InputDecoration(labelText: l10n.joinCodeLabel, hintText: l10n.joinCodeHint),
          onSubmitted: (_) => _lookupCode(),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _busy ? null : _lookupCode,
          child: _busy
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(l10n.joinContinue),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
      ],
    );
  }

  Widget _buildIdentityStep(AppLocalizations l10n) {
    final lookup = _lookup!;
    return ListView(
      children: [
        Text(lookup.groupName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(l10n.joinIdentityQuestion, style: const TextStyle(fontSize: 12.5, color: Colors.grey)),
        const SizedBox(height: 12),
        for (final member in lookup.unclaimedMembers)
          _IdentityTile(
            label: member.name,
            selected: !_isNew && _selectedMemberId == member.id,
            onTap: () => setState(() {
              _isNew = false;
              _selectedMemberId = member.id;
            }),
          ),
        _IdentityTile(
          label: l10n.joinImNew,
          selected: _isNew,
          onTap: () => setState(() {
            _isNew = true;
            _selectedMemberId = null;
          }),
        ),
        if (_isNew) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: l10n.joinYourNameLabel, hintText: l10n.joinYourNameHint),
          ),
        ],
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _busy ? null : _join,
          child: _busy
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(l10n.joinButton),
        ),
        TextButton(
          onPressed: _busy ? null : () => setState(() => _step = _JoinStep.code),
          child: Text(l10n.joinChangeCode),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
      ],
    );
  }
}

class _IdentityTile extends StatelessWidget {
  const _IdentityTile({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
          color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
        ),
        title: Text(label),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    );
  }
}
