import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/member.dart';
import '../../../domain/models/member_permission.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/assign_role_sheet.dart';
import '../../widgets/section_header.dart';

/// One place for the App Admin to see and change every member's role and
/// custom permissions, plus preview the app as any member. Reachable from
/// Settings, the drawer, and the Members-screen hint banner.
class RolesScreen extends ConsumerWidget {
  const RolesScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(groupId);
      }
    });

    final members = ref.watch(membersOfSelectedGroupProvider).value ?? const <Member>[];
    final activeMembers = members.where((m) => m.active).toList();
    final rolesConfigured = ref.watch(rolesConfiguredProvider);
    final isAppAdmin = ref.watch(actingAsMemberProvider)?.isAppAdmin ?? true;
    final actingAsId = ref.watch(actingAsMemberIdProvider).value;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(l10n.settingsRolesSection),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!rolesConfigured) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.honey300.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.honey600.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 20, color: AppColors.honey600),
                  const SizedBox(width: 10),
                  Expanded(child: Text(l10n.rolesIntroBody, style: const TextStyle(fontSize: 12.5))),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          SectionHeader(l10n.membersTitle),
          Card(
            child: Column(
              children: [
                for (final member in activeMembers)
                  ListTile(
                    leading: CircleAvatar(child: Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?')),
                    title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(_permissionSummary(l10n, member), style: const TextStyle(fontSize: 12)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _RoleChip(member: member, l10n: l10n),
                        if (isAppAdmin) const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                    onTap: isAppAdmin ? () => showAssignRoleSheet(context, member) : null,
                  ),
              ],
            ),
          ),
          if (isAppAdmin && activeMembers.length > 1) ...[
            const SizedBox(height: 20),
            SectionHeader(l10n.rolesTransferSection),
            Card(
              child: ListTile(
                leading: Icon(Icons.swap_horiz_rounded, color: Theme.of(context).colorScheme.error),
                title: Text(l10n.rolesTransferTitle),
                subtitle: Text(l10n.rolesTransferSub, style: const TextStyle(fontSize: 11.5)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _transferOwnership(context, ref, activeMembers),
              ),
            ),
          ],
          if (rolesConfigured) ...[
            const SizedBox(height: 20),
            SectionHeader(l10n.settingsActingAsSection),
            Card(
              child: ListTile(
                leading: const Icon(Icons.switch_account_rounded),
                title: Text(l10n.settingsActingAs),
                subtitle: Text(l10n.settingsActingAsSub, style: const TextStyle(fontSize: 11.5)),
                trailing: DropdownButton<String?>(
                  value: actingAsId,
                  underline: const SizedBox.shrink(),
                  hint: Text(l10n.settingsActingAsNone, style: const TextStyle(fontSize: 12.5)),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.settingsActingAsNone, style: const TextStyle(fontSize: 12.5))),
                    for (final m in members) DropdownMenuItem(value: m.id, child: Text(m.name, style: const TextStyle(fontSize: 12.5))),
                  ],
                  onChanged: (v) => ref.read(appSettingsRepositoryProvider).set('actingAs_$groupId', v ?? ''),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _transferOwnership(BuildContext context, WidgetRef ref, List<Member> activeMembers) async {
    final l10n = AppLocalizations.of(context);
    final self = ref.read(actingAsMemberProvider);
    final candidates = activeMembers.where((m) => m.role != MemberRole.appAdmin).toList();
    if (self == null || candidates.isEmpty) return;

    // Pick the new manager.
    final target = await showModalBottomSheet<Member>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.rolesTransferPick, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
            for (final m in candidates)
              ListTile(
                leading: CircleAvatar(child: Text(m.name.isNotEmpty ? m.name[0].toUpperCase() : '?')),
                title: Text(m.name),
                onTap: () => Navigator.of(sheetContext).pop(m),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (target == null || !context.mounted) return;

    // Confirm — this is irreversible from the losing side (they become a
    // plain member and can't take it back without the new manager's help).
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.rolesTransferConfirmTitle),
        content: Text(l10n.rolesTransferConfirmBody(target.name)),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.commonCancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.rolesTransferConfirmButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final group = ref.read(selectedGroupProvider);
    final isOnline = group?.isOnline ?? false;

    // For online messes the server is the gate (it also moves ownership and
    // rejects a target who hasn't joined online yet) — do it first so a
    // failure aborts before any local change.
    if (isOnline) {
      try {
        await ref.read(syncApiServiceProvider).transferOwnershipRemote(groupId, target.id);
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.rolesTransferNotJoined)));
        return;
      }
    }

    final repo = ref.read(membersRepositoryProvider);
    await repo.setRole(target.id, MemberRole.appAdmin);
    await repo.setRole(self.id, MemberRole.member);
    triggerBackgroundSync(ref, groupId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.rolesTransferDone(target.name))));
  }

  String _permissionSummary(AppLocalizations l10n, Member member) {
    switch (member.role) {
      case MemberRole.appAdmin:
        return l10n.rolesFullAccess;
      case MemberRole.member:
        return l10n.rolesViewOnly;
      case MemberRole.subAdmin:
        if (member.permissions.isEmpty) return l10n.rolesViewOnly;
        return member.permissions.map((p) => _permissionLabel(l10n, p)).join(' · ');
    }
  }

  String _permissionLabel(AppLocalizations l10n, MemberPermission p) => switch (p) {
        MemberPermission.mealsManage => l10n.permissionMealsManage,
        MemberPermission.pollsCreate => l10n.permissionPollsCreate,
        MemberPermission.pollsManage => l10n.permissionPollsManage,
        MemberPermission.expensesManage => l10n.permissionExpensesManage,
        MemberPermission.moneyManage => l10n.permissionMoneyManage,
        MemberPermission.membersManage => l10n.permissionMembersManage,
      };
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.member, required this.l10n});

  final Member member;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (text, color) = switch (member.role) {
      MemberRole.appAdmin => (l10n.membersManagerBadge, AppColors.honey600),
      MemberRole.subAdmin => (l10n.membersSubAdminBadge, AppColors.teal600),
      MemberRole.member => (l10n.membersRoleMember, Colors.grey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
    );
  }
}
