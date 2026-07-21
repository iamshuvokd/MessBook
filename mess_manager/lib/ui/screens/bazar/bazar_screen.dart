import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../domain/models/member.dart';
import '../../../domain/models/member_permission.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/sync_refresh_indicator.dart';

/// The grocery-shopping duty roster: who does bazar on which day. A schedule,
/// not a cost — recording what was spent stays in Expenses.
class BazarScreen extends ConsumerWidget {
  const BazarScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(groupId);
      }
    });
ref.watch(foregroundGroupSyncProvider); // live sync while this screen is open

    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final duties = ref.watch(bazarDutiesOfSelectedGroupProvider).value ?? const [];
    final members = ref.watch(membersOfSelectedGroupProvider).value ?? const <Member>[];
    final canManage = ref.watch(canProvider(MemberPermission.mealsManage));

    String nameOf(String id) {
      final m = members.where((m) => m.id == id);
      return m.isEmpty ? '?' : m.first.name;
    }

    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(l10n.bazarTitle),
      ),
      body: SyncRefreshIndicator(
        groupId: groupId,
        child: duties.isEmpty
            ? EmptyState(icon: Icons.shopping_basket_rounded, title: l10n.bazarEmpty, subtitle: l10n.bazarEmptySub)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: duties.length,
                itemBuilder: (context, i) {
                  final duty = duties[i];
                  final isPast = duty.date.isBefore(todayKey);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: duty.done
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor: duty.done ? Colors.white : Theme.of(context).colorScheme.onPrimaryContainer,
                        child: Icon(duty.done ? Icons.check_rounded : Icons.shopping_basket_rounded, size: 20),
                      ),
                      title: Text(
                        nameOf(duty.memberId),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          decoration: duty.done ? TextDecoration.lineThrough : null,
                          color: isPast && !duty.done ? Theme.of(context).colorScheme.error : null,
                        ),
                      ),
                      subtitle: Text(
                        [fmt.day(duty.date), if (duty.note != null && duty.note!.isNotEmpty) duty.note!].join(' · '),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: canManage
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: duty.done,
                                  onChanged: (v) {
                                    ref.read(bazarRepositoryProvider).setDone(duty.id, v ?? false);
                                    triggerBackgroundSync(ref, groupId);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 18),
                                  onPressed: () {
                                    ref.read(bazarRepositoryProvider).deleteDuty(duty.id);
                                    triggerBackgroundSync(ref, groupId);
                                  },
                                ),
                              ],
                            )
                          : (duty.done ? const Icon(Icons.check_circle_rounded, color: AppColors.teal600) : null),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => _showAddSheet(context, ref, members),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.bazarAdd),
            )
          : null,
    );
  }

  Future<void> _showAddSheet(BuildContext context, WidgetRef ref, List<Member> members) async {
    if (members.isEmpty) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddBazarSheet(groupId: groupId, members: members),
    );
  }
}

class _AddBazarSheet extends ConsumerStatefulWidget {
  const _AddBazarSheet({required this.groupId, required this.members});

  final String groupId;
  final List<Member> members;

  @override
  ConsumerState<_AddBazarSheet> createState() => _AddBazarSheetState();
}

class _AddBazarSheetState extends ConsumerState<_AddBazarSheet> {
  late String _memberId = widget.members.first.id;
  DateTime _date = DateTime.now();
  final _noteController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(bazarRepositoryProvider).addDuty(
          groupId: widget.groupId,
          memberId: _memberId,
          date: _date,
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        );
    triggerBackgroundSync(ref, widget.groupId);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.bazarAdd, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _memberId,
            decoration: InputDecoration(labelText: l10n.bazarWhose),
            items: [for (final m in widget.members) DropdownMenuItem(value: m.id, child: Text(m.name))],
            onChanged: (v) => setState(() => _memberId = v ?? _memberId),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today_rounded, size: 18),
            label: Text(fmt.day(_date)),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48), alignment: Alignment.centerLeft),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(labelText: l10n.bazarNoteLabel, hintText: l10n.bazarNoteHint),
          ),
          const SizedBox(height: 18),
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
