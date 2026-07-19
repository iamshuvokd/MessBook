import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../domain/models/group.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/contact_picker_sheet.dart';
import '../../widgets/manual_member_dialog.dart';

class CreateGroupWizardScreen extends ConsumerStatefulWidget {
  const CreateGroupWizardScreen({super.key});

  @override
  ConsumerState<CreateGroupWizardScreen> createState() => _CreateGroupWizardScreenState();
}

class _DraftMember {
  _DraftMember(this.name, this.phone);
  final String name;
  final String? phone;
}

class _CreateGroupWizardScreenState extends ConsumerState<CreateGroupWizardScreen> {
  int _step = 0;
  final _nameController = TextEditingController();
  final _managerNameController = TextEditingController();
  GroupType _type = GroupType.mess;
  int _monthStartDay = 1;
  bool _mealEnabled = true;
  final _members = <_DraftMember>[];
  bool _creating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _managerNameController.dispose();
    super.dispose();
  }

  bool get _nameValid => _nameController.text.trim().isNotEmpty && _managerNameController.text.trim().isNotEmpty;

  Future<void> _addFromContacts() async {
    final picked = await showContactPickerSheet(context);
    if (picked == null) return;
    setState(() {
      for (final c in picked) {
        _members.add(_DraftMember(c.name, c.phone));
      }
    });
  }

  Future<void> _addManually() async {
    final result = await showManualMemberDialog(context);
    if (result != null) setState(() => _members.add(_DraftMember(result.name, result.phone)));
  }

  Future<void> _finish() async {
    setState(() => _creating = true);
    try {
      final groupsRepo = ref.read(groupsRepositoryProvider);
      final membersRepo = ref.read(membersRepositoryProvider);
      final group = await groupsRepo.createGroup(
        name: _nameController.text.trim(),
        type: _type,
        monthStartDay: _monthStartDay,
        mealEnabled: _mealEnabled,
        managerName: _managerNameController.text.trim(),
      );
      if (_members.isNotEmpty) {
        await membersRepo.addMembersFromContacts(
          group.id,
          [for (final m in _members) (name: m.name, phone: m.phone)],
        );
      }
      ref.read(selectedGroupIdProvider.notifier).select(group.id);
      if (!mounted) return;
      context.go('/groups');
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = [
      _buildNameStep(l10n),
      _buildSettingsStep(l10n),
      _buildMembersStep(l10n),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _step == 0 ? () => context.pop() : () => setState(() => _step -= 1),
        ),
        title: Text(l10n.groupsNewGroup),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: steps[_step])),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: FilledButton(
                onPressed: _creating ? null : _onPrimaryPressed,
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                child: _creating
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_step < 2 ? l10n.commonNext : l10n.wizardFinish),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPrimaryPressed() {
    if (_step == 0 && !_nameValid) return;
    if (_step < 2) {
      setState(() => _step += 1);
    } else {
      _finish();
    }
  }

  Widget _buildNameStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.wizardStepName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(hintText: l10n.wizardStepNameHint),
        ),
        const SizedBox(height: 20),
        Text(l10n.wizardManagerName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(l10n.wizardManagerNameSub, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 8),
        TextField(
          controller: _managerNameController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(hintText: l10n.wizardManagerNameHint),
        ),
      ],
    );
  }

  Widget _buildSettingsStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.wizardStepType, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        SegmentedButton<GroupType>(
          segments: [
            ButtonSegment(value: GroupType.mess, label: Text(l10n.wizardTypeMess)),
            ButtonSegment(value: GroupType.flat, label: Text(l10n.wizardTypeFlat)),
            ButtonSegment(value: GroupType.trip, label: Text(l10n.wizardTypeTrip)),
            ButtonSegment(value: GroupType.other, label: Text(l10n.wizardTypeOther)),
          ],
          selected: {_type},
          onSelectionChanged: (s) => setState(() => _type = s.first),
        ),
        const SizedBox(height: 20),
        Text(l10n.wizardMonthStartsOn, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton.outlined(
              icon: const Icon(Icons.remove_rounded),
              onPressed: _monthStartDay > 1 ? () => setState(() => _monthStartDay -= 1) : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('$_monthStartDay', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
            IconButton.outlined(
              icon: const Icon(Icons.add_rounded),
              onPressed: _monthStartDay < 28 ? () => setState(() => _monthStartDay += 1) : null,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  child: const Icon(Icons.restaurant_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.wizardMealTracking, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(l10n.wizardMealTrackingSub, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Switch(value: _mealEnabled, onChanged: (v) => setState(() => _mealEnabled = v)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.wizardStepMembers, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(l10n.wizardStepMembersSub, style: TextStyle(fontSize: 12.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: FilledButton.icon(
                onPressed: _addFromContacts,
                icon: const Icon(Icons.contact_phone_rounded),
                label: Text(l10n.wizardAddFromContacts),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: _addManually,
                icon: const Icon(Icons.edit_rounded),
                label: Text(l10n.wizardAddManually),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final m in _members)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(child: Text(m.name.isNotEmpty ? m.name[0].toUpperCase() : '?')),
              title: Text(m.name),
              subtitle: m.phone != null ? Text(m.phone!) : null,
              trailing: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => setState(() => _members.remove(m)),
              ),
            ),
          ),
      ],
    );
  }
}
