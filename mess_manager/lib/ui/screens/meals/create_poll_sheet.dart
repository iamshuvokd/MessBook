import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../domain/models/meal_poll.dart';
import '../../../domain/models/non_voter_policy.dart';
import '../../providers/repository_providers.dart';

class CreatePollSheet extends ConsumerStatefulWidget {
  const CreatePollSheet({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<CreatePollSheet> createState() => _CreatePollSheetState();
}

class _CreatePollSheetState extends ConsumerState<CreatePollSheet> {
  PollType _type = PollType.slots;
  final _titleController = TextEditingController();
  final _optionsController = TextEditingController();
  TimeOfDay _closeTime = const TimeOfDay(hour: 21, minute: 0);
  NonVoterPolicy? _policyOverride; // null = use mess default
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _optionsController.dispose();
    super.dispose();
  }

  String _policyLabel(AppLocalizations l10n, NonVoterPolicy? policy) => switch (policy) {
        null => l10n.pollNonVoterUseDefault,
        NonVoterPolicy.routine => l10n.nonVoterPolicyRoutine,
        NonVoterPolicy.pending => l10n.nonVoterPolicyPending,
        NonVoterPolicy.zero => l10n.nonVoterPolicyZero,
        NonVoterPolicy.repeatYesterday => l10n.nonVoterPolicyRepeatYesterday,
      };

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_type == PollType.menu && _titleController.text.trim().isEmpty) return;

    setState(() => _saving = true);
    final now = DateTime.now();
    var closeAt = DateTime(now.year, now.month, now.day, _closeTime.hour, _closeTime.minute);
    if (closeAt.isBefore(now)) closeAt = closeAt.add(const Duration(days: 1));

    final options = _type == PollType.menu
        ? _optionsController.text.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
        : const <String>[];

    final actingAs = ref.read(actingAsMemberProvider);
    final members = ref.read(membersOfSelectedGroupProvider).value ?? const [];
    final createdBy = actingAs?.id ?? (members.isNotEmpty ? members.first.id : '');

    final pollId = await ref.read(pollsRepositoryProvider).createPoll(
          groupId: widget.groupId,
          date: now,
          type: _type,
          title: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
          options: options,
          closeAt: closeAt,
          createdByMemberId: createdBy,
          nonVoterPolicy: _policyOverride,
        );

    final remindAt = closeAt.subtract(const Duration(minutes: 30));
    if (remindAt.isAfter(now)) {
      await ref.read(notificationServiceProvider).schedulePollCloseReminder(
            pollId: pollId,
            remindAt: remindAt,
            title: l10n.notifyPollReminderTitle,
            body: l10n.notifyPollReminderBody,
          );
    }

    triggerBackgroundSync(ref, widget.groupId);
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
            Text(l10n.pollCreate, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            SegmentedButton<PollType>(
              segments: [
                ButtonSegment(value: PollType.slots, label: Text(l10n.pollTypeSlots)),
                ButtonSegment(value: PollType.count, label: Text(l10n.pollTypeCount)),
                ButtonSegment(value: PollType.menu, label: Text(l10n.pollTypeMenu)),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: l10n.pollQuestionHint),
            ),
            if (_type == PollType.menu) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _optionsController,
                maxLines: 3,
                decoration: InputDecoration(labelText: l10n.pollOptionsHint),
              ),
            ],
            const SizedBox(height: 14),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.timer_outlined),
              title: Text(l10n.pollCloseAt),
              trailing: TextButton(
                onPressed: () async {
                  final picked = await showTimePicker(context: context, initialTime: _closeTime);
                  if (picked != null) setState(() => _closeTime = picked);
                },
                child: Text(_closeTime.format(context)),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.how_to_vote_outlined),
              title: Text(l10n.pollNonVoterOverride),
              trailing: DropdownButton<NonVoterPolicy?>(
                value: _policyOverride,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(value: null, child: Text(_policyLabel(l10n, null), style: const TextStyle(fontSize: 12.5))),
                  for (final p in NonVoterPolicy.values)
                    DropdownMenuItem(value: p, child: Text(_policyLabel(l10n, p), style: const TextStyle(fontSize: 12.5))),
                ],
                onChanged: (v) => setState(() => _policyOverride = v),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.pollCreate),
            ),
          ],
        ),
      ),
    );
  }
}
