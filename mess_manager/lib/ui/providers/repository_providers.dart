import 'dart:async';

import 'package:drift/drift.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/l10n/app_localizations.dart';
import '../../data/db/app_database.dart' show Category, Month;
import '../../data/repositories/app_settings_repository.dart';
import '../../data/repositories/balances_repository.dart';
import '../../data/repositories/charts_repository.dart';
import '../../data/repositories/deposits_repository.dart';
import '../../data/repositories/expenses_repository.dart';
import '../../data/repositories/groups_repository.dart';
import '../../data/repositories/meal_routines_repository.dart';
import '../../data/repositories/meal_slots_repository.dart';
import '../../data/repositories/bazar_repository.dart';
import '../../data/repositories/meals_repository.dart';
import '../../data/repositories/members_repository.dart';
import '../../data/repositories/month_report_repository.dart';
import '../../data/repositories/months_repository.dart';
import '../../data/repositories/polls_repository.dart';
import '../../data/repositories/recurring_rules_repository.dart';
import '../../data/repositories/settlements_repository.dart';
import '../../data/services/api_client.dart';
import '../../data/services/app_lock_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/backup_service.dart';
import '../../data/services/billing_service.dart';
import '../../data/services/chat_service.dart';
import '../../data/services/contacts_service.dart';
import '../../data/services/drive_backup_service.dart';
import '../../data/services/meal_auto_fill_service.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/push_service.dart';
import '../../data/services/realtime_service.dart';
import '../../data/services/sync_api_service.dart';
import '../../data/services/sync_background_task.dart';
import '../../data/services/sync_service.dart';
import '../../domain/engines/balance_engine.dart';
import '../../domain/engines/debt_simplifier.dart';
import '../../domain/engines/meal_rate_engine.dart';
import '../../domain/models/deposit.dart';
import '../../domain/models/expense.dart';
import '../../domain/models/group.dart';
import '../../domain/models/ledger_purpose.dart';
import '../../domain/models/bazar_duty.dart';
import '../../domain/models/meal.dart';
import '../../domain/models/meal_poll.dart';
import '../../domain/models/meal_routine.dart';
import '../../domain/models/meal_slot.dart';
import '../../domain/models/member.dart';
import '../../domain/models/member_permission.dart';
import '../../domain/models/month_report.dart';
import '../../domain/models/recurring_rule.dart';
import '../../domain/models/settlement.dart';
import 'app_providers.dart';

final groupsRepositoryProvider = Provider<GroupsRepository>((ref) {
  return GroupsRepository(ref.watch(databaseProvider));
});

final membersRepositoryProvider = Provider<MembersRepository>((ref) {
  return MembersRepository(ref.watch(databaseProvider));
});

final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  return ExpensesRepository(ref.watch(databaseProvider));
});

final expensesOfSelectedGroupProvider = StreamProvider.autoDispose<List<ExpenseDetail>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const Stream.empty();
  return ref.watch(expensesRepositoryProvider).watchExpenses(groupId);
});

/// Categories visible to a group: global defaults (groupId null) + any
/// group-specific ones, meal-flagged categories first for the meal grid.
final categoriesForSelectedGroupProvider = StreamProvider.autoDispose<List<Category>>((ref) {
  final db = ref.watch(databaseProvider);
  final groupId = ref.watch(selectedGroupIdProvider);
  final query = db.select(db.categories)
    ..where((c) => groupId == null ? c.groupId.isNull() : (c.groupId.isNull() | c.groupId.equals(groupId)))
    ..orderBy([(c) => OrderingTerm.asc(c.updatedAt)]);
  return query.watch();
});

final contactsServiceProvider = Provider<ContactsService>((ref) => ContactsService());

final activeGroupsProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  return ref.watch(groupsRepositoryProvider).watchActiveGroups();
});

final archivedGroupsProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  return ref.watch(groupsRepositoryProvider).watchArchivedGroups();
});

/// Currently selected group id (in-memory; wizard/list screens set this).
class SelectedGroupController extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? groupId) => state = groupId;
}

final selectedGroupIdProvider = NotifierProvider<SelectedGroupController, String?>(
  SelectedGroupController.new,
);

final membersOfSelectedGroupProvider = StreamProvider.autoDispose<List<Member>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const Stream.empty();
  return ref.watch(membersRepositoryProvider).watchMembers(groupId);
});

/// Whether this group has ever had a role explicitly assigned. Until then,
/// permission checks stay fully permissive so existing single-device groups
/// keep working exactly as before (roles are opt-in, per user decision).
final rolesConfiguredProvider = Provider.autoDispose<bool>((ref) {
  final members = ref.watch(membersOfSelectedGroupProvider).value ?? const [];
  return members.any((m) => m.role != MemberRole.member);
});

/// Which member the person holding the phone is "acting as" right now — a
/// lightweight, no-login stand-in for real per-person sign-in (arrives with
/// the online layer). Persisted per group so switching groups doesn't leak
/// the selection.
final actingAsMemberIdProvider = StreamProvider.autoDispose<String?>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return Stream.value(null);
  return ref.watch(appSettingsRepositoryProvider).watch('actingAs_$groupId');
});

/// Resolves to the App Admin by default (so the app stays fully usable for
/// whoever set roles up) until the operator deliberately switches to
/// preview the app as someone else.
final actingAsMemberProvider = Provider.autoDispose<Member?>((ref) {
  final members = ref.watch(membersOfSelectedGroupProvider).value ?? const [];
  final chosenId = ref.watch(actingAsMemberIdProvider).value;
  if (chosenId != null) {
    final matching = members.where((m) => m.id == chosenId);
    if (matching.isNotEmpty) return matching.first;
  }
  final admins = members.where((m) => m.role == MemberRole.appAdmin);
  return admins.isEmpty ? null : admins.first;
});

/// Whether the currently acting-as member may perform [permission]. Stays
/// permissive when roles haven't been configured. Once roles ARE configured,
/// an unresolved acting-as identity denies rather than grants — a
/// still-syncing/unset identity must never fall open to full access.
final canProvider = Provider.autoDispose.family<bool, MemberPermission>((ref, permission) {
  if (!ref.watch(rolesConfiguredProvider)) return true;
  final actingAs = ref.watch(actingAsMemberProvider);
  return actingAs?.hasPermission(permission) ?? false;
});

final depositsRepositoryProvider = Provider<DepositsRepository>((ref) {
  return DepositsRepository(ref.watch(databaseProvider));
});

final bazarRepositoryProvider = Provider<BazarRepository>((ref) {
  return BazarRepository(ref.watch(databaseProvider));
});

final bazarDutiesOfSelectedGroupProvider = StreamProvider.autoDispose<List<BazarDuty>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const Stream.empty();
  return ref.watch(bazarRepositoryProvider).watchDuties(groupId);
});

/// The soonest not-yet-done duty on or after today — surfaced on the
/// dashboard so whoever's up for bazar next sees it at a glance.
final nextBazarDutyProvider = Provider.autoDispose<BazarDuty?>((ref) {
  final duties = ref.watch(bazarDutiesOfSelectedGroupProvider).value ?? const [];
  final today = DateTime.now();
  final todayKey = DateTime(today.year, today.month, today.day);
  final upcoming = duties.where((d) => !d.done && !d.date.isBefore(todayKey)).toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return upcoming.isEmpty ? null : upcoming.first;
});

final settlementsRepositoryProvider = Provider<SettlementsRepository>((ref) {
  return SettlementsRepository(ref.watch(databaseProvider));
});

final balancesRepositoryProvider = Provider<BalancesRepository>((ref) {
  return BalancesRepository(ref.watch(databaseProvider));
});

final depositsOfSelectedGroupProvider = StreamProvider.autoDispose<List<Deposit>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const Stream.empty();
  return ref.watch(depositsRepositoryProvider).watchDeposits(groupId);
});

final settlementsOfSelectedGroupProvider = StreamProvider.autoDispose<List<Settlement>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const Stream.empty();
  return ref.watch(settlementsRepositoryProvider).watchSettlements(groupId);
});

/// Recomputes whenever expenses, deposits or settlements change for the
/// selected group (each dependency is watched purely to trigger a refresh).
final memberBalancesProvider = FutureProvider.autoDispose<List<MemberBalance>>((ref) async {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const [];
  ref.watch(expensesOfSelectedGroupProvider);
  ref.watch(depositsOfSelectedGroupProvider);
  ref.watch(settlementsOfSelectedGroupProvider);
  return ref.watch(balancesRepositoryProvider).computeBalances(groupId);
});

final simplifiedDebtsProvider = FutureProvider.autoDispose<List<DebtTransaction>>((ref) async {
  final balances = await ref.watch(memberBalancesProvider.future);
  final netByMember = {for (final b in balances) b.memberId: b.net};
  return DebtSimplifier.simplify(netByMember);
});

/// The currently-selected group's full record (null while loading or when
/// nothing is selected). Screens use this to check `mealLedgerSeparate`.
final selectedGroupProvider = Provider.autoDispose<Group?>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return null;
  final groups = ref.watch(activeGroupsProvider).value ?? const [];
  final matching = groups.where((g) => g.id == groupId);
  return matching.isEmpty ? null : matching.first;
});

/// Per-ledger balances for groups with `mealLedgerSeparate` on. The
/// combined [memberBalancesProvider] above stays the source of truth for
/// single-ledger groups.
final memberBalancesByLedgerProvider =
    FutureProvider.autoDispose.family<List<MemberBalance>, LedgerPurpose>((ref, ledger) async {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const [];
  ref.watch(expensesOfSelectedGroupProvider);
  ref.watch(depositsOfSelectedGroupProvider);
  ref.watch(settlementsOfSelectedGroupProvider);
  return ref.watch(balancesRepositoryProvider).computeBalances(groupId, ledger: ledger);
});

/// Balances as the meal module should show them: the meal ledger when the
/// mess keeps meal money separate, otherwise the combined balance — which is
/// the common case (everyone deposits into one pool and bazar is spent from
/// it, so "remaining" is deposits minus what they ate).
final mealLedgerBalancesProvider = FutureProvider.autoDispose<List<MemberBalance>>((ref) async {
  final separate = ref.watch(selectedGroupProvider)?.mealLedgerSeparate ?? false;
  if (separate) {
    return ref.watch(memberBalancesByLedgerProvider(LedgerPurpose.meal).future);
  }
  return ref.watch(memberBalancesProvider.future);
});

final simplifiedDebtsByLedgerProvider =
    FutureProvider.autoDispose.family<List<DebtTransaction>, LedgerPurpose>((ref, ledger) async {
  final balances = await ref.watch(memberBalancesByLedgerProvider(ledger).future);
  final netByMember = {for (final b in balances) b.memberId: b.net};
  return DebtSimplifier.simplify(netByMember);
});

final mealsRepositoryProvider = Provider<MealsRepository>((ref) {
  return MealsRepository(ref.watch(databaseProvider));
});

final mealSlotsRepositoryProvider = Provider<MealSlotsRepository>((ref) {
  return MealSlotsRepository(ref.watch(databaseProvider));
});

final mealRoutinesRepositoryProvider = Provider<MealRoutinesRepository>((ref) {
  return MealRoutinesRepository(ref.watch(databaseProvider));
});

final mealAutoFillServiceProvider = Provider<MealAutoFillService>((ref) {
  return MealAutoFillService(
    ref.watch(membersRepositoryProvider),
    ref.watch(mealSlotsRepositoryProvider),
    ref.watch(mealRoutinesRepositoryProvider),
    ref.watch(mealsRepositoryProvider),
  );
});

final pollsRepositoryProvider = Provider<PollsRepository>((ref) {
  return PollsRepository(
    ref.watch(databaseProvider),
    ref.watch(membersRepositoryProvider),
    ref.watch(mealSlotsRepositoryProvider),
    ref.watch(mealRoutinesRepositoryProvider),
    ref.watch(mealsRepositoryProvider),
  );
});

final slotsOfSelectedGroupProvider = StreamProvider.autoDispose<List<MealSlot>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const Stream.empty();
  return ref.watch(mealSlotsRepositoryProvider).watchSlots(groupId);
});

final activeSlotsOfSelectedGroupProvider = StreamProvider.autoDispose<List<MealSlot>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const Stream.empty();
  return ref.watch(mealSlotsRepositoryProvider).watchSlots(groupId, activeOnly: true);
});

final pollsOfSelectedGroupProvider = StreamProvider.autoDispose<List<MealPoll>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const Stream.empty();
  return ref.watch(pollsRepositoryProvider).watchPolls(groupId);
});

/// Keeps past-due polls closing while a meal/poll screen is open. Sweeps
/// immediately on mount and then on a short timer — without the timer a poll
/// sitting open when its close time passes never closes until the app is
/// restarted or the grid re-entered, which is exactly the "I set a closing
/// time but nothing happened" symptom. Idempotent (an already-closed poll is
/// skipped), and depends only on the stable group id so the sweep itself
/// can't retrigger it. Syncs when it actually closes something so other
/// members see the applied results.
final autoCloseDuePollsProvider = Provider.autoDispose<void>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return;

  Future<void> sweep() async {
    try {
      final closed = await ref.read(pollsRepositoryProvider).closeDuePolls(groupId);
      if (closed > 0) {
        final groups = ref.read(activeGroupsProvider).value ?? const [];
        if (groups.any((g) => g.id == groupId && g.isOnline)) {
          unawaited(ref.read(syncServiceProvider).syncGroup(groupId).catchError((_) {}));
        }
      }
    } catch (_) {
      // Best-effort background housekeeping; never surfaces to the user.
    }
  }

  sweep();
  final timer = Timer.periodic(const Duration(seconds: 30), (_) => sweep());
  ref.onDispose(timer.cancel);
});

/// Today's open poll for the selected group, if any.
final todaysOpenPollProvider = Provider.autoDispose<MealPoll?>((ref) {
  final polls = ref.watch(pollsOfSelectedGroupProvider).value ?? const [];
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final matching = polls.where((p) => !p.closed && p.date == today);
  return matching.isEmpty ? null : matching.first;
});

final pollVotesProvider = StreamProvider.autoDispose.family<List<PollVote>, String>((ref, pollId) {
  return ref.watch(pollsRepositoryProvider).watchVotes(pollId);
});

final pollPendingMembersProvider = FutureProvider.autoDispose.family<List<String>, String>((ref, pollId) async {
  ref.watch(pollVotesProvider(pollId));
  return ref.watch(pollsRepositoryProvider).pendingMemberIds(pollId);
});

final routinesOfMemberProvider = StreamProvider.autoDispose.family<List<MemberMealRoutine>, String>((ref, memberId) {
  return ref.watch(mealRoutinesRepositoryProvider).watchRoutines(memberId);
});

final leavesOfMemberProvider = StreamProvider.autoDispose.family<List<MealLeave>, String>((ref, memberId) {
  return ref.watch(mealRoutinesRepositoryProvider).watchLeaves(memberId);
});

/// Calendar month currently shown in the meal grid / reports. Month-window
/// (custom start day) support arrives with M6; this uses plain calendar months.
class SelectedMonthController extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  void set(DateTime month) => state = DateTime(month.year, month.month, 1);
  void previous() => state = DateTime(state.year, state.month - 1, 1);
  void next() => state = DateTime(state.year, state.month + 1, 1);
}

final selectedMonthProvider = NotifierProvider<SelectedMonthController, DateTime>(SelectedMonthController.new);

/// Meals recorded for the actual current day (independent of which month the
/// grid is showing) — backs the meal manager's "today's total meals" summary.
final todaysMealsProvider = StreamProvider.autoDispose<List<Meal>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const Stream.empty();
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  return ref.watch(mealsRepositoryProvider).watchMealsInRange(groupId, start, end);
});

final mealsOfSelectedMonthProvider = StreamProvider.autoDispose<List<Meal>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  final month = ref.watch(selectedMonthProvider);
  if (groupId == null) return const Stream.empty();
  final start = DateTime(month.year, month.month, 1);
  final end = DateTime(month.year, month.month + 1, 1);
  return ref.watch(mealsRepositoryProvider).watchMealsInRange(groupId, start, end);
});

/// Live meal rate + per-member meal bills for the selected month, computed
/// from meal-flagged category expenses and the meal grid.
final mealRateProvider = Provider.autoDispose<MealRateResult>((ref) {
  final month = ref.watch(selectedMonthProvider);
  final expenses = ref.watch(expensesOfSelectedGroupProvider).value ?? const [];
  final meals = ref.watch(mealsOfSelectedMonthProvider).value ?? const [];
  final members = ref.watch(membersOfSelectedGroupProvider).value ?? const [];

  final monthEnd = DateTime(month.year, month.month + 1, 1);
  final totalMealExpense = expenses
      .where((e) => e.categoryIsMeal && !e.expense.date.isBefore(month) && e.expense.date.isBefore(monthEnd))
      .fold<int>(0, (a, e) => a + e.expense.amountPaisa);

  final mealCounts = <String, double>{for (final m in members) m.id: 0};
  for (final meal in meals) {
    mealCounts[meal.memberId] = (mealCounts[meal.memberId] ?? 0) + meal.total;
  }

  return MealRateEngine.compute(totalMealExpensePaisa: totalMealExpense, memberMealCounts: mealCounts);
});

final monthsRepositoryProvider = Provider<MonthsRepository>((ref) {
  return MonthsRepository(ref.watch(databaseProvider));
});

final monthReportRepositoryProvider = Provider<MonthReportRepository>((ref) {
  return MonthReportRepository(ref.watch(databaseProvider));
});

final monthsOfSelectedGroupProvider = StreamProvider.autoDispose<List<Month>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const Stream.empty();
  return ref.watch(monthsRepositoryProvider).watchMonths(groupId);
});

/// Whether the currently-selected month has already been closed for the
/// selected group (drives the "locked" banner and disables edits).
final isSelectedMonthClosedProvider = Provider.autoDispose<bool>((ref) {
  final months = ref.watch(monthsOfSelectedGroupProvider).value ?? const [];
  final key = yearMonthKey(ref.watch(selectedMonthProvider));
  final matching = months.where((m) => m.yearMonth == key);
  return matching.isNotEmpty && matching.first.closedAt != null;
});

/// Whether the calendar month containing [date] is closed (general ledger)
/// for the selected group — used to block back-dated edits into a locked
/// month from the expense / deposit entry screens.
final isMonthClosedForDateProvider = Provider.autoDispose.family<bool, DateTime>((ref, date) {
  final months = ref.watch(monthsOfSelectedGroupProvider).value ?? const [];
  final key = yearMonthKey(date);
  final matching = months.where((m) => m.yearMonth == key);
  return matching.isNotEmpty && matching.first.closedAt != null;
});

/// Per-ledger closed state, for groups that keep the meal ledger separate.
final isSelectedMonthClosedByLedgerProvider = Provider.autoDispose.family<bool, LedgerPurpose>((ref, ledger) {
  final months = ref.watch(monthsOfSelectedGroupProvider).value ?? const [];
  final key = yearMonthKey(ref.watch(selectedMonthProvider));
  final matching = months.where((m) => m.yearMonth == key);
  if (matching.isEmpty) return false;
  return ledger == LedgerPurpose.meal ? matching.first.mealClosedAt != null : matching.first.closedAt != null;
});

final monthReportProvider = FutureProvider.autoDispose<MonthReport>((ref) async {
  final groupId = ref.watch(selectedGroupIdProvider);
  final month = ref.watch(selectedMonthProvider);
  if (groupId == null) {
    return MonthReport(yearMonth: yearMonthKey(month), totalSpentPaisa: 0, totalMeals: 0, mealRatePaisaX100: 0, rows: const []);
  }
  // Recompute whenever the underlying ledgers change.
  ref.watch(expensesOfSelectedGroupProvider);
  ref.watch(mealsOfSelectedMonthProvider);
  ref.watch(depositsOfSelectedGroupProvider);
  ref.watch(settlementsOfSelectedGroupProvider);
  ref.watch(monthsOfSelectedGroupProvider);
  return ref.watch(monthReportRepositoryProvider).compute(groupId, month);
});

/// Per-ledger month report, for groups that keep the meal ledger separate.
final monthReportByLedgerProvider =
    FutureProvider.autoDispose.family<MonthReport, LedgerPurpose>((ref, ledger) async {
  final groupId = ref.watch(selectedGroupIdProvider);
  final month = ref.watch(selectedMonthProvider);
  if (groupId == null) {
    return MonthReport(yearMonth: yearMonthKey(month), totalSpentPaisa: 0, totalMeals: 0, mealRatePaisaX100: 0, rows: const []);
  }
  ref.watch(expensesOfSelectedGroupProvider);
  ref.watch(mealsOfSelectedMonthProvider);
  ref.watch(depositsOfSelectedGroupProvider);
  ref.watch(settlementsOfSelectedGroupProvider);
  ref.watch(monthsOfSelectedGroupProvider);
  return ref.watch(monthReportRepositoryProvider).compute(groupId, month, ledger: ledger);
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository(ref.watch(databaseProvider));
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(databaseProvider));
});

/// The nightly meal-reminder time as stored (`HH:mm`), defaulting to 22:00.
final dailyMealReminderProvider = StreamProvider.autoDispose<String>((ref) {
  return ref
      .watch(appSettingsRepositoryProvider)
      .watch(dailyMealReminderSettingKey)
      .map((v) => v ?? defaultDailyMealReminder);
});

final lastBackupAtProvider = StreamProvider.autoDispose<DateTime?>((ref) {
  return ref.watch(appSettingsRepositoryProvider).watch(lastBackupAtSettingKey).map(
        (value) => value == null ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(value)),
      );
});

final appLockServiceProvider = Provider<AppLockService>((ref) {
  return AppLockService(ref.watch(appSettingsRepositoryProvider));
});

/// Whether app lock is turned on in settings (persisted).
final appLockEnabledProvider = StreamProvider.autoDispose<bool>((ref) {
  return ref.watch(appSettingsRepositoryProvider).watch(appLockEnabledSettingKey).map((v) => v == 'true');
});

/// Whether the CURRENT app session has been unlocked yet. Resets to false
/// every cold start; deliberately not persisted.
class SessionUnlockedController extends Notifier<bool> {
  @override
  bool build() => false;

  void unlock() => state = true;
}

final sessionUnlockedProvider = NotifierProvider<SessionUnlockedController, bool>(SessionUnlockedController.new);

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

final recurringRulesRepositoryProvider = Provider<RecurringRulesRepository>((ref) {
  return RecurringRulesRepository(ref.watch(databaseProvider));
});

final recurringRulesOfSelectedGroupProvider = StreamProvider.autoDispose<List<RecurringRule>>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const Stream.empty();
  return ref.watch(recurringRulesRepositoryProvider).watchRules(groupId);
});

/// One-shot app-open side effects: generate any due recurring-expense
/// instances, (re)schedule the daily/month-close reminders, and fire the
/// backup-overdue notification if applicable. Deliberately not autoDispose
/// so it only ever runs once per app process, regardless of how many
/// screens watch it.
final appOpenTasksProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(databaseProvider);
  final recurringRepo = ref.watch(recurringRulesRepositoryProvider);
  final autoFill = ref.watch(mealAutoFillServiceProvider);
  final polls = ref.watch(pollsRepositoryProvider);
  final notifications = ref.watch(notificationServiceProvider);
  final settings = ref.watch(appSettingsRepositoryProvider);
  final l10n = lookupAppLocalizations(ref.watch(localeProvider));

  final groups = await (db.select(db.groups)..where((g) => g.archived.equals(false))).get();
  for (final group in groups) {
    await recurringRepo.generateDueInstances(group.id);
    if (group.mealEnabled) {
      await polls.closeDuePolls(group.id);
      await autoFill.fillToday(group.id);
    }
  }

  await notifications.requestPermission();

  // Poll close reminders, scheduled on EVERY member's device (not just the
  // creator's) from the mess-wide lead time, so everyone gets nudged to vote
  // before a poll closes. 0 minutes means the mess turned reminders off.
  for (final group in groups) {
    if (!group.mealEnabled || group.pollReminderMinutes <= 0) continue;
    final openPolls = (await polls.watchPolls(group.id).first).where((p) => !p.closed);
    for (final poll in openPolls) {
      final remindAt = poll.closeAt.subtract(Duration(minutes: group.pollReminderMinutes));
      if (remindAt.isAfter(DateTime.now())) {
        await notifications.schedulePollCloseReminder(
          pollId: poll.id,
          remindAt: remindAt,
          title: l10n.notifyPollReminderTitle,
          body: l10n.notifyPollReminderBody,
        );
      }
    }
  }

  final mealReminderAt = parseReminderTime(await settings.get(dailyMealReminderSettingKey));
  await notifications.scheduleDailyMealReminder(
    hour: mealReminderAt.hour,
    minute: mealReminderAt.minute,
    title: l10n.notifyMealReminderTitle,
    body: l10n.notifyMealReminderBody,
  );

  final now = DateTime.now();
  final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  await notifications.scheduleMonthCloseReminder(
    lastDayOfMonth: lastDayOfMonth,
    title: l10n.notifyMonthCloseTitle,
    body: l10n.notifyMonthCloseBody,
  );

  final lastBackupStr = await settings.get(lastBackupAtSettingKey);
  final lastBackup = lastBackupStr == null ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(lastBackupStr));
  final overdue = lastBackup == null || now.difference(lastBackup).inDays >= 14;
  if (overdue) {
    final lastPromptedStr = await settings.get(backupOverduePromptedAtSettingKey);
    final lastPrompted = lastPromptedStr == null ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(lastPromptedStr));
    final alreadyPromptedToday = lastPrompted != null &&
        lastPrompted.year == now.year &&
        lastPrompted.month == now.month &&
        lastPrompted.day == now.day;
    if (!alreadyPromptedToday) {
      await notifications.showBackupOverdueNow(
        title: l10n.notifyBackupOverdueTitle,
        body: l10n.notifyBackupOverdueBody,
      );
      await settings.set(backupOverduePromptedAtSettingKey, now.millisecondsSinceEpoch.toString());
    }
  }

  // Online sync: registering the periodic task is safe to call every app
  // open (ExistingPeriodicWorkPolicy.keep leaves an already-scheduled task
  // alone). The immediate sync is best-effort and silently skipped when
  // nobody's signed in — offline-only use never touches the network.
  await schedulePeriodicSync();
  if (await ref.watch(authServiceProvider).isSignedIn) {
    await ref.watch(syncServiceProvider).syncAllOnlineGroups();
    await ref.watch(pushServiceProvider).initialize();
  }
});

final billingServiceProvider = Provider<BillingService>((ref) => BillingService());

final driveBackupServiceProvider = Provider<DriveBackupService>((ref) {
  return DriveBackupService(ref.watch(backupServiceProvider));
});

/// Single switch for the pre-monetization launch: every feature gated behind
/// [premiumUnlockedProvider] (unlimited groups, full history, PDF/CSV,
/// charts, Drive backup, recurring expenses, receipt photos) is unlocked for
/// everyone, no purchase required. The billing/paywall/Drive-backup code
/// underneath is untouched — flip this to `false` once ready to sell premium
/// and the real purchase-status check below takes back over.
const kAllFeaturesFreeForNow = true;

/// Whether the one-time premium unlock has been purchased (persisted locally
/// once the purchase stream confirms it — see [purchaseStreamListenerProvider]).
final premiumUnlockedProvider = StreamProvider.autoDispose<bool>((ref) {
  if (kAllFeaturesFreeForNow) return Stream.value(true);
  return ref.watch(appSettingsRepositoryProvider).watch(premiumUnlockedSettingKey).map((v) => v == 'true');
});

final driveAutoBackupEnabledProvider = StreamProvider.autoDispose<bool>((ref) {
  return ref.watch(appSettingsRepositoryProvider).watch(driveAutoBackupEnabledSettingKey).map((v) => v == 'true');
});

/// Subscribes to the IAP purchase stream for the lifetime of the app
/// (non-autoDispose — watched once from [MessManagerApp]'s build), persisting
/// `premium_unlock` purchases/restores to settings and acking each purchase.
final purchaseStreamListenerProvider = Provider<void>((ref) {
  final billing = ref.watch(billingServiceProvider);
  final settings = ref.watch(appSettingsRepositoryProvider);
  final sub = billing.purchaseStream.listen((purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID == BillingService.premiumProductId &&
          (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored)) {
        await settings.set(premiumUnlockedSettingKey, 'true');
      }
      await billing.completePurchase(purchase);
    }
  });
  ref.onDispose(sub.cancel);
});

final chartsRepositoryProvider = Provider<ChartsRepository>((ref) {
  return ChartsRepository(ref.watch(databaseProvider));
});

final categoryBreakdownProvider = FutureProvider.autoDispose<List<CategorySlice>>((ref) async {
  final groupId = ref.watch(selectedGroupIdProvider);
  final month = ref.watch(selectedMonthProvider);
  if (groupId == null) return const [];
  ref.watch(expensesOfSelectedGroupProvider);
  return ref.watch(chartsRepositoryProvider).categoryBreakdown(groupId, month);
});

final monthlyTrendProvider = FutureProvider.autoDispose<List<MonthlyTotal>>((ref) async {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return const [];
  ref.watch(expensesOfSelectedGroupProvider);
  return ref.watch(chartsRepositoryProvider).monthlyTrend(groupId);
});

// ===================== Online sync (accounts + bring-online/join) =========

/// Falls back to the Android emulator's host-loopback alias until the
/// server has a real domain (DigitalOcean deploy is a later step);
/// overridable per-install via the `apiBaseUrl` setting (Account screen).
const kDefaultApiBaseUrl = 'http://10.0.2.2:3000';

final apiBaseUrlProvider = StreamProvider<String>((ref) {
  return ref.watch(appSettingsRepositoryProvider).watch(apiBaseUrlSettingKey).map((v) => v ?? kDefaultApiBaseUrl);
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider).value ?? kDefaultApiBaseUrl;
  return ApiClient(ref.watch(secureStorageProvider), baseUrlProvider: () => baseUrl);
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(apiClientProvider), ref.watch(secureStorageProvider));
});

final syncApiServiceProvider = Provider<SyncApiService>((ref) {
  return SyncApiService(ref.watch(apiClientProvider), ref.watch(databaseProvider));
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref.watch(syncApiServiceProvider), ref.watch(groupsRepositoryProvider), ref.watch(appSettingsRepositoryProvider));
});

final pushServiceProvider = Provider<PushService>((ref) {
  return PushService(
    FirebaseMessaging.instance,
    ref.watch(apiClientProvider),
    ref.watch(notificationServiceProvider),
    ref.watch(syncServiceProvider),
  );
});

/// One connection per time the chat screen is open — created fresh and torn
/// down with it (autoDispose), never kept alive in the background.
final chatServiceProvider = Provider.autoDispose<ChatService>((ref) {
  final service = ChatService(ref.watch(apiClientProvider));
  ref.onDispose(service.dispose);
  return service;
});

/// One connection per time a group is being actively viewed — see
/// [foregroundGroupSyncProvider], which is the sole owner of this
/// connection's lifecycle (connect/join/dispose all happen there).
final realtimeServiceProvider = Provider.autoDispose<RealtimeService>((ref) {
  final service = RealtimeService(ref.watch(apiClientProvider));
  ref.onDispose(service.dispose);
  return service;
});

/// Near-live foreground sync: while any on-screen widget watches this, the
/// selected online group is re-synced on a short interval (and once
/// immediately), so a member passively viewing the meal grid, dashboard,
/// etc. sees other people's changes within seconds instead of only on app
/// open / manual pull. Being `autoDispose`, the timer is torn down the
/// moment the last watching screen leaves — nothing runs in the background.
///
/// A live Socket.IO connection ([realtimeServiceProvider]) nudges an
/// immediate pull the moment another device's push lands server-side
/// (`dataChanged` event), so changes usually show up in ~1s instead of
/// waiting for the timer below. The timer stays as a resilience fallback —
/// it covers the gap while the socket is (re)connecting or unreachable,
/// matching the app's offline-first "degrade gracefully" doctrine.
/// Whether the selected group is online (has an invite code). Watched by
/// [foregroundGroupSyncProvider] to decide when to open the live socket.
/// Crucially it exposes a *bool*: even though it re-reads `activeGroups`
/// (which every sync rewrites), the value only changes false→true once, so
/// a watcher is re-run exactly on that flip — not on every groups-table
/// write — which is what avoids the infinite sync loop while still letting
/// the socket open once the group list has actually loaded.
final selectedGroupOnlineProvider = Provider.autoDispose<bool>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return false;
  final groups = ref.watch(activeGroupsProvider).value ?? const [];
  return groups.any((g) => g.id == groupId && g.isOnline);
});

final foregroundGroupSyncProvider = Provider.autoDispose<void>((ref) {
  final groupId = ref.watch(selectedGroupIdProvider);
  if (groupId == null) return;

  // Watch the derived online BOOL (not activeGroups directly). This re-runs
  // the provider exactly when the group's online status flips true — which
  // is the fix for the live socket: previously the socket-open decision was
  // read once at build time, so if activeGroups hadn't loaded yet when the
  // screen mounted, the socket never opened and live updates silently fell
  // back to the 15s poll. Watching a bool that only flips once means the
  // socket opens as soon as the group list loads, without the infinite loop
  // that watching activeGroups directly would cause.
  final online = ref.watch(selectedGroupOnlineProvider);

  final sync = ref.read(syncServiceProvider);
  void tick() {
    // Re-read fresh so the fallback timer stays correct regardless.
    final groups = ref.read(activeGroupsProvider).value ?? const [];
    if (groups.any((g) => g.id == groupId && g.isOnline)) {
      unawaited(sync.pullGroup(groupId).catchError((_) {}));
    }
  }

  tick(); // refresh immediately on entering a screen
  final timer = Timer.periodic(const Duration(seconds: 15), (_) => tick());
  ref.onDispose(timer.cancel);

  if (online) {
    final realtime = ref.read(realtimeServiceProvider);
    unawaited(realtime.connectAndJoin(groupId));
    final sub = realtime.dataChanged.listen((_) => tick());
    ref.onDispose(sub.cancel);
  }
});

/// Fire-and-forget: syncs [groupId] right after a write worth other
/// members seeing promptly (a new poll, a cast vote) instead of waiting for
/// the next periodic/app-open sync. Never blocks or surfaces an error to
/// the caller — a no-op for groups that aren't online yet.
void triggerBackgroundSync(WidgetRef ref, String groupId) {
  final groups = ref.read(activeGroupsProvider).value ?? const [];
  final matching = groups.where((g) => g.id == groupId);
  if (matching.isEmpty || !matching.first.isOnline) return;
  ref.read(syncServiceProvider).syncGroup(groupId).catchError((_) {});
}

/// The signed-in account, if any — loaded once from secure storage and kept
/// in sync with explicit sign-in/sign-out actions. Signing out of an
/// account never touches local mess data (offline-first: every group stays
/// fully usable with nobody signed in).
class AuthController extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() => ref.watch(authServiceProvider).currentUser;

  Future<void> signIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(authServiceProvider).signIn());
    // Push registration is normally kicked off once at app open, but that
    // already ran before this sign-in happened this session — start it now
    // too instead of waiting for the next app restart.
    if (state.value != null) {
      unawaited(ref.read(pushServiceProvider).initialize());
      // Restore any messes this account already owns/joined online so a
      // returning user lands on their existing data instead of being sent
      // through "create a new mess" — awaited so callers checking the
      // local group list right after sign-in already see it populated.
      await ref.read(syncServiceProvider).restoreOnlineGroups().catchError((_) => 0);
    }
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    state = const AsyncValue.data(null);
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthUser?>(AuthController.new);

final isSignedInProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).value != null;
});
