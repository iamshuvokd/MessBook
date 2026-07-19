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
import '../../../core/utils/icon_lookup.dart';
import '../../../domain/models/expense.dart';
import '../../../domain/models/member.dart';
import '../../providers/repository_providers.dart';
import 'split_editor_screen.dart';

const _uuid = Uuid();

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
      _splitType = draft.splitType;
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
    });
  }

  bool get _canSave =>
      _amountPaisa > 0 &&
      _categoryId != null &&
      _payerIds.isNotEmpty &&
      _payersSum == _amountPaisa &&
      _splits != null &&
      _splits!.values.fold<int>(0, (a, b) => a + b) == _amountPaisa;

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
    final payers = [
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
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, size: 18),
                              const SizedBox(width: 8),
                              Text('${_date.day}/${_date.month}/${_date.year}'),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '৳$_amountText',
                          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, fontFamily: moneyFontFamily),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(child: Text(l10n.expensesAmountPaid, style: const TextStyle(fontSize: 12, color: Colors.grey))),
                      const SizedBox(height: 18),
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
                                onSelected: (_) => setState(() => _categoryId = c.id),
                              ),
                          ],
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 20),
                      Text(l10n.expensesPaidBy, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 8),
                      for (final id in _payerIds) _payerRow(memberList, id),
                      OutlinedButton.icon(
                        onPressed: () => _showPayerPicker(memberList),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(l10n.expensesAddPayer),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _noteController,
                        decoration: InputDecoration(hintText: l10n.expensesNoteHint, prefixIcon: const Icon(Icons.edit_note_rounded)),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.call_split_rounded),
                          title: Text(_splitSummaryText(memberList, l10n)),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => _openSplitEditor(memberList),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
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
                _buildKeypad(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: FilledButton.icon(
                    onPressed: (_canSave && !_saving) ? _save : null,
                    icon: _saving
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.check_rounded),
                    label: Text(l10n.expensesSave),
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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

  Widget _buildKeypad() {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', 'back'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.4,
      children: [
        for (final k in keys)
          InkWell(
            onTap: () => _onKeypadTap(k),
            child: Center(
              child: k == 'back' ? const Icon(Icons.backspace_outlined) : Text(k, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            ),
          ),
      ],
    );
  }
}
