import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../domain/models/member.dart';
import '../../domain/models/member_permission.dart';
import '../providers/repository_providers.dart';

Future<void> showAssignRoleSheet(BuildContext context, Member member) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AssignRoleSheet(member: member),
  );
}

class _AssignRoleSheet extends ConsumerStatefulWidget {
  const _AssignRoleSheet({required this.member});

  final Member member;

  @override
  ConsumerState<_AssignRoleSheet> createState() => _AssignRoleSheetState();
}

class _AssignRoleSheetState extends ConsumerState<_AssignRoleSheet> {
  late MemberRole _role = widget.member.role;
  late Set<MemberPermission> _permissions = {...widget.member.permissions};
  bool _saving = false;

  String _presetLabel(AppLocalizations l10n, PermissionPreset preset) => switch (preset) {
        PermissionPreset.mealAdmin => l10n.presetMealAdmin,
        PermissionPreset.expenseAdmin => l10n.presetExpenseAdmin,
        PermissionPreset.pollCreator => l10n.presetPollCreator,
        PermissionPreset.memberAdmin => l10n.presetMemberAdmin,
      };

  String _permissionLabel(AppLocalizations l10n, MemberPermission p) => switch (p) {
        MemberPermission.mealsManage => l10n.permissionMealsManage,
        MemberPermission.pollsCreate => l10n.permissionPollsCreate,
        MemberPermission.pollsManage => l10n.permissionPollsManage,
        MemberPermission.expensesManage => l10n.permissionExpensesManage,
        MemberPermission.moneyManage => l10n.permissionMoneyManage,
        MemberPermission.membersManage => l10n.permissionMembersManage,
      };

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(membersRepositoryProvider).setRole(widget.member.id, _role, permissions: _permissions);
    triggerBackgroundSync(ref, widget.member.groupId);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.membersRoleSheetTitle(widget.member.name), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _RoleOption(
              title: l10n.membersRoleMember,
              subtitle: l10n.membersRoleMemberSub,
              selected: _role == MemberRole.member,
              onTap: () => setState(() => _role = MemberRole.member),
            ),
            _RoleOption(
              title: l10n.membersRoleSubAdmin,
              subtitle: l10n.membersRoleSubAdminSub,
              selected: _role == MemberRole.subAdmin,
              onTap: () => setState(() => _role = MemberRole.subAdmin),
            ),
            _RoleOption(
              title: l10n.membersRoleAppAdmin,
              subtitle: l10n.membersRoleAppAdminSub,
              selected: _role == MemberRole.appAdmin,
              onTap: () => setState(() => _role = MemberRole.appAdmin),
            ),
            if (_role == MemberRole.subAdmin) ...[
              const SizedBox(height: 12),
              Text(l10n.membersCustomPermissions, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final preset in PermissionPreset.values)
                    ActionChip(
                      avatar: const Icon(Icons.auto_awesome_rounded, size: 16),
                      label: Text(_presetLabel(l10n, preset)),
                      onPressed: () => setState(() => _permissions = {...preset.permissions}),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Card(
                child: Column(
                  children: [
                    for (final p in MemberPermission.values)
                      CheckboxListTile(
                        dense: true,
                        title: Text(_permissionLabel(l10n, p), style: const TextStyle(fontSize: 13.5)),
                        value: _permissions.contains(p),
                        onChanged: (v) => setState(() {
                          if (v == true) {
                            _permissions.add(p);
                          } else {
                            _permissions.remove(p);
                          }
                        }),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({required this.title, required this.subtitle, required this.selected, required this.onTap});

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: selected ? scheme.primaryContainer.withValues(alpha: 0.5) : null,
      child: ListTile(
        leading: Icon(
          selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
          color: selected ? scheme.primary : scheme.outline,
        ),
        onTap: onTap,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11.5)),
      ),
    );
  }
}
