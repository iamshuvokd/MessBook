import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../domain/models/ledger_purpose.dart';
import '../../../domain/models/member.dart';
import '../../../domain/models/member_permission.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/sync_refresh_indicator.dart';

class MealGridScreen extends ConsumerWidget {
  const MealGridScreen({super.key, required this.groupId});

  final String groupId;

  static const _cellSize = 46.0;
  static const _rowHeight = 52.0;
  static const _nameColWidth = 104.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(groupId);
      }
    });

    ref.watch(foregroundGroupSyncProvider); // near-live: re-sync while open
    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final month = ref.watch(selectedMonthProvider);
    final members = ref.watch(membersOfSelectedGroupProvider).value ?? const <Member>[];
    final meals = ref.watch(mealsOfSelectedMonthProvider).value ?? const [];
    final rate = ref.watch(mealRateProvider);
    final ledgerSeparate = ref.watch(selectedGroupProvider)?.mealLedgerSeparate ?? false;
    final monthClosed = ledgerSeparate
        ? ref.watch(isSelectedMonthClosedByLedgerProvider(LedgerPurpose.meal))
        : ref.watch(isSelectedMonthClosedProvider);
    // A closed month is locked for editing — meals can still be viewed.
    final canManage = ref.watch(canProvider(MemberPermission.mealsManage)) && !monthClosed;

    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final days = List.generate(daysInMonth, (i) => DateTime(month.year, month.month, i + 1));

    final mealByMemberDay = <String, ({double count, double guest})>{};
    for (final meal in meals) {
      final key = '${meal.memberId}|${meal.date.day}';
      mealByMemberDay[key] = (count: meal.count, guest: meal.guestCount);
    }

    final totalMeals = meals.fold<double>(0, (a, m) => a + m.total);

    return Scaffold(
      drawer: AppDrawer(groupId: groupId),
      appBar: AppBar(
        title: Text(l10n.mealsGridTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.how_to_vote_outlined),
            tooltip: l10n.pollsTitle,
            onPressed: () => context.push('/groups/$groupId/polls'),
          ),
          IconButton(icon: const Icon(Icons.chevron_left_rounded), onPressed: () => ref.read(selectedMonthProvider.notifier).previous()),
          Center(child: Text(fmt.monthYear(month), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
          IconButton(icon: const Icon(Icons.chevron_right_rounded), onPressed: () => ref.read(selectedMonthProvider.notifier).next()),
        ],
      ),
      body: members.isEmpty
          ? EmptyState(
              icon: Icons.people_outline_rounded,
              title: l10n.membersEmpty,
              subtitle: l10n.mealsNoMembersYetSub,
              action: FilledButton(
                onPressed: () => context.push('/groups/$groupId/members'),
                child: Text(l10n.membersTitle),
              ),
            )
          : SyncRefreshIndicator(
              groupId: groupId,
              child: Column(
              children: [
                if (monthClosed)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_rounded, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(l10n.reportLockedBanner, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ),
                if (canManage)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _sameAsYesterday(context, ref, members),
                            icon: const Icon(Icons.content_copy_rounded, size: 16),
                            label: Text(l10n.mealsSameAsYesterday, style: const TextStyle(fontSize: 12.5)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showBulkFillDialog(context, ref, members),
                            icon: const Icon(Icons.grid_on_rounded, size: 16),
                            label: Text(l10n.mealsBulkFill, style: const TextStyle(fontSize: 12.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    // Always scrollable so the pull-to-refresh gesture works
                    // even when the grid is short enough to fit the screen.
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: _rowHeight, width: _nameColWidth),
                              for (final m in members)
                                InkWell(
                                  onTap: () => context.push('/groups/$groupId/meals/${m.id}'),
                                  child: Container(
                                    height: _rowHeight,
                                    width: _nameColWidth,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        CircleAvatar(radius: 13, child: Text(m.name.isNotEmpty ? m.name[0].toUpperCase() : '?', style: const TextStyle(fontSize: 11))),
                                        const SizedBox(width: 6),
                                        Expanded(child: Text(m.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600))),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      for (final d in days)
                                        SizedBox(
                                          height: _rowHeight,
                                          width: _cellSize,
                                          child: Center(
                                            child: Text(fmt.digits('${d.day}'), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                                          ),
                                        ),
                                    ],
                                  ),
                                  for (final m in members)
                                    Row(
                                      children: [
                                        for (final d in days)
                                          _MealCell(
                                            size: _cellSize,
                                            height: _rowHeight,
                                            data: mealByMemberDay['${m.id}|${d.day}'],
                                            fmt: fmt,
                                            onTap: canManage
                                                ? () => _showEditSheet(context, ref, m, d, mealByMemberDay['${m.id}|${d.day}'])
                                                : null,
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.mealsTotalMeals, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.grey)),
                          Text(fmt.number(totalMeals, decimals: totalMeals % 1 == 0 ? 0 : 1), style: moneyTextStyle(fontSize: 20)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(l10n.mealsRateLive, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary)),
                          Text(fmt.currency(rate.mealRatePaisaX100 ~/ 100), style: moneyTextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              ),
            ),
      bottomNavigationBar: AppBottomNav(groupId: groupId, current: AppTab.meals),
    );
  }

  Future<void> _sameAsYesterday(BuildContext context, WidgetRef ref, List<Member> members) async {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    await ref.read(mealsRepositoryProvider).copyDay(
          groupId: groupId,
          fromDay: yesterday,
          toDay: today,
          memberIds: members.map((m) => m.id).toList(),
        );
    triggerBackgroundSync(ref, groupId);
  }

  Future<void> _showBulkFillDialog(BuildContext context, WidgetRef ref, List<Member> members) async {
    final l10n = AppLocalizations.of(context);
    var count = 2.0;
    final result = await showDialog<double>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
          title: Text(l10n.mealsBulkFillTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.mealsBulkFillHint, style: const TextStyle(fontSize: 12.5)),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.outlined(icon: const Icon(Icons.remove_rounded), onPressed: count > 0 ? () => setState(() => count -= 1) : null),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                  IconButton.outlined(icon: const Icon(Icons.add_rounded), onPressed: () => setState(() => count += 1)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l10n.commonCancel)),
            FilledButton(onPressed: () => Navigator.of(dialogContext).pop(count), child: Text(l10n.commonSave)),
          ],
        ),
      ),
    );
    if (result == null) return;
    await ref.read(mealsRepositoryProvider).bulkFill(
          groupId: groupId,
          day: DateTime.now(),
          memberIds: members.map((m) => m.id).toList(),
          count: result,
        );
    triggerBackgroundSync(ref, groupId);
  }

  Future<void> _showEditSheet(
    BuildContext context,
    WidgetRef ref,
    Member member,
    DateTime day,
    ({double count, double guest})? existing,
  ) async {
    final l10n = AppLocalizations.of(context);
    var count = existing?.count ?? 0.0;
    var guest = existing?.guest ?? 0.0;

    await showModalBottomSheet(
      context: context,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${member.name} · ${l10n.mealsSetTitle}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 18),
              _Stepper(
                label: l10n.mealsCountLabel,
                value: count,
                onChanged: (v) => setState(() => count = v),
              ),
              const SizedBox(height: 12),
              _Stepper(
                label: l10n.mealsGuestLabel,
                value: guest,
                onChanged: (v) => setState(() => guest = v),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () async {
                  await ref.read(mealsRepositoryProvider).setMeal(
                        groupId: groupId,
                        memberId: member.id,
                        date: day,
                        count: count,
                        guestCount: guest,
                      );
                  triggerBackgroundSync(ref, groupId);
                  if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                },
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: Text(l10n.commonSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.label, required this.value, required this.onChanged});

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        IconButton.outlined(icon: const Icon(Icons.remove_rounded), onPressed: value > 0 ? () => onChanged(value - 0.5) : null),
        SizedBox(width: 44, child: Center(child: Text(value.toStringAsFixed(value % 1 == 0 ? 0 : 1), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)))),
        IconButton.outlined(icon: const Icon(Icons.add_rounded), onPressed: () => onChanged(value + 0.5)),
      ],
    );
  }
}

class _MealCell extends StatelessWidget {
  const _MealCell({required this.size, required this.height, required this.data, required this.fmt, required this.onTap});

  final double size;
  final double height;
  final ({double count, double guest})? data;
  final BdFormatter fmt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasData = data != null && (data!.count > 0 || data!.guest > 0);
    final label = hasData ? fmt.digits(data!.count.toStringAsFixed(data!.count % 1 == 0 ? 0 : 1)) : '·';

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: hasData ? FontWeight.w700 : FontWeight.w400,
                  color: hasData ? scheme.onSurface : scheme.outline,
                ),
              ),
              if (data != null && data!.guest > 0)
                Icon(Icons.person_add_alt_1_rounded, size: 10, color: scheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
