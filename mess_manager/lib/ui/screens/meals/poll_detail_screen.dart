import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../domain/models/meal_poll.dart';
import '../../../domain/models/meal_slot.dart';
import '../../../domain/models/member.dart';
import '../../../domain/models/member_permission.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/sync_refresh_indicator.dart';
import 'create_poll_sheet.dart';
import 'meal_slots_screen.dart' show resolveSlotName;

class PollDetailScreen extends ConsumerWidget {
  const PollDetailScreen({super.key, required this.groupId, required this.pollId});

  final String groupId;
  final String pollId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(groupId);
      }
    });

    final poll = ref.watch(pollsRepositoryProvider).watchPoll(pollId);
    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final members = ref.watch(membersOfSelectedGroupProvider).value ?? const [];
    final slots = ref.watch(activeSlotsOfSelectedGroupProvider).value ?? const [];
    final votes = ref.watch(pollVotesProvider(pollId)).value ?? const [];
    final canManage = ref.watch(canProvider(MemberPermission.pollsManage));
    final canEdit = canManage || ref.watch(canProvider(MemberPermission.pollsCreate));
    final pending = ref.watch(pollPendingMembersProvider(pollId)).value ?? const [];

    // Read the poll from the group list too, so the AppBar (built outside the
    // StreamBuilder below) can show the edit action only for an open poll.
    final pollForAppBar =
        (ref.watch(pollsOfSelectedGroupProvider).value ?? const []).where((p) => p.id == pollId).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(l10n.pollsTitle),
        actions: [
          // Editable only while the poll is still open — a closed poll has
          // already applied its results to the meal grid.
          if (canEdit && pollForAppBar != null && !pollForAppBar.closed)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: l10n.commonEdit,
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => CreatePollSheet(groupId: groupId, existing: pollForAppBar),
              ),
            ),
        ],
      ),
      body: SyncRefreshIndicator(
        groupId: groupId,
        child: StreamBuilder<MealPoll?>(
        stream: poll,
        builder: (context, snapshot) {
          final p = snapshot.data;
          if (p == null) return const Center(child: CircularProgressIndicator());

          final votesByMember = {for (final v in votes) v.memberId: v};
          final createdBy = members.where((m) => m.id == p.createdByMemberId);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(gradient: AppColors.heroGradient, borderRadius: BorderRadius.circular(AppRadius.xxl)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            p.title?.isNotEmpty == true ? p.title! : _typeQuestion(l10n, p.type),
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Chip(
                          label: Text(p.closed ? l10n.pollClosed : l10n.pollOpen, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${l10n.pollCloseAt}: ${fmt.day(p.closeAt)}  ·  ${l10n.pollVotedCount(fmt.number(votes.length), fmt.number(members.length))}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    if (createdBy.isNotEmpty)
                      Text(l10n.pollCreatedBy(createdBy.first.name), style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    for (final member in members)
                      _MemberVoteTile(
                        member: member,
                        poll: p,
                        vote: votesByMember[member.id],
                        slots: slots,
                        l10n: l10n,
                      ),
                  ],
                ),
              ),
              if (p.closed && canManage && pending.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(l10n.pollPendingTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      for (final id in pending)
                        _PendingMemberTile(
                          member: members.where((m) => m.id == id).firstOrNull,
                          groupId: groupId,
                          date: p.date,
                          l10n: l10n,
                        ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
      ),
    );
  }

  String _typeQuestion(AppLocalizations l10n, PollType type) => switch (type) {
        PollType.slots => l10n.pollVoteSlotsQuestion,
        PollType.count => l10n.pollVoteCountQuestion,
        PollType.menu => l10n.pollVoteMenuQuestion,
      };
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _MemberVoteTile extends ConsumerWidget {
  const _MemberVoteTile({required this.member, required this.poll, required this.vote, required this.slots, required this.l10n});

  final Member member;
  final MealPoll poll;
  final PollVote? vote;
  final List<MealSlot> slots;
  final AppLocalizations l10n;

  String _summary() {
    if (vote == null) return '—';
    switch (poll.type) {
      case PollType.slots:
        if (vote!.slotIds.isEmpty) return '—';
        return vote!.slotIds
            .map((id) {
              final matching = slots.where((s) => s.id == id);
              return matching.isEmpty ? '' : resolveSlotName(l10n, matching.first.defaultKey, matching.first.name);
            })
            .where((s) => s.isNotEmpty)
            .join(', ');
      case PollType.count:
        return vote!.count?.toStringAsFixed(vote!.count! % 1 == 0 ? 0 : 1) ?? '—';
      case PollType.menu:
        final idx = vote!.optionIndex;
        if (idx == null || idx < 0 || idx >= poll.options.length) return '—';
        return poll.options[idx];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voted = vote != null;
    return ListTile(
      leading: CircleAvatar(child: Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?')),
      title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: voted ? Text(_summary(), style: const TextStyle(fontSize: 12)) : null,
      trailing: voted
          ? const Icon(Icons.check_circle_rounded, color: AppColors.teal600)
          : poll.closed
              ? const Icon(Icons.remove_circle_outline_rounded, color: Colors.grey)
              : const Icon(Icons.chevron_right_rounded),
      onTap: poll.closed ? null : () => _showVoteSheet(context, ref),
    );
  }

  Future<void> _showVoteSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CastVoteSheet(member: member, poll: poll, existing: vote, slots: slots),
    );
  }
}

class _CastVoteSheet extends ConsumerStatefulWidget {
  const _CastVoteSheet({required this.member, required this.poll, this.existing, required this.slots});

  final Member member;
  final MealPoll poll;
  final PollVote? existing;
  final List<MealSlot> slots;

  @override
  ConsumerState<_CastVoteSheet> createState() => _CastVoteSheetState();
}

class _CastVoteSheetState extends ConsumerState<_CastVoteSheet> {
  final Set<String> _selectedSlotIds = {};
  late double _count = widget.existing?.count ?? 1;
  late int? _optionIndex = widget.existing?.optionIndex;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedSlotIds.addAll(widget.existing?.slotIds ?? const []);
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    final value = switch (widget.poll.type) {
      PollType.slots => PollVote(pollId: widget.poll.id, memberId: widget.member.id, slotIds: _selectedSlotIds.toList(), votedAt: DateTime.now()),
      PollType.count => PollVote(pollId: widget.poll.id, memberId: widget.member.id, count: _count, votedAt: DateTime.now()),
      PollType.menu => PollVote(pollId: widget.poll.id, memberId: widget.member.id, optionIndex: _optionIndex, votedAt: DateTime.now()),
    };
    await ref.read(pollsRepositoryProvider).castVote(pollId: widget.poll.id, memberId: widget.member.id, value: value);
    triggerBackgroundSync(ref, widget.poll.groupId);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.member.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            switch (widget.poll.type) {
              PollType.slots => l10n.pollVoteSlotsQuestion,
              PollType.count => l10n.pollVoteCountQuestion,
              PollType.menu => l10n.pollVoteMenuQuestion,
            },
            style: const TextStyle(fontSize: 12.5, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (widget.poll.type == PollType.slots)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final slot in widget.slots)
                  FilterChip(
                    label: Text(resolveSlotName(l10n, slot.defaultKey, slot.name)),
                    selected: _selectedSlotIds.contains(slot.id),
                    onSelected: (v) => setState(() {
                      if (v) {
                        _selectedSlotIds.add(slot.id);
                      } else {
                        _selectedSlotIds.remove(slot.id);
                      }
                    }),
                  ),
              ],
            )
          else if (widget.poll.type == PollType.count)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.outlined(icon: const Icon(Icons.remove_rounded), onPressed: _count > 0 ? () => setState(() => _count -= 0.5) : null),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(_count.toStringAsFixed(_count % 1 == 0 ? 0 : 1), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                IconButton.outlined(icon: const Icon(Icons.add_rounded), onPressed: () => setState(() => _count += 0.5)),
              ],
            )
          else
            Column(
              children: [
                for (var i = 0; i < widget.poll.options.length; i++)
                  ListTile(
                    leading: Icon(
                      _optionIndex == i ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                      color: _optionIndex == i ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                    ),
                    onTap: () => setState(() => _optionIndex = i),
                    title: Text(widget.poll.options[i]),
                  ),
              ],
            ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _saving ? null : _submit,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.pollVoteSubmit),
          ),
        ],
      ),
    );
  }
}

class _PendingMemberTile extends ConsumerStatefulWidget {
  const _PendingMemberTile({required this.member, required this.groupId, required this.date, required this.l10n});

  final Member? member;
  final String groupId;
  final DateTime date;
  final AppLocalizations l10n;

  @override
  ConsumerState<_PendingMemberTile> createState() => _PendingMemberTileState();
}

class _PendingMemberTileState extends ConsumerState<_PendingMemberTile> {
  double _count = 1;

  @override
  Widget build(BuildContext context) {
    final member = widget.member;
    if (member == null) return const SizedBox.shrink();
    return ListTile(
      leading: const Icon(Icons.warning_amber_rounded, color: AppColors.coral600),
      title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.outlined(icon: const Icon(Icons.remove_rounded, size: 16), onPressed: _count > 0 ? () => setState(() => _count -= 0.5) : null),
          SizedBox(width: 30, child: Center(child: Text(_count.toStringAsFixed(_count % 1 == 0 ? 0 : 1)))),
          IconButton.outlined(icon: const Icon(Icons.add_rounded, size: 16), onPressed: () => setState(() => _count += 0.5)),
          const SizedBox(width: 6),
          FilledButton(
            onPressed: () {
              ref.read(mealsRepositoryProvider).setMeal(
                    groupId: widget.groupId,
                    memberId: member.id,
                    date: widget.date,
                    count: _count,
                    guestCount: 0,
                  );
              triggerBackgroundSync(ref, widget.groupId);
            },
            style: FilledButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            child: Text(widget.l10n.pollResolveSet, style: const TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
