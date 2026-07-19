import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/category_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../core/utils/icon_lookup.dart';
import '../../../domain/models/ledger_purpose.dart';
import '../../../domain/models/member.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_drawer.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(groupId);
      }
    });
    ref.watch(appOpenTasksProvider);
    ref.watch(foregroundGroupSyncProvider); // near-live: re-sync while open

    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final groups = ref.watch(activeGroupsProvider);
    final matchingGroups = (groups.value ?? const []).where((g) => g.id == groupId);
    final group = matchingGroups.isEmpty ? null : matchingGroups.first;
    final expenses = ref.watch(expensesOfSelectedGroupProvider);
    final balances = ref.watch(memberBalancesProvider);
    final members = ref.watch(membersOfSelectedGroupProvider);
    final lastBackup = ref.watch(lastBackupAtProvider).value;

    final totalSpent = expenses.value?.fold<int>(0, (a, e) => a + e.expense.amountPaisa) ?? 0;
    final backupOverdue = lastBackup == null || DateTime.now().difference(lastBackup).inDays > 7;

    // Month-scoped mess overview + the acting member's personal numbers —
    // the two things a mess member actually opens the app to check.
    final month = ref.watch(selectedMonthProvider);
    final monthDeposits = (ref.watch(depositsOfSelectedGroupProvider).value ?? const [])
        .where((d) => d.date.year == month.year && d.date.month == month.month)
        .toList();
    final monthDepositsPaisa = monthDeposits.fold<int>(0, (a, d) => a + d.amountPaisa);
    final monthMeals = ref.watch(mealsOfSelectedMonthProvider).value ?? const [];
    final monthMealCount = monthMeals.fold<double>(0, (a, m) => a + m.total);
    final mealRate = ref.watch(mealRateProvider);
    final mealRatePaisa = (mealRate.mealRatePaisaX100 / 100).round();
    final actingAs = ref.watch(actingAsMemberProvider);
    final mealEnabled = group?.mealEnabled ?? false;
    final nextBazar = ref.watch(nextBazarDutyProvider);
    final nextBazarName = nextBazar == null
        ? ''
        : (() {
            final list = members.value ?? const <Member>[];
            final m = list.where((e) => e.id == nextBazar.memberId);
            return m.isEmpty ? '?' : m.first.name;
          })();

    return Scaffold(
      drawer: AppDrawer(groupId: groupId),
      appBar: AppBar(
        title: Text(group?.name ?? l10n.groupsTitle),
        actions: [
          if (group?.isOnline ?? false)
            IconButton(
              icon: const Icon(Icons.chat_bubble_rounded),
              tooltip: l10n.chatTitle,
              onPressed: () => context.push('/groups/$groupId/chat'),
            ),
          IconButton(
            icon: const Icon(Icons.group_rounded),
            tooltip: l10n.membersTitle,
            onPressed: () => context.push('/groups/$groupId/members'),
          ),
          IconButton(
            icon: const Icon(Icons.cloud_upload_rounded),
            tooltip: l10n.backupTitle,
            onPressed: () => context.push('/backup'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (group?.isOnline ?? false) {
            try {
              await ref.read(syncServiceProvider).syncGroup(groupId);
            } catch (_) {
              // Best-effort — offline or server-down just means nothing new
              // came down; the refresh gesture still completes normally.
            }
          }
          ref.invalidate(expensesOfSelectedGroupProvider);
          ref.invalidate(memberBalancesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(AppRadius.xxl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.dashboardTotalSpent, style: const TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    fmt.currency(totalSpent),
                    style: moneyTextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  if (group?.mealLedgerSeparate ?? false) ...[
                    _LedgerChipRow(label: l10n.ledgerMealTab, ledger: LedgerPurpose.meal, members: members.value ?? const [], fmt: fmt),
                    const SizedBox(height: 8),
                    _LedgerChipRow(label: l10n.ledgerGeneralTab, ledger: LedgerPurpose.general, members: members.value ?? const [], fmt: fmt),
                  ] else
                    balances.when(
                      data: (rows) => rows.isEmpty
                          ? const SizedBox.shrink()
                          : SizedBox(
                              height: 40,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (final b in rows)
                                    _NetChip(memberId: b.memberId, netPaisa: b.net, members: members.value ?? const [], fmt: fmt),
                                ],
                              ),
                            ),
                      loading: () => const SizedBox(height: 40),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.add_card_rounded,
                    label: l10n.dashboardQuickAddExpense,
                    onTap: () => context.push('/groups/$groupId/expenses/new'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.handshake_rounded,
                    label: l10n.dashboardQuickSettleUp,
                    onTap: () => context.push('/groups/$groupId/settle-up'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.savings_rounded,
                    label: l10n.depositsTitle,
                    onTap: () => context.push('/groups/$groupId/deposits'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${l10n.dashboardMonthOverview} · ${fmt.monthYear(month)}',
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _MiniStat(label: l10n.depositsTitle, value: fmt.currency(monthDepositsPaisa)),
                        if (mealEnabled) ...[
                          const SizedBox(width: 8),
                          _MiniStat(
                            label: l10n.mealsMemberTotalMeals,
                            value: fmt.number(monthMealCount, decimals: monthMealCount % 1 == 0 ? 0 : 1),
                          ),
                          const SizedBox(width: 8),
                          _MiniStat(label: l10n.reportMealRate, value: fmt.currency(mealRatePaisa)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (actingAs != null) ...[
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            child: Text(actingAs.name.isNotEmpty ? actingAs.name[0].toUpperCase() : '?',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(l10n.dashboardMyAccount,
                                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (mealEnabled) ...[
                            _MiniStat(
                              label: l10n.dashboardMyMeals,
                              value: () {
                                final mine = monthMeals
                                    .where((m) => m.memberId == actingAs.id)
                                    .fold<double>(0, (a, m) => a + m.total);
                                return fmt.number(mine, decimals: mine % 1 == 0 ? 0 : 1);
                              }(),
                            ),
                            const SizedBox(width: 8),
                            _MiniStat(
                              label: l10n.dashboardMyMealBill,
                              value: fmt.currency(mealRate.memberBillsPaisa[actingAs.id] ?? 0),
                            ),
                            const SizedBox(width: 8),
                          ],
                          _MiniStat(
                            label: l10n.dashboardMyDeposit,
                            value: fmt.currency(monthDeposits
                                .where((d) => d.memberId == actingAs.id)
                                .fold<int>(0, (a, d) => a + d.amountPaisa)),
                          ),
                          const SizedBox(width: 8),
                          _MiniStat(
                            label: l10n.dashboardMyBalance,
                            value: fmt.currency(
                              (balances.value ?? const []).where((b) => b.memberId == actingAs.id).firstOrNull?.net ?? 0,
                            ),
                            highlight: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (group?.mealEnabled ?? false) ...[
              const SizedBox(height: 14),
              const _TodaysPollCard(),
              if (nextBazar != null) ...[
                const SizedBox(height: 14),
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                      child: const Icon(Icons.shopping_basket_rounded),
                    ),
                    title: Text(l10n.dashboardNextBazar, style: const TextStyle(fontSize: 12.5, color: Colors.grey)),
                    subtitle: Text(
                      '$nextBazarName · ${fmt.day(nextBazar.date)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/groups/$groupId/bazar'),
                  ),
                ),
              ],
            ],
            if (backupOverdue) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.honey100.withValues(alpha: 0.5),
                  border: Border.all(color: AppColors.honey300),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cloud_off_rounded, color: AppColors.honey700, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.backupOverdueTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          Text(l10n.backupOverdueBody, style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/backup'),
                      child: Text(l10n.backupOverdueAction),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l10n.dashboardRecentExpenses, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
                  ),
                  TextButton(
                    onPressed: () => context.push('/groups/$groupId/expenses'),
                    child: Text(l10n.dashboardSeeAll),
                  ),
                ],
              ),
            ),
            expenses.when(
              data: (rows) {
                final recent = rows.take(5).toList();
                if (recent.isEmpty) {
                  return Padding(padding: const EdgeInsets.all(20), child: Text(l10n.dashboardNoExpenses));
                }
                return Card(
                  child: Column(
                    children: [
                      for (final e in recent)
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                            child: Icon(lookupIcon(e.categoryIcon)),
                          ),
                          title: Text(resolveCategoryName(l10n, e.categoryDefaultKey, e.categoryRawName)),
                          subtitle: Text(fmt.day(e.expense.date)),
                          trailing: Text(fmt.currency(e.expense.amountPaisa), style: const TextStyle(fontFamily: moneyFontFamily, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                );
              },
              loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
              error: (e, _) => Text(l10n.commonErrorPrefix(e.toString())),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(groupId: groupId, current: AppTab.home),
    );
  }
}

class _TodaysPollCard extends ConsumerWidget {
  const _TodaysPollCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final poll = ref.watch(todaysOpenPollProvider);
    if (poll == null) return const SizedBox.shrink();

    final groupId = poll.groupId;
    final votes = ref.watch(pollVotesProvider(poll.id)).value ?? const [];
    final members = ref.watch(membersOfSelectedGroupProvider).value ?? const [];

    return Card(
      color: AppColors.honey100.withValues(alpha: 0.5),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: () => context.push('/groups/$groupId/polls/${poll.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.how_to_vote_rounded, color: AppColors.honey700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.dashboardTodaysPoll, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(
                      poll.title?.isNotEmpty == true ? poll.title! : l10n.pollVotedCount('${votes.length}', '${members.length}'),
                      style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.push('/groups/$groupId/polls/${poll.id}'),
                child: Text(l10n.pollVoteNow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, this.highlight = false});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: highlight ? scheme.primaryContainer.withValues(alpha: 0.4) : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: moneyTextStyle(fontSize: 14.5, color: highlight ? scheme.primary : null)),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 6),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

/// One labeled row of per-member net chips for a single ledger (used on the
/// hero card when the group keeps meal money separate).
class _LedgerChipRow extends ConsumerWidget {
  const _LedgerChipRow({required this.label, required this.ledger, required this.members, required this.fmt});

  final String label;
  final LedgerPurpose ledger;
  final List<Member> members;
  final BdFormatter fmt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balances = ref.watch(memberBalancesByLedgerProvider(ledger));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
        const SizedBox(height: 4),
        balances.when(
          data: (rows) => rows.isEmpty
              ? const SizedBox(height: 36)
              : SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final b in rows) _NetChip(memberId: b.memberId, netPaisa: b.net, members: members, fmt: fmt),
                    ],
                  ),
                ),
          loading: () => const SizedBox(height: 36),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _NetChip extends StatelessWidget {
  const _NetChip({required this.memberId, required this.netPaisa, required this.members, required this.fmt});

  final String memberId;
  final int netPaisa;
  final List<Member> members;
  final BdFormatter fmt;

  @override
  Widget build(BuildContext context) {
    final matching = members.where((m) => m.id == memberId);
    final name = matching.isEmpty ? '?' : matching.first.name;
    final positive = netPaisa >= 0;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.teal200,
            foregroundColor: AppColors.teal900,
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 6),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          Text(
            '${positive ? '+' : '−'}${fmt.currency(netPaisa.abs())}',
            style: TextStyle(
              color: positive ? Colors.white : const Color(0xFFFFB4A8),
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              fontFamily: moneyFontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
