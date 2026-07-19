import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../widgets/empty_state.dart';
import '../../widgets/sync_refresh_indicator.dart';

class DepositsScreen extends ConsumerWidget {
  const DepositsScreen({super.key, required this.groupId});

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
    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final deposits = ref.watch(depositsOfSelectedGroupProvider);
    final expenses = ref.watch(expensesOfSelectedGroupProvider);
    final members = ref.watch(membersOfSelectedGroupProvider);
    final ledgerSeparate = ref.watch(selectedGroupProvider)?.mealLedgerSeparate ?? false;
    final canManage = ref.watch(canProvider(MemberPermission.moneyManage));

    final collected = deposits.value?.fold<int>(0, (a, d) => a + d.amountPaisa) ?? 0;
    final spent = expenses.value?.fold<int>(0, (a, e) => a + e.expense.amountPaisa) ?? 0;
    final inHand = collected - spent;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(l10n.depositsTitle),
      ),
      body: SyncRefreshIndicator(
        groupId: groupId,
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: AppColors.heroGradient, borderRadius: BorderRadius.circular(AppRadius.xxl)),
            child: Row(
              children: [
                _StatTile(label: l10n.depositsCollected, value: fmt.currency(collected)),
                _StatTile(label: l10n.depositsSpent, value: fmt.currency(spent)),
                _StatTile(label: l10n.depositsInHand, value: fmt.currency(inHand), highlight: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          deposits.when(
            data: (rows) => rows.isEmpty
                ? EmptyState(icon: Icons.savings_rounded, title: l10n.depositsEmpty)
                : Card(
                    child: Column(
                      children: [
                        for (final d in rows)
                          Builder(builder: (context) {
                            final memberList = members.value ?? const <Member>[];
                            final matching = memberList.where((m) => m.id == d.memberId);
                            final name = matching.isEmpty ? '?' : matching.first.name;
                            return ListTile(
                              leading: CircleAvatar(child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?')),
                              title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                              subtitle: Text([
                                fmt.day(d.date),
                                if (ledgerSeparate)
                                  d.purpose == LedgerPurpose.meal ? l10n.ledgerMealTab : l10n.ledgerGeneralTab,
                                if (d.note != null) d.note!,
                              ].join(' · ')),
                              trailing: Text(
                                '+${fmt.currency(d.amountPaisa)}',
                                style: const TextStyle(fontFamily: moneyFontFamily, fontWeight: FontWeight.w700, color: AppColors.teal700),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(l10n.commonErrorPrefix(e.toString())),
          ),
        ],
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton(
              onPressed: () => _showAddDepositSheet(context, ref, members.value ?? const [], ledgerSeparate),
              child: const Icon(Icons.add_rounded),
            )
          : null,
    );
  }

  Future<void> _showAddDepositSheet(
      BuildContext context, WidgetRef ref, List<Member> members, bool ledgerSeparate) async {
    if (members.isEmpty) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddDepositSheet(groupId: groupId, members: members, ledgerSeparate: ledgerSeparate),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, this.highlight = false});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: highlight ? 0.22 : 0.12),
          border: Border.all(color: Colors.white.withValues(alpha: highlight ? 0.4 : 0.18)),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 2),
            Text(value, style: moneyTextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _AddDepositSheet extends ConsumerStatefulWidget {
  const _AddDepositSheet({required this.groupId, required this.members, required this.ledgerSeparate});

  final String groupId;
  final List<Member> members;
  final bool ledgerSeparate;

  @override
  ConsumerState<_AddDepositSheet> createState() => _AddDepositSheetState();
}

class _AddDepositSheetState extends ConsumerState<_AddDepositSheet> {
  late String _memberId = widget.members.first.id;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  LedgerPurpose _purpose = LedgerPurpose.general;
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) return;
    if (ref.read(isMonthClosedForDateProvider(DateTime.now()))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).monthClosedCannotEdit)),
      );
      return;
    }
    setState(() => _saving = true);
    await ref.read(depositsRepositoryProvider).addDeposit(
          groupId: widget.groupId,
          memberId: _memberId,
          amountPaisa: (amount * 100).round(),
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
          purpose: widget.ledgerSeparate ? _purpose : LedgerPurpose.general,
        );
    triggerBackgroundSync(ref, widget.groupId);
    if (!mounted) return;
    Navigator.of(context).pop();
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
          Text(l10n.depositsAdd, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _memberId,
            decoration: InputDecoration(labelText: l10n.depositsMemberHint),
            items: [for (final m in widget.members) DropdownMenuItem(value: m.id, child: Text(m.name))],
            onChanged: (v) => setState(() => _memberId = v ?? _memberId),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
            decoration: InputDecoration(labelText: l10n.depositsAmountHint, prefixText: '৳'),
          ),
          const SizedBox(height: 12),
          TextField(controller: _noteController, decoration: InputDecoration(labelText: l10n.depositsNoteHint)),
          if (widget.ledgerSeparate) ...[
            const SizedBox(height: 14),
            Text(l10n.depositsPurposeQuestion, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SegmentedButton<LedgerPurpose>(
              segments: [
                ButtonSegment(value: LedgerPurpose.general, label: Text(l10n.ledgerGeneralTab), icon: const Icon(Icons.home_rounded, size: 16)),
                ButtonSegment(value: LedgerPurpose.meal, label: Text(l10n.ledgerMealTab), icon: const Icon(Icons.restaurant_rounded, size: 16)),
              ],
              selected: {_purpose},
              onSelectionChanged: (s) => setState(() => _purpose = s.first),
            ),
          ],
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.commonSave),
          ),
        ],
      ),
    );
  }
}
