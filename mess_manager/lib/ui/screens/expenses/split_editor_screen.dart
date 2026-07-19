import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/engines/split_calculator.dart';
import '../../../domain/models/expense.dart';
import '../../../domain/models/member.dart';

class SplitEditorResult {
  const SplitEditorResult({required this.splitType, required this.splits});
  final SplitType splitType;
  final Map<String, int> splits;
}

class SplitEditorScreen extends StatefulWidget {
  const SplitEditorScreen({
    super.key,
    required this.amountPaisa,
    required this.members,
    this.initialSplitType = SplitType.equal,
    this.initialSplits,
    this.memberMealCounts,
  });

  final int amountPaisa;
  final List<Member> members;
  final SplitType initialSplitType;
  final Map<String, int>? initialSplits;

  /// Each member's meal count (own + guest) for the expense's month, used by
  /// the Meal split tab. Null/empty members simply can't use that tab.
  final Map<String, double>? memberMealCounts;

  @override
  State<SplitEditorScreen> createState() => _SplitEditorScreenState();
}

class _SplitEditorScreenState extends State<SplitEditorScreen> {
  late SplitType _type;
  late Set<String> _included;
  late Map<String, TextEditingController> _unequalControllers;
  late Map<String, TextEditingController> _sharesControllers;
  late Map<String, TextEditingController> _percentControllers;

  @override
  void initState() {
    super.initState();
    _type = widget.initialSplitType;
    _included = widget.initialSplits != null
        ? widget.initialSplits!.keys.toSet()
        : widget.members.map((m) => m.id).toSet();

    final initial = widget.initialSplits;
    _unequalControllers = {
      for (final m in widget.members)
        m.id: TextEditingController(text: initial != null && initial.containsKey(m.id) ? (initial[m.id]! / 100).toStringAsFixed(2) : ''),
    };
    _sharesControllers = {for (final m in widget.members) m.id: TextEditingController(text: '1')};
    final equalPercent = widget.members.isEmpty ? 0.0 : 100 / widget.members.length;
    _percentControllers = {
      for (final m in widget.members) m.id: TextEditingController(text: equalPercent.toStringAsFixed(2)),
    };
  }

  @override
  void dispose() {
    for (final c in _unequalControllers.values) {
      c.dispose();
    }
    for (final c in _sharesControllers.values) {
      c.dispose();
    }
    for (final c in _percentControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<Member> get _includedMembers => widget.members.where((m) => _included.contains(m.id)).toList();

  ({Map<String, int>? splits, String? error}) _computeCurrent(AppLocalizations l10n) {
    final members = _includedMembers;
    if (members.isEmpty) return (splits: null, error: null);
    try {
      switch (_type) {
        case SplitType.equal:
          return (splits: SplitCalculator.equal(widget.amountPaisa, members.map((m) => m.id).toList()), error: null);
        case SplitType.unequal:
          final amounts = <String, int>{};
          for (final m in members) {
            final text = _unequalControllers[m.id]!.text.trim();
            final value = double.tryParse(text) ?? 0;
            amounts[m.id] = (value * 100).round();
          }
          return (splits: SplitCalculator.unequal(widget.amountPaisa, amounts), error: null);
        case SplitType.shares:
          final shares = <String, int>{};
          for (final m in members) {
            shares[m.id] = int.tryParse(_sharesControllers[m.id]!.text.trim()) ?? 0;
          }
          return (splits: SplitCalculator.byShares(widget.amountPaisa, shares), error: null);
        case SplitType.percent:
          final percents = <String, double>{};
          for (final m in members) {
            percents[m.id] = double.tryParse(_percentControllers[m.id]!.text.trim()) ?? 0;
          }
          return (splits: SplitCalculator.byPercent(widget.amountPaisa, percents), error: null);
        case SplitType.meal:
          final counts = widget.memberMealCounts;
          if (counts == null || counts.isEmpty) {
            return (splits: null, error: l10n.splitNoMealDataForMonth);
          }
          final memberCounts = {for (final m in members) m.id: counts[m.id] ?? 0};
          if (memberCounts.values.every((c) => c <= 0)) {
            return (splits: null, error: l10n.splitNoMealsForSelectedMembers);
          }
          return (splits: SplitCalculator.byMeals(widget.amountPaisa, memberCounts), error: null);
      }
    } on SplitValidationError catch (e) {
      return (splits: null, error: e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final result = _computeCurrent(l10n);
    final splits = result.splits;
    final sum = splits?.values.fold<int>(0, (a, b) => a + b) ?? 0;
    final isValid = splits != null && sum == widget.amountPaisa && splits.length == _includedMembers.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.of(context).pop()),
        title: Text(l10n.splitTitle((widget.amountPaisa / 100).toStringAsFixed(2))),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: SegmentedButton<SplitType>(
                segments: [
                  ButtonSegment(value: SplitType.equal, label: Text(l10n.splitTabEqual)),
                  ButtonSegment(value: SplitType.unequal, label: Text(l10n.splitTabUnequal)),
                  ButtonSegment(value: SplitType.shares, label: Text(l10n.splitTabShares)),
                  ButtonSegment(value: SplitType.percent, label: Text(l10n.splitTabPercent)),
                  if (widget.memberMealCounts != null)
                    ButtonSegment(value: SplitType.meal, label: Text(l10n.navMeals)),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                itemCount: widget.members.length,
                itemBuilder: (context, i) => _memberRow(widget.members[i], splits),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isValid
                          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4)
                          : Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isValid ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                          size: 18,
                          color: isValid ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            result.error ??
                                l10n.splitAssigned(
                                  (sum / 100).toStringAsFixed(2),
                                  (widget.amountPaisa / 100).toStringAsFixed(2),
                                ),
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: isValid
                        ? () => Navigator.of(context).pop(SplitEditorResult(splitType: _type, splits: splits))
                        : null,
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    child: Text(l10n.commonSave),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberRow(Member member, Map<String, int>? splits) {
    final included = _included.contains(member.id);
    final scheme = Theme.of(context).colorScheme;

    Widget? trailing;
    if (included) {
      switch (_type) {
        case SplitType.equal:
          trailing = Text(
            splits != null && splits.containsKey(member.id) ? '৳${(splits[member.id]! / 100).toStringAsFixed(2)}' : '—',
            style: const TextStyle(fontWeight: FontWeight.w700),
          );
        case SplitType.unequal:
          trailing = SizedBox(
            width: 90,
            child: TextField(
              controller: _unequalControllers[member.id],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              textAlign: TextAlign.right,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(prefixText: '৳', isDense: true),
            ),
          );
        case SplitType.shares:
          trailing = SizedBox(
            width: 60,
            child: TextField(
              controller: _sharesControllers[member.id],
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.right,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(isDense: true),
            ),
          );
        case SplitType.percent:
          trailing = SizedBox(
            width: 80,
            child: TextField(
              controller: _percentControllers[member.id],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              textAlign: TextAlign.right,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(suffixText: '%', isDense: true),
            ),
          );
        case SplitType.meal:
          final count = widget.memberMealCounts?[member.id] ?? 0;
          trailing = Text(
            splits != null && splits.containsKey(member.id) ? '৳${(splits[member.id]! / 100).toStringAsFixed(2)} (${count.toStringAsFixed(count % 1 == 0 ? 0 : 1)})' : '—',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
          );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Checkbox(
            value: included,
            onChanged: (v) => setState(() {
              if (v == true) {
                _included.add(member.id);
              } else {
                _included.remove(member.id);
              }
            }),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: scheme.primaryContainer,
            foregroundColor: scheme.onPrimaryContainer,
            child: Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?', style: const TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              member.name,
              style: TextStyle(fontWeight: FontWeight.w600, color: included ? null : scheme.onSurfaceVariant.withValues(alpha: 0.5)),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
