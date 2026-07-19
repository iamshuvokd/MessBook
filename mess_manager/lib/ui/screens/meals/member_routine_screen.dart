import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../domain/models/meal_routine.dart';
import '../../../domain/models/member_permission.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/sync_refresh_indicator.dart';
import 'meal_slots_screen.dart' show resolveSlotName;

class MemberRoutineScreen extends ConsumerStatefulWidget {
  const MemberRoutineScreen({super.key, required this.groupId, required this.memberId, required this.memberName});

  final String groupId;
  final String memberId;
  final String memberName;

  @override
  ConsumerState<MemberRoutineScreen> createState() => _MemberRoutineScreenState();
}

class _MemberRoutineScreenState extends ConsumerState<MemberRoutineScreen> {
  int? _selectedWeekday; // null = editing the "every day" defaults

  static const _weekdayKeys = [1, 2, 3, 4, 5, 6, 7]; // DateTime.weekday: Mon..Sun

  String _weekdayLabel(AppLocalizations l10n, int weekday) => switch (weekday) {
        1 => l10n.routineWeekdayMon,
        2 => l10n.routineWeekdayTue,
        3 => l10n.routineWeekdayWed,
        4 => l10n.routineWeekdayThu,
        5 => l10n.routineWeekdayFri,
        6 => l10n.routineWeekdaySat,
        _ => l10n.routineWeekdaySun,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != widget.groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(widget.groupId);
      }
    });

    final slots = ref.watch(activeSlotsOfSelectedGroupProvider).value ?? const [];
    final routines = ref.watch(routinesOfMemberProvider(widget.memberId)).value ?? const [];
    final leaves = ref.watch(leavesOfMemberProvider(widget.memberId)).value ?? const [];
    final canManage = ref.watch(canProvider(MemberPermission.mealsManage));
    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);

    bool effectiveEnabled(String slotId, int? weekday) {
      final matching = routines.where((r) => r.slotId == slotId && r.weekday == weekday);
      return matching.isNotEmpty && matching.first.enabled;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text(l10n.routineTitle(widget.memberName)),
      ),
      body: SyncRefreshIndicator(
        groupId: widget.groupId,
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.routineSub, style: const TextStyle(fontSize: 12.5, color: Colors.grey)),
          const SizedBox(height: 14),
          Row(
            children: [
              ChoiceChip(
                label: Text(l10n.routineDaily),
                selected: _selectedWeekday == null,
                onSelected: (_) => setState(() => _selectedWeekday = null),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final wd in _weekdayKeys)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(_weekdayLabel(l10n, wd)),
                            selected: _selectedWeekday == wd,
                            onSelected: (_) => setState(() => _selectedWeekday = wd),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Card(
            child: Column(
              children: [
                for (final slot in slots)
                  SwitchListTile(
                    title: Text(resolveSlotName(l10n, slot.defaultKey, slot.name)),
                    value: effectiveEnabled(slot.id, _selectedWeekday),
                    onChanged: canManage
                        ? (v) {
                            ref.read(mealRoutinesRepositoryProvider).setRoutine(
                                  memberId: widget.memberId,
                                  slotId: slot.id,
                                  weekday: _selectedWeekday,
                                  enabled: v,
                                );
                            triggerBackgroundSync(ref, widget.groupId);
                          }
                        : null,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Text(l10n.routineLeaveTitle, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700))),
              if (canManage)
                TextButton.icon(
                  onPressed: () => _addLeave(context),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(l10n.routineLeaveAdd),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (leaves.isEmpty)
            Padding(padding: const EdgeInsets.all(12), child: Text(l10n.routineLeaveEmpty, style: const TextStyle(fontSize: 12.5, color: Colors.grey)))
          else
            Card(
              child: Column(
                children: [
                  for (final leave in leaves) _LeaveTile(leave: leave, fmt: fmt, canManage: canManage, groupId: widget.groupId),
                ],
              ),
            ),
        ],
      ),
      ),
    );
  }

  Future<void> _addLeave(BuildContext context) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      initialDateRange: DateTimeRange(start: now, end: now.add(const Duration(days: 1))),
    );
    if (range == null) return;
    await ref.read(mealRoutinesRepositoryProvider).addLeave(
          memberId: widget.memberId,
          fromDate: range.start,
          toDate: range.end,
        );
    triggerBackgroundSync(ref, widget.groupId);
  }
}

class _LeaveTile extends ConsumerWidget {
  const _LeaveTile({required this.leave, required this.fmt, required this.canManage, required this.groupId});

  final MealLeave leave;
  final BdFormatter fmt;
  final bool canManage;
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.event_busy_rounded),
      title: Text('${fmt.day(leave.fromDate)} – ${fmt.day(leave.toDate)}'),
      subtitle: leave.note != null ? Text(leave.note!, style: const TextStyle(fontSize: 12)) : null,
      trailing: canManage
          ? IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: () {
                ref.read(mealRoutinesRepositoryProvider).deleteLeave(leave.id);
                triggerBackgroundSync(ref, groupId);
              },
            )
          : null,
    );
  }
}
