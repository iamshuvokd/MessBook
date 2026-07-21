import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../domain/models/meal_poll.dart';
import '../../../domain/models/member_permission.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/sync_refresh_indicator.dart';
import 'create_poll_sheet.dart';

class PollsListScreen extends ConsumerWidget {
  const PollsListScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(groupId);
      }
    });

    ref.watch(foregroundGroupSyncProvider); // near-live: re-sync while open
    ref.watch(autoCloseDuePollsProvider); // close polls the moment their time passes
    final polls = ref.watch(pollsOfSelectedGroupProvider);
    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final canCreate = ref.watch(canProvider(MemberPermission.pollsCreate)) || ref.watch(canProvider(MemberPermission.pollsManage));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(l10n.pollsTitle),
      ),
      body: SyncRefreshIndicator(
        groupId: groupId,
        child: polls.when(
        data: (rows) => rows.isEmpty
            ? EmptyState(icon: Icons.how_to_vote_rounded, title: l10n.pollsEmpty)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rows.length,
                itemBuilder: (context, i) => _PollTile(poll: rows[i], l10n: l10n, fmt: fmt, groupId: groupId),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.commonErrorPrefix(e.toString()))),
        ),
      ),
      floatingActionButton: canCreate
          ? FloatingActionButton.extended(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => CreatePollSheet(groupId: groupId),
              ),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.pollCreate),
            )
          : null,
    );
  }
}

class _PollTile extends ConsumerWidget {
  const _PollTile({required this.poll, required this.l10n, required this.fmt, required this.groupId});

  final MealPoll poll;
  final AppLocalizations l10n;
  final BdFormatter fmt;
  final String groupId;

  String _typeLabel() => switch (poll.type) {
        PollType.slots => l10n.pollTypeSlots,
        PollType.count => l10n.pollTypeCount,
        PollType.menu => l10n.pollTypeMenu,
      };

  IconData _typeIcon() => switch (poll.type) {
        PollType.slots => Icons.restaurant_rounded,
        PollType.count => Icons.pin_rounded,
        PollType.menu => Icons.restaurant_menu_rounded,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersOfSelectedGroupProvider).value ?? const [];
    final votes = ref.watch(pollVotesProvider(poll.id)).value ?? const [];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          child: Icon(_typeIcon()),
        ),
        title: Text(poll.title?.isNotEmpty == true ? poll.title! : _typeLabel(), style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          // Members need to see WHEN an open poll closes, not just its date.
          poll.closed
              ? '${fmt.day(poll.date)} · ${l10n.pollVotedCount(fmt.number(votes.length), fmt.number(members.length))}'
              : '${fmt.day(poll.date)} · ${l10n.pollCloseAt} ${fmt.time(poll.closeAt)} · ${l10n.pollVotedCount(fmt.number(votes.length), fmt.number(members.length))}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Chip(
          label: Text(poll.closed ? l10n.pollClosed : l10n.pollOpen, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
          backgroundColor: poll.closed ? null : AppColors.teal600.withValues(alpha: 0.15),
          visualDensity: VisualDensity.compact,
        ),
        onTap: () => context.push('/groups/$groupId/polls/${poll.id}'),
      ),
    );
  }
}
