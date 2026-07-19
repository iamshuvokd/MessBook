import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/group.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/empty_state.dart';

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final groups = ref.watch(activeGroupsProvider);
    final premium = ref.watch(premiumUnlockedProvider).value ?? false;
    final groupCount = groups.value?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.groupsTitle),
        actions: [
          IconButton(icon: const Icon(Icons.group_add_rounded), onPressed: () => context.push('/join')),
          IconButton(icon: const Icon(Icons.account_circle_outlined), onPressed: () => context.push('/account')),
          IconButton(icon: const Icon(Icons.bug_report_outlined), onPressed: () => context.push('/debug')),
        ],
      ),
      body: groups.when(
        data: (rows) => rows.isEmpty
            ? EmptyState(icon: Icons.home_work_rounded, title: l10n.groupsEmpty)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rows.length + 1,
                itemBuilder: (context, i) {
                  if (i == rows.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _FreeLimitNote(text: l10n.groupsFreeLimitNote),
                    );
                  }
                  return _GroupCard(group: rows[i], l10n: l10n);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.commonErrorPrefix(e.toString()))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => (premium || groupCount < 1) ? context.push('/groups/new') : context.push('/premium/paywall'),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _GroupCard extends ConsumerWidget {
  const _GroupCard({required this.group, required this.l10n});

  final Group group;
  final AppLocalizations l10n;

  IconData get _icon => switch (group.type) {
        GroupType.mess => Icons.home_rounded,
        GroupType.flat => Icons.apartment_rounded,
        GroupType.trip => Icons.beach_access_rounded,
        GroupType.other => Icons.folder_rounded,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: () {
          ref.read(selectedGroupIdProvider.notifier).select(group.id);
          context.push('/groups/${group.id}/dashboard');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: scheme.primaryContainer,
                foregroundColor: scheme.onPrimaryContainer,
                child: Icon(_icon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      group.mealEnabled ? '${_typeLabel(l10n, group.type)} · ${l10n.groupsMealsOn}' : _typeLabel(l10n, group.type),
                      style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'edit') context.push('/groups/${group.id}/edit');
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text(l10n.commonEdit)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(AppLocalizations l10n, GroupType type) => switch (type) {
        GroupType.mess => l10n.wizardTypeMess,
        GroupType.flat => l10n.wizardTypeFlat,
        GroupType.trip => l10n.wizardTypeTrip,
        GroupType.other => l10n.wizardTypeOther,
      };
}

class _FreeLimitNote extends StatelessWidget {
  const _FreeLimitNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.4),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium_rounded, color: scheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5))),
        ],
      ),
    );
  }
}
