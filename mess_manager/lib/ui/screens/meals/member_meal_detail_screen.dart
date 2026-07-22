import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../domain/engines/balance_engine.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/sync_refresh_indicator.dart';

class MemberMealDetailScreen extends ConsumerWidget {
  const MemberMealDetailScreen({super.key, required this.groupId, required this.memberId});

  final String groupId;
  final String memberId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    ref.watch(foregroundGroupSyncProvider); // live sync while this screen is open
    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final month = ref.watch(selectedMonthProvider);
    final members = ref.watch(membersOfSelectedGroupProvider).value ?? const [];
    final meals = (ref.watch(mealsOfSelectedMonthProvider).value ?? const [])
        .where((m) => m.memberId == memberId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final rate = ref.watch(mealRateProvider);

    final matching = members.where((m) => m.id == memberId);
    final name = matching.isEmpty ? '?' : matching.first.name;

    final ownTotal = meals.fold<double>(0, (a, m) => a + m.count);
    final guestTotal = meals.fold<double>(0, (a, m) => a + m.guestCount);
    final bill = rate.memberBillsPaisa[memberId] ?? 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Row(
          children: [
            CircleAvatar(radius: 17, child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: const TextStyle(fontSize: 13))),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name, style: const TextStyle(fontSize: 16)),
                  Text('${fmt.monthYear(month)} · ${l10n.mealsMemberDetail}', style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SyncRefreshIndicator(
        groupId: groupId,
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              _StatCard(label: l10n.mealsMemberTotalMeals, value: fmt.mealCount(ownTotal)),
              const SizedBox(width: 10),
              _StatCard(label: l10n.mealsMemberGuest, value: fmt.mealCount(guestTotal)),
              const SizedBox(width: 10),
              _StatCard(label: l10n.mealsMemberBill, value: fmt.currency(bill), highlight: true),
            ],
          ),
          const SizedBox(height: 10),
          // Money view: what they put in, what their meals cost, what's left.
          Builder(builder: (_) {
            final balances = ref.watch(mealLedgerBalancesProvider).value ?? const <MemberBalance>[];
            final mine = balances.where((b) => b.memberId == memberId);
            if (mine.isEmpty) return const SizedBox.shrink();
            final balance = mine.first;
            final threshold = ref.watch(selectedGroupProvider)?.lowBalanceThresholdPaisa ?? 0;
            final low = isLowBalance(remainingPaisa: balance.net, thresholdPaisa: threshold);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _StatCard(label: l10n.mealBalanceDeposited, value: fmt.currency(balance.totalDeposits)),
                    const SizedBox(width: 10),
                    _StatCard(label: l10n.mealBalanceSpent, value: fmt.currency(balance.totalShare)),
                    const SizedBox(width: 10),
                    _StatCard(label: l10n.mealBalanceRemaining, value: fmt.currency(balance.net), highlight: !low),
                  ],
                ),
                if (low) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text('${l10n.mealBalanceLow} · ${fmt.currency(threshold)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ],
            );
          }),
          const SizedBox(height: 20),
          Text(l10n.mealsDailyEntries, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (meals.isEmpty)
            Padding(padding: const EdgeInsets.all(20), child: Text(l10n.dashboardNoExpenses))
          else
            Card(
              child: Column(
                children: [
                  for (final meal in meals)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        child: Text(fmt.digits('${meal.date.day}'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                      title: Text(fmt.day(meal.date)),
                      subtitle: meal.guestCount > 0 ? Text(l10n.mealsGuestCount(fmt.mealCount(meal.guestCount))) : null,
                      trailing: Text(fmt.mealCount(meal.total), style: const TextStyle(fontFamily: moneyFontFamily, fontWeight: FontWeight.w700)),
                    ),
                ],
              ),
            ),
        ],
      ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, this.highlight = false});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: highlight ? scheme.primaryContainer.withValues(alpha: 0.4) : null,
          border: Border.all(color: highlight ? scheme.primary.withValues(alpha: 0.3) : scheme.outline),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(value, style: moneyTextStyle(fontSize: 16, color: highlight ? scheme.primary : null)),
          ],
        ),
      ),
    );
  }
}
