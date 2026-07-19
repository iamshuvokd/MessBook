import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../domain/engines/debt_simplifier.dart';
import '../../../domain/models/ledger_purpose.dart';
import '../../../domain/models/member.dart';
import '../../../domain/models/member_permission.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/sync_refresh_indicator.dart';

class SettleUpScreen extends ConsumerWidget {
  const SettleUpScreen({super.key, required this.groupId});

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
    final ledgerSeparate = ref.watch(selectedGroupProvider)?.mealLedgerSeparate ?? false;

    if (!ledgerSeparate) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
          title: Text(l10n.settleUpTitle),
        ),
        body: _LedgerSettleView(groupId: groupId, ledger: null),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
          title: Text(l10n.settleUpTitle),
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.restaurant_rounded, size: 18), text: l10n.ledgerMealTab),
              Tab(icon: const Icon(Icons.home_rounded, size: 18), text: l10n.ledgerGeneralTab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _LedgerSettleView(groupId: groupId, ledger: LedgerPurpose.meal),
            _LedgerSettleView(groupId: groupId, ledger: LedgerPurpose.general),
          ],
        ),
      ),
    );
  }
}

/// One ledger's settle-up view. [ledger] null = the combined single-ledger
/// view (groups without meal separation).
class _LedgerSettleView extends ConsumerWidget {
  const _LedgerSettleView({required this.groupId, required this.ledger});

  final String groupId;
  final LedgerPurpose? ledger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);

    final debts = ledger == null
        ? ref.watch(simplifiedDebtsProvider)
        : ref.watch(simplifiedDebtsByLedgerProvider(ledger!));
    final balances = ledger == null
        ? ref.watch(memberBalancesProvider)
        : ref.watch(memberBalancesByLedgerProvider(ledger!));
    final members = ref.watch(membersOfSelectedGroupProvider);
    final settlements = ref.watch(settlementsOfSelectedGroupProvider);
    final canManage = ref.watch(canProvider(MemberPermission.moneyManage));

    String nameOf(String memberId) {
      final list = members.value ?? const <Member>[];
      final matching = list.where((m) => m.id == memberId);
      return matching.isEmpty ? '?' : matching.first.name;
    }

    final visibleSettlements = (settlements.value ?? const [])
        .where((s) => ledger == null || s.purpose == ledger)
        .toList();
    final netSum = balances.value?.fold<int>(0, (a, b) => a + b.net) ?? 0;

    return SyncRefreshIndicator(
      groupId: groupId,
      child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        debts.when(
          data: (tx) => tx.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(children: [
                    Icon(Icons.celebration_rounded, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 10),
                    Expanded(child: Text(l10n.settleUpAllSettled)),
                  ]),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Row(children: [
                        Icon(Icons.auto_awesome_rounded, size: 20, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 10),
                        Expanded(child: Text(l10n.settleUpAutoNote(tx.length))),
                      ]),
                    ),
                    const SizedBox(height: 14),
                    Card(
                      child: Column(
                        children: [
                          for (final t in tx)
                            ListTile(
                              leading: const Icon(Icons.arrow_forward_rounded),
                              title: Text('${nameOf(t.fromMemberId)} → ${nameOf(t.toMemberId)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(fmt.currency(t.amountPaisa), style: const TextStyle(fontFamily: moneyFontFamily, fontWeight: FontWeight.w700)),
                                  if (canManage) ...[
                                    const SizedBox(width: 10),
                                    FilledButton.tonal(
                                      onPressed: () => _showRecordDialog(context, ref, t, fmt),
                                      child: Text(l10n.settleUpRecord),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text(l10n.commonErrorPrefix(e.toString())),
        ),
        const SizedBox(height: 20),
        Text(l10n.settleUpRecorded, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        settlements.when(
          data: (_) => visibleSettlements.isEmpty
              ? Padding(padding: const EdgeInsets.all(12), child: Text(l10n.settleUpNone))
              : Card(
                  child: Column(
                    children: [
                      for (final s in visibleSettlements)
                        ListTile(
                          leading: Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.primary),
                          title: Text('${nameOf(s.fromMemberId)} → ${nameOf(s.toMemberId)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text([fmt.day(s.date), if (s.method != null) s.method!].join(' · ')),
                          trailing: Text(fmt.currency(s.amountPaisa), style: const TextStyle(fontFamily: moneyFontFamily, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text(l10n.commonErrorPrefix(e.toString())),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Icon(Icons.balance_rounded, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.settleUpBalanceCheck)),
              Text('Σ = ${fmt.currency(netSum)} ${netSum == 0 ? '✓' : ''}', style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
      ),
    );
  }

  Future<void> _showRecordDialog(BuildContext context, WidgetRef ref, DebtTransaction t, BdFormatter fmt) async {
    final l10n = AppLocalizations.of(context);
    final amountController = TextEditingController(text: (t.amountPaisa / 100).toStringAsFixed(2));
    final methodController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Text(l10n.settleUpConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.settleUpFullAmountRemaining(fmt.currency(t.amountPaisa)), style: const TextStyle(fontSize: 12.5)),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              decoration: InputDecoration(labelText: l10n.settleUpAmountHint, prefixText: '৳'),
            ),
            const SizedBox(height: 10),
            TextField(controller: methodController, decoration: InputDecoration(labelText: l10n.settleUpMethodHint)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.commonSave)),
        ],
      ),
    );

    if (confirmed != true) return;
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    if (amount <= 0) return;
    final amountPaisa = (amount * 100).round().clamp(0, t.amountPaisa);

    await ref.read(settlementsRepositoryProvider).recordSettlement(
          groupId: groupId,
          fromMemberId: t.fromMemberId,
          toMemberId: t.toMemberId,
          amountPaisa: amountPaisa,
          method: methodController.text.trim().isEmpty ? null : methodController.text.trim(),
          purpose: ledger ?? LedgerPurpose.general,
        );
    triggerBackgroundSync(ref, groupId);
  }
}
