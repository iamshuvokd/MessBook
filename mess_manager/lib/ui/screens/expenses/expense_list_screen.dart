import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/category_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../core/utils/icon_lookup.dart';
import '../../../domain/models/expense.dart';
import '../../../domain/models/member_permission.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/sync_refresh_indicator.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  String _query = '';
  String? _categoryFilter;
  bool _searching = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != widget.groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(widget.groupId);
      }
    });
    ref.watch(foregroundGroupSyncProvider); // near-live: re-sync while open
    final expenses = ref.watch(expensesOfSelectedGroupProvider);
    final categories = ref.watch(categoriesForSelectedGroupProvider);
    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final canManage = ref.watch(canProvider(MemberPermission.expensesManage));

    return Scaffold(
      drawer: AppDrawer(groupId: widget.groupId),
      appBar: AppBar(
        title: _searching
            ? TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(hintText: l10n.commonSearch, border: InputBorder.none),
              )
            : Text(l10n.expensesTitle),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close_rounded : Icons.search_rounded),
            onPressed: () => setState(() {
              _searching = !_searching;
              if (!_searching) _query = '';
            }),
          ),
        ],
      ),
      body: SyncRefreshIndicator(
        groupId: widget.groupId,
        child: expenses.when(
        data: (rows) {
          var filtered = rows;
          if (_categoryFilter != null) {
            filtered = filtered.where((e) => e.expense.categoryId == _categoryFilter).toList();
          }
          if (_query.trim().isNotEmpty) {
            final q = _query.trim().toLowerCase();
            filtered = filtered
                .where((e) =>
                    (e.expense.note ?? '').toLowerCase().contains(q) ||
                    resolveCategoryName(l10n, e.categoryDefaultKey, e.categoryRawName).toLowerCase().contains(q))
                .toList();
          }

          final groups = _groupByDay(filtered);

          return Column(
            children: [
              categories.when(
                data: (cats) => SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(l10n.expensesFilterAll),
                          selected: _categoryFilter == null,
                          onSelected: (_) => setState(() => _categoryFilter = null),
                        ),
                      ),
                      for (final c in cats)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            avatar: Icon(lookupIcon(c.icon), size: 16),
                            label: Text(resolveCategoryName(l10n, c.defaultKey, c.name)),
                            selected: _categoryFilter == c.id,
                            onSelected: (_) => setState(() => _categoryFilter = c.id),
                          ),
                        ),
                    ],
                  ),
                ),
                loading: () => const SizedBox(height: 44),
                error: (_, _) => const SizedBox(height: 44),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(icon: Icons.receipt_long_rounded, title: l10n.expensesEmpty)
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                        children: [
                          for (final entry in groups.entries) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                '${_dayLabel(entry.key, fmt, l10n)} · ${fmt.currency(entry.value.fold<int>(0, (a, e) => a + e.expense.amountPaisa))}',
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                              ),
                            ),
                            Card(
                              child: Column(
                                children: [
                                  for (final e in entry.value)
                                    _ExpenseRow(detail: e, l10n: l10n, fmt: fmt, groupId: widget.groupId, canManage: canManage),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.commonErrorPrefix(e.toString()))),
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton(
              onPressed: () => context.push('/groups/${widget.groupId}/expenses/new'),
              child: const Icon(Icons.add_rounded),
            )
          : null,
      bottomNavigationBar: AppBottomNav(groupId: widget.groupId, current: AppTab.expenses),
    );
  }

  Map<DateTime, List<ExpenseDetail>> _groupByDay(List<ExpenseDetail> rows) {
    final map = <DateTime, List<ExpenseDetail>>{};
    for (final r in rows) {
      final day = DateTime(r.expense.date.year, r.expense.date.month, r.expense.date.day);
      (map[day] ??= []).add(r);
    }
    final sortedKeys = map.keys.toList()..sort((a, b) => b.compareTo(a));
    return {for (final k in sortedKeys) k: map[k]!};
  }

  String _dayLabel(DateTime day, BdFormatter fmt, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (day == today) return l10n.expensesToday;
    return fmt.day(day);
  }
}

class _ExpenseRow extends ConsumerWidget {
  const _ExpenseRow({required this.detail, required this.l10n, required this.fmt, required this.groupId, required this.canManage});

  final ExpenseDetail detail;
  final AppLocalizations l10n;
  final BdFormatter fmt;
  final String groupId;
  final bool canManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final payerLabel = detail.payers.isEmpty
        // No payer = spent from the collected deposits, not fronted by anyone.
        ? l10n.expensesPaidFromFund
        : detail.payers.length == 1
            ? l10n.expensesPaid
            : l10n.expensesPayersCount(detail.payers.length);

    return Dismissible(
      key: ValueKey(detail.expense.id),
      direction: canManage ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: scheme.error,
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n.commonDelete),
          content: Text(l10n.expensesDeleteConfirm),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.commonDelete)),
          ],
        ),
      ),
      onDismissed: (_) {
        ref.read(expensesRepositoryProvider).deleteExpense(detail.expense.id, groupId: groupId);
        triggerBackgroundSync(ref, groupId);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: Icon(lookupIcon(detail.categoryIcon)),
        ),
        title: Text(resolveCategoryName(l10n, detail.categoryDefaultKey, detail.categoryRawName), style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          [if (detail.expense.note != null && detail.expense.note!.isNotEmpty) detail.expense.note!, payerLabel].join(' · '),
          style: const TextStyle(fontSize: 12.5),
        ),
        trailing: Text(fmt.currency(detail.expense.amountPaisa), style: const TextStyle(fontFamily: moneyFontFamily, fontWeight: FontWeight.w700)),
        onTap: canManage ? () => context.push('/groups/$groupId/expenses/${detail.expense.id}/edit') : null,
      ),
    );
  }
}
