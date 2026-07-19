import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/category_l10n.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../domain/models/member.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/sync_refresh_indicator.dart';

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(groupId);
      }
    });

    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final rules = ref.watch(recurringRulesOfSelectedGroupProvider);
    final categories = ref.watch(categoriesForSelectedGroupProvider).value ?? const [];
    final members = ref.watch(membersOfSelectedGroupProvider).value ?? const [];
    final premium = ref.watch(premiumUnlockedProvider).value ?? false;

    String categoryName(String id) {
      final matching = categories.where((c) => c.id == id);
      if (matching.isEmpty) return '?';
      return resolveCategoryName(l10n, matching.first.defaultKey, matching.first.name);
    }

    String memberName(String id) {
      final matching = members.where((m) => m.id == id);
      return matching.isEmpty ? '?' : matching.first.name;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Row(children: [
          Text(l10n.recurringTitle),
          const SizedBox(width: 8),
          Chip(label: Text(l10n.commonProBadge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)), visualDensity: VisualDensity.compact),
        ]),
      ),
      body: SyncRefreshIndicator(
        groupId: groupId,
        child: rules.when(
        data: (rows) => rows.isEmpty
            ? EmptyState(icon: Icons.repeat_rounded, title: l10n.recurringEmpty)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rows.length,
                itemBuilder: (context, i) {
                  final rule = rows[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        child: const Icon(Icons.repeat_rounded),
                      ),
                      title: Text(categoryName(rule.template.categoryId), style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        '${l10n.recurringDayOfMonth(rule.dayOfMonth)} · ${memberName(rule.template.payerMemberId)} · ${fmt.currency(rule.template.amountPaisa)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Switch(
                        value: rule.active,
                        onChanged: (v) {
                          ref.read(recurringRulesRepositoryProvider).setActive(rule.id, v);
                          triggerBackgroundSync(ref, groupId);
                        },
                      ),
                      onLongPress: () {
                        ref.read(recurringRulesRepositoryProvider).deleteRule(rule.id);
                        triggerBackgroundSync(ref, groupId);
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text(l10n.commonErrorPrefix(e.toString())),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => premium ? _showAddDialog(context, ref, categories, members) : context.push('/premium/paywall'),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.recurringAdd),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref, List categories, List<Member> members) async {
    if (categories.isEmpty || members.isEmpty) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddRecurringSheet(groupId: groupId, categories: categories, members: members),
    );
  }
}

class _AddRecurringSheet extends ConsumerStatefulWidget {
  const _AddRecurringSheet({required this.groupId, required this.categories, required this.members});

  final String groupId;
  final List categories;
  final List<Member> members;

  @override
  ConsumerState<_AddRecurringSheet> createState() => _AddRecurringSheetState();
}

class _AddRecurringSheetState extends ConsumerState<_AddRecurringSheet> {
  final _amountController = TextEditingController();
  late String _categoryId = widget.categories.first.id as String;
  late String _payerId = widget.members.first.id;
  int _dayOfMonth = 1;
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) return;
    setState(() => _saving = true);
    await ref.read(recurringRulesRepositoryProvider).createRule(
          groupId: widget.groupId,
          amountPaisa: (amount * 100).round(),
          categoryId: _categoryId,
          payerMemberId: _payerId,
          dayOfMonth: _dayOfMonth,
        );
    triggerBackgroundSync(ref, widget.groupId);
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
          Text(l10n.recurringAdd, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
            decoration: InputDecoration(labelText: l10n.recurringAmountLabel, prefixText: '৳'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _categoryId,
            decoration: InputDecoration(labelText: l10n.reportColShared),
            items: [
              for (final c in widget.categories)
                DropdownMenuItem(value: c.id as String, child: Text(resolveCategoryName(l10n, c.defaultKey as String?, c.name as String))),
            ],
            onChanged: (v) => setState(() => _categoryId = v ?? _categoryId),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _payerId,
            decoration: InputDecoration(labelText: l10n.expensesPaidBy),
            items: [for (final m in widget.members) DropdownMenuItem(value: m.id, child: Text(m.name))],
            onChanged: (v) => setState(() => _payerId = v ?? _payerId),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Text(l10n.wizardMonthStartsOn, style: const TextStyle(fontSize: 13))),
              IconButton.outlined(icon: const Icon(Icons.remove_rounded), onPressed: _dayOfMonth > 1 ? () => setState(() => _dayOfMonth -= 1) : null),
              SizedBox(width: 30, child: Center(child: Text('$_dayOfMonth'))),
              IconButton.outlined(icon: const Icon(Icons.add_rounded), onPressed: _dayOfMonth < 28 ? () => setState(() => _dayOfMonth += 1) : null),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.commonSave),
          ),
        ],
      ),
    );
  }
}
