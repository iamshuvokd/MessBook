import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart' show openAppSettings;

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/members_repository.dart';
import '../../data/services/contacts_service.dart';
import '../providers/repository_providers.dart';

/// Bottom sheet for multi-selecting phone contacts to import as members.
/// Returns the selected [ContactDraft]s, or null if the user cancelled.
Future<List<ContactDraft>?> showContactPickerSheet(BuildContext context) {
  return showModalBottomSheet<List<ContactDraft>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    // This sheet draws its own drag handle below; the theme's default
    // would otherwise double it up.
    showDragHandle: false,
    builder: (_) => const _ContactPickerSheet(),
  );
}

class _ContactPickerSheet extends ConsumerStatefulWidget {
  const _ContactPickerSheet();

  @override
  ConsumerState<_ContactPickerSheet> createState() => _ContactPickerSheetState();
}

class _ContactPickerSheetState extends ConsumerState<_ContactPickerSheet> {
  List<ContactDraft>? _contacts;
  ContactsPermissionResult? _permission;
  final _selected = <ContactDraft>{};
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final service = ref.read(contactsServiceProvider);
    final result = await service.requestPermission();
    if (!mounted) return;
    setState(() => _permission = result);
    if (result != ContactsPermissionResult.granted) return;
    final contacts = await service.loadContacts();
    if (!mounted) return;
    setState(() => _contacts = contacts);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mediaHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: mediaHeight * 0.85),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.contactsPickerTitle,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (_selected.isNotEmpty)
                    Chip(
                      label: Text(l10n.contactsSelected(_selected.length)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w700),
                      side: BorderSide.none,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(child: _buildBody(context, l10n)),
              if (_permission == ContactsPermissionResult.granted && (_contacts?.isNotEmpty ?? false)) ...[
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _selected.isEmpty ? null : () => Navigator.of(context).pop(_selected.toList()),
                  icon: const Icon(Icons.group_add_rounded),
                  label: Text(l10n.contactsAddSelected(_selected.length)),
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_permission == null) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_permission == ContactsPermissionResult.denied) {
      return _PermissionMessage(text: l10n.contactsPermissionDenied, onRetry: _load, retryLabel: l10n.commonRetry);
    }
    if (_permission == ContactsPermissionResult.permanentlyDenied) {
      return _PermissionMessage(
        text: l10n.contactsPermissionPermanentlyDenied,
        onRetry: () async {
          await openAppSettings();
        },
        retryLabel: l10n.contactsOpenSettings,
      );
    }
    if (_contacts == null) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final filtered = _query.isEmpty
        ? _contacts!
        : _contacts!.where((c) => c.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded),
            hintText: l10n.contactsSearchHint,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 10),
        Flexible(
          child: filtered.isEmpty
              ? Padding(padding: const EdgeInsets.all(24), child: Text(l10n.contactsEmpty))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final c = filtered[i];
                    final selected = _selected.contains(c);
                    return CheckboxListTile(
                      value: selected,
                      onChanged: (_) => setState(() {
                        selected ? _selected.remove(c) : _selected.add(c);
                      }),
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: c.phone != null ? Text(c.phone!) : null,
                      secondary: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        child: Text(c.name.isNotEmpty ? c.name[0].toUpperCase() : '?'),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _PermissionMessage extends StatelessWidget {
  const _PermissionMessage({required this.text, required this.onRetry, required this.retryLabel});

  final String text;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.contact_phone_outlined, size: 40, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center),
          const SizedBox(height: 14),
          OutlinedButton(onPressed: onRetry, child: Text(retryLabel)),
        ],
      ),
    );
  }
}
