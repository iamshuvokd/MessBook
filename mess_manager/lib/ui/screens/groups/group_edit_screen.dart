import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../domain/models/group.dart';
import '../../../domain/models/non_voter_policy.dart';
import '../../providers/repository_providers.dart';

class GroupEditScreen extends ConsumerStatefulWidget {
  const GroupEditScreen({super.key, this.groupId});

  final String? groupId;

  @override
  ConsumerState<GroupEditScreen> createState() => _GroupEditScreenState();
}

class _GroupEditScreenState extends ConsumerState<GroupEditScreen> {
  final _nameController = TextEditingController();
  final _managerNameController = TextEditingController();
  GroupType _type = GroupType.mess;
  int _monthStartDay = 1;
  bool _mealEnabled = true;
  bool _mealLedgerSeparate = false;
  NonVoterPolicy _defaultNonVoterPolicy = NonVoterPolicy.routine;
  int _pollReminderMinutes = 30;
  final _lowBalanceController = TextEditingController();
  bool _autoMealOffBelowThreshold = false;
  Group? _existing;

  /// Lead-time choices for the mess-wide poll reminder; 0 = off.
  static const _reminderChoices = [0, 10, 15, 20, 30, 45, 60];
  bool _loading = false;
  bool _saving = false;

  bool get _isEdit => widget.groupId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final group = await ref.read(groupsRepositoryProvider).getGroup(widget.groupId!);
    if (!mounted || group == null) return;
    setState(() {
      _existing = group;
      _nameController.text = group.name;
      _type = group.type;
      _monthStartDay = group.monthStartDay;
      _mealEnabled = group.mealEnabled;
      _mealLedgerSeparate = group.mealLedgerSeparate;
      _defaultNonVoterPolicy = group.defaultNonVoterPolicy;
      _pollReminderMinutes = group.pollReminderMinutes;
      _lowBalanceController.text =
          group.lowBalanceThresholdPaisa > 0 ? (group.lowBalanceThresholdPaisa / 100).toStringAsFixed(0) : '';
      _autoMealOffBelowThreshold = group.autoMealOffBelowThreshold;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _managerNameController.dispose();
    _lowBalanceController.dispose();
    super.dispose();
  }

  bool get _nameValid =>
      _nameController.text.trim().isNotEmpty && (_isEdit || _managerNameController.text.trim().isNotEmpty);

  Future<void> _save() async {
    if (!_nameValid) return;
    setState(() => _saving = true);
    final repo = ref.read(groupsRepositoryProvider);
    if (_isEdit && _existing != null) {
      await repo.updateGroup(_existing!.copyWith(
        name: _nameController.text.trim(),
        type: _type,
        monthStartDay: _monthStartDay,
        mealEnabled: _mealEnabled,
        mealLedgerSeparate: _mealEnabled && _mealLedgerSeparate,
        defaultNonVoterPolicy: _defaultNonVoterPolicy,
        pollReminderMinutes: _pollReminderMinutes,
        lowBalanceThresholdPaisa: ((double.tryParse(_lowBalanceController.text.trim()) ?? 0) * 100).round(),
        autoMealOffBelowThreshold: _autoMealOffBelowThreshold,
      ));
      // Push the change up for an online mess — without this the local edit
      // is overwritten by the server's old value on the next foreground pull
      // (the pull upserts unconditionally), so the rename appears to revert.
      triggerBackgroundSync(ref, _existing!.id);
    } else {
      final group = await repo.createGroup(
        name: _nameController.text.trim(),
        type: _type,
        monthStartDay: _monthStartDay,
        mealEnabled: _mealEnabled,
        mealLedgerSeparate: _mealEnabled && _mealLedgerSeparate,
        managerName: _managerNameController.text.trim(),
      );
      ref.read(selectedGroupIdProvider.notifier).select(group.id);
    }
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(_isEdit ? l10n.commonEdit : l10n.groupsNewGroup),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(l10n.wizardStepName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(hintText: l10n.wizardStepNameHint),
                  ),
                  if (!_isEdit) ...[
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
                  const SizedBox(height: 20),
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
                  if (_mealEnabled) ...[
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                              foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                              child: const Icon(Icons.call_split_rounded),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.groupMealLedgerSeparate, style: const TextStyle(fontWeight: FontWeight.w700)),
                                  Text(l10n.groupMealLedgerSeparateSub, style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            Switch(value: _mealLedgerSeparate, onChanged: (v) => setState(() => _mealLedgerSeparate = v)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.how_to_vote_rounded),
                        title: Text(l10n.pollNonVoterPolicyLabel),
                        subtitle: Text(_policyLabel(l10n, _defaultNonVoterPolicy), style: const TextStyle(fontSize: 12)),
                        trailing: DropdownButton<NonVoterPolicy>(
                          value: _defaultNonVoterPolicy,
                          underline: const SizedBox.shrink(),
                          items: [
                            for (final p in NonVoterPolicy.values)
                              DropdownMenuItem(value: p, child: Text(_policyLabel(l10n, p), style: const TextStyle(fontSize: 12.5))),
                          ],
                          onChanged: (v) => setState(() => _defaultNonVoterPolicy = v ?? _defaultNonVoterPolicy),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.account_balance_wallet_outlined),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n.groupLowBalanceThreshold, style: const TextStyle(fontWeight: FontWeight.w700)),
                                      Text(l10n.groupLowBalanceThresholdSub, style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 84,
                                  child: TextField(
                                    controller: _lowBalanceController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                                    textAlign: TextAlign.end,
                                    decoration: const InputDecoration(prefixText: '৳ ', hintText: '0'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              value: _autoMealOffBelowThreshold,
                              onChanged: (v) => setState(() => _autoMealOffBelowThreshold = v),
                              title: Text(l10n.groupAutoMealOff, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                              subtitle: Text(l10n.groupAutoMealOffSub, style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.notifications_active_outlined),
                        title: Text(l10n.groupPollReminder),
                        subtitle: Text(l10n.groupPollReminderSub, style: const TextStyle(fontSize: 12)),
                        trailing: DropdownButton<int>(
                          value: _reminderChoices.contains(_pollReminderMinutes) ? _pollReminderMinutes : 30,
                          underline: const SizedBox.shrink(),
                          items: [
                            for (final m in _reminderChoices)
                              DropdownMenuItem(
                                value: m,
                                child: Text(
                                  m == 0 ? l10n.pollReminderOff : l10n.pollReminderBefore('$m'),
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ),
                          ],
                          onChanged: (v) => setState(() => _pollReminderMinutes = v ?? _pollReminderMinutes),
                        ),
                      ),
                    ),
                    if (_isEdit) ...[
                      const SizedBox(height: 12),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.restaurant_menu_rounded),
                          title: Text(l10n.mealSlotsTitle),
                          subtitle: Text(l10n.mealSlotsSub, style: const TextStyle(fontSize: 12)),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push('/groups/${widget.groupId}/meal-slots'),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_isEdit ? l10n.commonSave : l10n.wizardFinish),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _policyLabel(AppLocalizations l10n, NonVoterPolicy policy) => switch (policy) {
        NonVoterPolicy.routine => l10n.nonVoterPolicyRoutine,
        NonVoterPolicy.pending => l10n.nonVoterPolicyPending,
        NonVoterPolicy.zero => l10n.nonVoterPolicyZero,
        NonVoterPolicy.repeatYesterday => l10n.nonVoterPolicyRepeatYesterday,
      };
}
