import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/category_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../core/utils/icon_lookup.dart';
import '../../../domain/models/expense.dart';
import '../../../domain/models/member.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/section_header.dart';
import 'split_editor_screen.dart';

const _uuid = Uuid();

/// Why the Save button is currently disabled — so the user is told what's
/// missing instead of tapping a dead button. Order matters: the first thing
/// still missing is what we surface.
enum ExpenseSaveBlocker { none, amount, category, payer, payerSum, split, splitSum }

ExpenseSaveBlocker expenseSaveBlocker({
  required int amountPaisa,
  required bool hasCategory,
  required bool hasPayer,
  required int payersSumPaisa,
  // null = the split editor hasn't been configured yet.
  required int? splitsSumPaisa,
  // The mess collected deposits up front and this was spent out of that
  // pot, so no individual fronted the money and there is nobody to pay
  // back. Demanding a payer here would credit someone `totalPaid` they
  // never actually spent, leaving the mess owing them the bazar amount on
  // top of the deposits it already holds.
  bool paidFromFund = false,
}) {
  if (amountPaisa <= 0) return ExpenseSaveBlocker.amount;
  if (!hasCategory) return ExpenseSaveBlocker.category;
  if (!paidFromFund) {
    if (!hasPayer) return ExpenseSaveBlocker.payer;
    if (payersSumPaisa != amountPaisa) return ExpenseSaveBlocker.payerSum;
  }
  if (splitsSumPaisa == null) return ExpenseSaveBlocker.split;
  if (splitsSumPaisa != amountPaisa) return ExpenseSaveBlocker.splitSum;
  return ExpenseSaveBlocker.none;
}

/// Whether a newly-picked category should default to being paid out of the
/// mess fund. Bazar/grocery runs are the money flow this mess actually uses
/// — everyone deposits first, the manager spends from the pot — so those
/// default to the fund. Rent/WiFi and friends still default to a member
/// paying, since those are typically fronted by one person.
bool defaultPaidFromFundForCategory({required bool isMealCategory}) => isMealCategory;

/// Which split a newly-picked category should default to. Bazar/grocery
/// (meal) categories default to a by-meals split, so each member is charged
/// meal rate x their own meals — the mess model where everyone's deposit is
/// drawn down by what they actually ate. Rent/WiFi and friends stay equal.
SplitType defaultSplitForCategory({required bool isMealCategory}) =>
    isMealCategory ? SplitType.meal : SplitType.equal;

class AddEditExpenseScreen extends ConsumerStatefulWidget {
  const AddEditExpenseScreen({super.key, required this.groupId, this.expenseId});

  final String groupId;
  final String? expenseId;

  @override
  ConsumerState<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends ConsumerState<AddEditExpenseScreen> {
  int _amountPaisa = 0;
  String _amountText = '0';
  DateTime _date = DateTime.now();
  String? _categoryId;
  final _noteController = TextEditingController();
  final Set<String> _payerIds = {};
  final Map<String, TextEditingController> _payerAmountControllers = {};
  SplitType _splitType = SplitType.equal;
  // Once the user picks a split themselves (or we loaded an existing
  // expense), stop re-defaulting it when the category changes.
  bool _splitTypeChosen = false;
  /// True = spent out of the collected deposits, so the expense has no payer.
  bool _paidFromFund = false;
  /// Mirrors [_splitTypeChosen]: once the user picks the funding source
  /// themselves, stop re-defaulting it when the category changes.
  bool _paidFromFundChosen = false;
  Map<String, int>? _splits;
  String? _receiptPath;
  bool _loading = false;
  bool _saving = false;

  bool get _isEdit => widget.expenseId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _loadExisting();
    }
  }

  Future<void> _loadExisting() async {
    setState(() => _loading = true);
    final draft = await ref.read(expensesRepositoryProvider).getExpense(widget.expenseId!);
    if (!mounted || draft == null) return;
    setState(() {
      _amountPaisa = draft.expense.amountPaisa;
      _amountText = (_amountPaisa / 100).toString();
      _date = draft.expense.date;
      _categoryId = draft.expense.categoryId;
      _noteController.text = draft.expense.note ?? '';
      for (final p in draft.payers) {
        _payerIds.add(p.memberId);
        _payerAmountControllers[p.memberId] = TextEditingController(text: (p.amountPaisa / 100).toStringAsFixed(2));
      }
      // No payer rows means it was spent from the fund.
      _paidFromFund = draft.payers.isEmpty;
      _paidFromFundChosen = true;
      _splitType = draft.splitType;
      _splitTypeChosen = true;
      _splits = {for (final s in draft.splits) s.memberId: s.amountPaisa};
      _receiptPath = draft.expense.receiptPath;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    for (final c in _payerAmountControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onKeypadTap(String key) {
    setState(() {
      if (key == 'back') {
        _amountText = _amountText.length > 1 ? _amountText.substring(0, _amountText.length - 1) : '0';
      } else if (key == '.') {
        if (!_amountText.contains('.')) _amountText += '.';
      } else {
        if (_amountText == '0' && key != '.') {
          _amountText = key;
        } else {
          final parts = _amountText.split('.');
          if (parts.length == 2 && parts[1].length >= 2) return;
          _amountText += key;
        }
      }
      _amountPaisa = ((double.tryParse(_amountText) ?? 0) * 100).round();
      _syncSinglePayerAmount();
    });
  }

  void _syncSinglePayerAmount() {
    if (_payerIds.length == 1) {
      _payerAmountControllers[_payerIds.first]?.text = (_amountPaisa / 100).toStringAsFixed(2);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _togglePayer(String memberId) {
    setState(() {
      if (_payerIds.contains(memberId)) {
        _payerIds.remove(memberId);
        _payerAmountControllers.remove(memberId)?.dispose();
      } else {
        _payerIds.add(memberId);
        _payerAmountControllers[memberId] = TextEditingController(
          text: _payerIds.length == 1 ? (_amountPaisa / 100).toStringAsFixed(2) : '0.00',
        );
      }
    });
  }

  int get _payersSum {
    var sum = 0;
    for (final id in _payerIds) {
      final v = double.tryParse(_payerAmountControllers[id]?.text ?? '') ?? 0;
      sum += (v * 100).round();
    }
    return sum;
  }

  Future<void> _openSplitEditor(List<Member> members) async {
    if (_amountPaisa <= 0) return;

    final monthStart = DateTime(_date.year, _date.month, 1);
    final monthEnd = DateTime(_date.year, _date.month + 1, 1);
    final monthMeals = await ref
        .read(mealsRepositoryProvider)
        .watchMealsInRange(widget.groupId, monthStart, monthEnd)
        .first;
    final mealCounts = <String, double>{};
    for (final meal in monthMeals) {
      mealCounts[meal.memberId] = (mealCounts[meal.memberId] ?? 0) + meal.total;
    }

    if (!mounted) return;
    final result = await Navigator.of(context).push<SplitEditorResult>(
      MaterialPageRoute(
        builder: (_) => SplitEditorScreen(
          amountPaisa: _amountPaisa,
          members: members,
          initialSplitType: _splitType,
          initialSplits: _splits,
          memberMealCounts: mealCounts,
        ),
      ),
    );
    if (result == null) return;
    setState(() {
      _splitType = result.splitType;
      _splits = result.splits;
      _splitTypeChosen = true;
    });
  }

  ExpenseSaveBlocker get _saveBlocker => expenseSaveBlocker(
        amountPaisa: _amountPaisa,
        hasCategory: _categoryId != null,
        hasPayer: _payerIds.isNotEmpty,
        payersSumPaisa: _payersSum,
        splitsSumPaisa: _splits?.values.fold<int>(0, (a, b) => a + b),
        paidFromFund: _paidFromFund,
      );

  bool get _canSave => _saveBlocker == ExpenseSaveBlocker.none;

  Future<void> _save() async {
    if (!_canSave) return;
    // Can't add or edit an expense dated inside a closed (locked) month.
    if (ref.read(isMonthClosedForDateProvider(_date))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).monthClosedCannotEdit)),
      );
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(expensesRepositoryProvider);
    // Fund-paid expenses carry no payers at all, so nobody is credited
    // `totalPaid` for money that came out of the shared pot.
    final payers = _paidFromFund
        ? const <ExpensePayerEntry>[]
        : [
            for (final id in _payerIds)
              ExpensePayerEntry(memberId: id, amountPaisa: ((double.tryParse(_payerAmountControllers[id]!.text) ?? 0) * 100).round()),
          ];
    final splits = [for (final e in _splits!.entries) ExpenseSplitEntry(memberId: e.key, amountPaisa: e.value)];
    final note = _noteController.text.trim();

    if (_isEdit) {
      await repo.updateExpense(
        id: widget.expenseId!,
        groupId: widget.groupId,
        amountPaisa: _amountPaisa,
        date: _date,
        categoryId: _categoryId!,
        note: note.isEmpty ? null : note,
        receiptPath: _receiptPath,
        payers: payers,
        splits: splits,
        splitType: _splitType,
      );
    } else {
      await repo.createExpense(
        groupId: widget.groupId,
        amountPaisa: _amountPaisa,
        date: _date,
        categoryId: _categoryId!,
        note: note.isEmpty ? null : note,
        receiptPath: _receiptPath,
        payers: payers,
        splits: splits,
        splitType: _splitType,
      );
    }
    triggerBackgroundSync(ref, widget.groupId);
    if (!mounted) return;
    context.pop();
  }

  Future<void> _pickReceiptPhoto(bool premium) async {
    if (!premium) {
      context.push('/premium/paywall');
      return;
    }
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: Text(l10n.expensesAddReceiptPhoto),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(l10n.expensesReceiptPhoto),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picked = await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (picked == null) return;

    final docsDir = await getApplicationDocumentsDirectory();
    final receiptsDir = Directory(p.join(docsDir.path, 'receipts'));
    if (!await receiptsDir.exists()) await receiptsDir.create(recursive: true);
    final destPath = p.join(receiptsDir.path, '${_uuid.v4()}${p.extension(picked.path)}');
    await File(picked.path).copy(destPath);

    if (!mounted) return;
    setState(() => _receiptPath = destPath);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(categoriesForSelectedGroupProvider);
    final members = ref.watch(membersRepositoryProvider).watchMembers(widget.groupId, activeOnly: true);
    final premium = ref.watch(premiumUnlockedProvider).value ?? false;
    final fmt = BdFormatter(
      useBanglaDigits: ref.watch(banglaDigitsProvider),
      locale: ref.watch(localeProvider).languageCode,
    );

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(_isEdit ? l10n.commonEdit : l10n.expensesAddTitle),
      ),
      body: StreamBuilder<List<Member>>(
        stream: members,
        builder: (context, memberSnap) {
          final memberList = memberSnap.data ?? const [];
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    children: [
                      // The amount is what this screen is really for, so it
                      // leads — with the date sitting inside the same card as
                      // a visibly tappable chip rather than a bare row that
                      // read as static text.
                      _amountHeader(l10n, fmt),
                      const SizedBox(height: 22),
                      SectionHeader(l10n.expensesSectionCategory),
                      categories.when(
                        data: (rows) => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final c in rows)
                              ChoiceChip(
                                label: Text(resolveCategoryName(l10n, c.defaultKey, c.name)),
                                avatar: Icon(lookupIcon(c.icon), size: 16),
                                selected: _categoryId == c.id,
                                onSelected: (_) => setState(() {
                                  _categoryId = c.id;
                                  if (!_splitTypeChosen) {
                                    _splitType = defaultSplitForCategory(isMealCategory: c.isMealCategory);
                                  }
                                  if (!_paidFromFundChosen) {
                                    _paidFromFund = defaultPaidFromFundForCategory(isMealCategory: c.isMealCategory);
                                  }
                                }),
                              ),
                          ],
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 22),
                      SectionHeader(l10n.expensesPaidBy),
                      SegmentedButton<bool>(
                        segments: [
                          ButtonSegment(
                            value: true,
                            icon: const Icon(Icons.savings_rounded, size: 16),
                            label: Text(l10n.expensesPaidFromFund),
                          ),
                          ButtonSegment(
                            value: false,
                            icon: const Icon(Icons.person_rounded, size: 16),
                            label: Text(l10n.expensesPaidByMember),
                          ),
                        ],
                        selected: {_paidFromFund},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) => setState(() {
                          _paidFromFund = s.first;
                          _paidFromFundChosen = true;
                        }),
                      ),
                      const SizedBox(height: 10),
                      // Spell out where the money moves, so nobody has to
                      // reason about the ledger to pick the right option.
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded, size: 15, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _paidFromFund ? l10n.expensesPaidFromFundHint : l10n.expensesPaidByMemberHint,
                              style: TextStyle(fontSize: 11.5, height: 1.35, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                      if (!_paidFromFund) ...[
                        const SizedBox(height: 12),
                        for (final id in _payerIds) _payerRow(memberList, id),
                        OutlinedButton.icon(
                          onPressed: () => _showPayerPicker(memberList),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: Text(l10n.expensesAddPayer),
                        ),
                      ],
                      const SizedBox(height: 22),
                      SectionHeader(l10n.expensesSectionSplit),
                      Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          leading: const Icon(Icons.call_split_rounded),
                          title: Text(_splitSummaryText(memberList, l10n)),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => _openSplitEditor(memberList),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SectionHeader(l10n.expensesSectionNote),
                      TextField(
                        controller: _noteController,
                        decoration: InputDecoration(hintText: l10n.expensesNoteHint, prefixIcon: const Icon(Icons.edit_note_rounded)),
                      ),
                      const SizedBox(height: 22),
                      SectionHeader(l10n.expensesSectionReceipt),
                      Card(
                        margin: EdgeInsets.zero,
                        child: _receiptPath != null
                            ? ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(File(_receiptPath!), width: 40, height: 40, fit: BoxFit.cover),
                                ),
                                title: Text(l10n.expensesReceiptPhoto),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 18),
                                  onPressed: () => setState(() => _receiptPath = null),
                                ),
                                onTap: () => _pickReceiptPhoto(premium),
                              )
                            : ListTile(
                                leading: Icon(premium ? Icons.add_a_photo_rounded : Icons.lock_rounded),
                                title: Text(l10n.expensesAddReceiptPhoto),
                                subtitle: premium ? null : Text(l10n.expensesReceiptIsPremium, style: const TextStyle(fontSize: 11.5)),
                                onTap: () => _pickReceiptPhoto(premium),
                              ),
                      ),
                    ],
                  ),
                ),
                _buildKeypad(fmt),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Never leave Save dead without saying why.
                      if (!_canSave)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  size: 15, color: Theme.of(context).colorScheme.onSurfaceVariant),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _blockerMessage(l10n, _saveBlocker),
                                  style: TextStyle(
                                      fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                ),
                              ),
                            ],
                          ),
                        ),
                      FilledButton.icon(
                        onPressed: (_canSave && !_saving) ? _save : null,
                        icon: _saving
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.check_rounded),
                        label: Text(l10n.expensesSave),
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// The amount + date card. The amount is the whole point of the screen, so
  /// it leads; the date is a real chip beside it, because as a bare icon+text
  /// row it didn't read as tappable at all.
  Widget _amountHeader(AppLocalizations l10n, BdFormatter fmt) {
    final scheme = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final isToday = _date.year == today.year && _date.month == today.month && _date.day == today.day;
    final empty = _amountPaisa <= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Text(l10n.expensesAmountPaid,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '৳${fmt.digits(_amountText)}',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                fontFamily: moneyFontFamily,
                // Grey out a zero amount so it reads as a placeholder
                // waiting for the keypad, not as a real ৳0 expense.
                color: empty ? scheme.onSurfaceVariant.withValues(alpha: 0.45) : scheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ActionChip(
            avatar: const Icon(Icons.calendar_today_rounded, size: 15),
            label: Text(isToday ? l10n.expensesToday : fmt.day(_date)),
            onPressed: _pickDate,
          ),
        ],
      ),
    );
  }

  String _blockerMessage(AppLocalizations l10n, ExpenseSaveBlocker blocker) => switch (blocker) {
        ExpenseSaveBlocker.amount => l10n.expenseBlockerAmount,
        ExpenseSaveBlocker.category => l10n.expenseBlockerCategory,
        ExpenseSaveBlocker.payer => l10n.expenseBlockerPayer,
        ExpenseSaveBlocker.payerSum => l10n.expenseBlockerPayerSum,
        ExpenseSaveBlocker.split => l10n.expenseBlockerSplit,
        ExpenseSaveBlocker.splitSum => l10n.expenseBlockerSplitSum,
        ExpenseSaveBlocker.none => '',
      };

  String _splitSummaryText(List<Member> members, AppLocalizations l10n) {
    if (_splits == null || _splits!.isEmpty) return l10n.expensesSplitConfigure;
    final count = _splits!.length;
    final each = count == 0 ? 0 : _amountPaisa ~/ count;
    final label = switch (_splitType) {
      SplitType.equal => l10n.splitEqually,
      SplitType.unequal => l10n.splitUnequally,
      SplitType.shares => l10n.splitByShares,
      SplitType.percent => l10n.splitByPercent,
      SplitType.meal => l10n.splitByMeals,
    };
    final membersText = _splitType == SplitType.equal
        ? l10n.expensesSplitMembersEach(count, (each / 100).toStringAsFixed(0))
        : l10n.expensesSplitMembers(count);
    return '$label · $membersText';
  }

  Widget _payerRow(List<Member> members, String memberId) {
    final member = members.firstWhere((m) => m.id == memberId, orElse: () => Member(
          id: memberId,
          groupId: widget.groupId,
          name: '?',
          joinDate: DateTime.now(),
          active: true,
          updatedAt: DateTime.now(),
        ));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(radius: 16, child: Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?', style: const TextStyle(fontSize: 13))),
          const SizedBox(width: 10),
          Expanded(child: Text(member.name, style: const TextStyle(fontWeight: FontWeight.w600))),
          if (_payerIds.length > 1)
            SizedBox(
              width: 90,
              child: TextField(
                controller: _payerAmountControllers[memberId],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                textAlign: TextAlign.right,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(prefixText: '৳', isDense: true),
              ),
            )
          else
            Text('৳${(_amountPaisa / 100).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700)),
          IconButton(icon: const Icon(Icons.close_rounded, size: 18), onPressed: () => _togglePayer(memberId)),
        ],
      ),
    );
  }

  Future<void> _showPayerPicker(List<Member> members) async {
    final available = members.where((m) => !_payerIds.contains(m.id)).toList();
    if (available.isEmpty) return;
    final picked = await showModalBottomSheet<Member>(
      context: context,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: [
          for (final m in available)
            ListTile(
              leading: CircleAvatar(child: Text(m.name.isNotEmpty ? m.name[0].toUpperCase() : '?')),
              title: Text(m.name),
              onTap: () => Navigator.of(context).pop(m),
            ),
        ],
      ),
    );
    if (picked != null) _togglePayer(picked.id);
  }

  Widget _buildKeypad(BdFormatter fmt) {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', 'back'];
    final scheme = Theme.of(context).colorScheme;
    // The keypad used to sit flush against the scrolling form with nothing
    // marking where the content ended, so the digits looked like part of the
    // list. Give it its own tinted surface with a top edge.
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.4,
        children: [
          for (final k in keys)
            InkWell(
              onTap: () => _onKeypadTap(k),
              child: Center(
                child: k == 'back'
                    ? const Icon(Icons.backspace_outlined)
                    : Text(k == '.' ? k : fmt.digits(k),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }
}
