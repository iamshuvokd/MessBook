import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../domain/models/member.dart';
import '../../../domain/models/member_permission.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/assign_role_sheet.dart';
import '../../widgets/contact_picker_sheet.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/manual_member_dialog.dart';
import '../../widgets/sync_refresh_indicator.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Ensure the selection matches this route (e.g. deep link / back navigation).
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(groupId);
      }
    });
    ref.watch(foregroundGroupSyncProvider); // near-live: re-sync while open
    final members = ref.watch(membersRepositoryProvider).watchMembers(groupId);
    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final canManage = ref.watch(canProvider(MemberPermission.membersManage));
    final isAppAdmin = ref.watch(actingAsMemberProvider)?.isAppAdmin ?? true;
    final mealEnabled = ref.watch(selectedGroupProvider)?.mealEnabled ?? true;
    final canManageMeals = ref.watch(canProvider(MemberPermission.mealsManage));
    final rolesConfigured = ref.watch(rolesConfiguredProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(l10n.membersTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded),
            tooltip: l10n.expensesTitle,
            onPressed: () => context.push('/groups/$groupId/expenses'),
          ),
        ],
      ),
      body: SyncRefreshIndicator(
        groupId: groupId,
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (canManage) ...[
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: FilledButton.icon(
                      onPressed: () => _addFromContacts(context, ref),
                      icon: const Icon(Icons.contact_phone_rounded),
                      label: Text(l10n.wizardAddFromContacts),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: () => _addManually(context, ref),
                      icon: const Icon(Icons.edit_rounded),
                      label: Text(l10n.wizardAddManually),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            if (isAppAdmin && !rolesConfigured) ...[
              InkWell(
                borderRadius: BorderRadius.circular(AppRadius.md),
                onTap: () => context.push('/groups/$groupId/roles'),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.honey300.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.honey600.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 20, color: AppColors.honey600),
                      const SizedBox(width: 10),
                      Expanded(child: Text(l10n.membersRolesHint, style: const TextStyle(fontSize: 12))),
                      const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.honey600),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: StreamBuilder(
                stream: members,
                builder: (context, snapshot) {
                  final rows = snapshot.data;
                  if (rows == null) return const Center(child: CircularProgressIndicator());
                  if (rows.isEmpty) return EmptyState(icon: Icons.people_outline_rounded, title: l10n.membersEmpty);
                  return ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, i) => _MemberTile(
                      member: rows[i],
                      l10n: l10n,
                      fmt: fmt,
                      canManage: canManage,
                      isAppAdmin: isAppAdmin,
                      groupId: groupId,
                      showRoutine: mealEnabled,
                      canManageMeals: canManageMeals,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Future<void> _addFromContacts(BuildContext context, WidgetRef ref) async {
    final picked = await showContactPickerSheet(context);
    if (picked == null || picked.isEmpty) return;
    await ref.read(membersRepositoryProvider).addMembersFromContacts(
          groupId,
          [for (final c in picked) (name: c.name, phone: c.phone)],
        );
    triggerBackgroundSync(ref, groupId);
  }

  Future<void> _addManually(BuildContext context, WidgetRef ref) async {
    final result = await showManualMemberDialog(context);
    if (result == null) return;
    await ref.read(membersRepositoryProvider).addMember(
          groupId: groupId,
          name: result.name,
          phone: result.phone,
        );
    triggerBackgroundSync(ref, groupId);
  }
}

class _MemberTile extends ConsumerWidget {
  const _MemberTile({
    required this.member,
    required this.l10n,
    required this.fmt,
    required this.canManage,
    required this.isAppAdmin,
    required this.groupId,
    required this.showRoutine,
    required this.canManageMeals,
  });

  final Member member;
  final AppLocalizations l10n;
  final BdFormatter fmt;
  final bool canManage;
  final bool isAppAdmin;
  final String groupId;
  final bool showRoutine;
  final bool canManageMeals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final subtitle = member.active
        ? [
            if (member.phone != null) member.phone!,
            l10n.membersJoined(fmt.day(member.joinDate)),
          ].join(' · ')
        : l10n.membersLeft(member.leaveDate != null ? fmt.day(member.leaveDate!) : '');

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: member.active ? 1 : 0.55,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: scheme.primaryContainer,
            foregroundColor: scheme.onPrimaryContainer,
            child: Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?'),
          ),
          title: Row(
            children: [
              Flexible(child: Text(member.name, style: const TextStyle(fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
              if (member.role == MemberRole.appAdmin) ...[
                const SizedBox(width: 6),
                _RoleBadge(text: l10n.membersManagerBadge, color: AppColors.honey600),
              ] else if (member.role == MemberRole.subAdmin) ...[
                const SizedBox(width: 6),
                _RoleBadge(text: l10n.membersSubAdminBadge, color: AppColors.teal600),
              ],
            ],
          ),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12.5)),
          trailing: !member.active
              ? (canManage
                  ? TextButton(
                      onPressed: () {
                        ref.read(membersRepositoryProvider).reactivateMember(member.id);
                        triggerBackgroundSync(ref, groupId);
                      },
                      child: Text(l10n.membersReactivate),
                    )
                  : null)
              : (canManage || isAppAdmin || (showRoutine && canManageMeals))
                  ? PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v == 'deactivate') {
                          ref.read(membersRepositoryProvider).deactivateMember(member.id);
                          triggerBackgroundSync(ref, groupId);
                        } else if (v == 'edit') {
                          _editMember(context, ref);
                        } else if (v == 'role') {
                          showAssignRoleSheet(context, member);
                        } else if (v == 'routine') {
                          context.push('/groups/$groupId/members/${member.id}/routine?name=${Uri.encodeComponent(member.name)}');
                        } else if (v == 'delete') {
                          _deleteMember(context, ref);
                        }
                      },
                      itemBuilder: (context) => [
                        if (canManage) PopupMenuItem(value: 'edit', child: Text(l10n.commonEdit)),
                        if (showRoutine && canManageMeals) PopupMenuItem(value: 'routine', child: Text(l10n.membersMealRoutine)),
                        // Role assignment is always App-Admin-only, even for
                        // a sub-admin holding members.manage (user decision:
                        // non-delegable, to prevent privilege escalation).
                        if (isAppAdmin) PopupMenuItem(value: 'role', child: Text(l10n.membersAssignRole)),
                        if (canManage) PopupMenuItem(value: 'deactivate', child: Text(l10n.membersDeactivate)),
                        if (canManage)
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(l10n.membersDelete, style: TextStyle(color: scheme.error)),
                          ),
                      ],
                    )
                  : null,
        ),
      ),
    );
  }

  Future<void> _editMember(BuildContext context, WidgetRef ref) async {
    final result = await showManualMemberDialog(context, initialName: member.name, initialPhone: member.phone);
    if (result == null) return;
    await ref.read(membersRepositoryProvider).updateMember(
          member.copyWith(name: result.name, phone: result.phone),
        );
    triggerBackgroundSync(ref, groupId);
  }

  Future<void> _deleteMember(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.membersDeleteConfirmTitle),
        content: Text(l10n.membersDeleteConfirmBody(member.name)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.membersDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final deleted = await ref.read(membersRepositoryProvider).deleteMemberPermanently(member.id);
    if (!deleted) {
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n.membersDeleteBlockedTitle),
          content: Text(l10n.membersDeleteBlockedBody),
          actions: [FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonClose))],
        ),
      );
      return;
    }

    final group = ref.read(selectedGroupProvider);
    if (group?.isOnline ?? false) {
      try {
        await ref.read(syncApiServiceProvider).deleteMemberRemote(groupId, member.id);
      } catch (_) {
        // Local delete already succeeded; the periodic/background sync will
        // retry telling the server once connectivity allows.
      }
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.membersDeleted(member.name))));
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(text, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.3)),
    );
  }
}
