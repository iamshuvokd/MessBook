import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/data/db/app_database.dart' hide Group;
import 'package:mess_manager/data/repositories/groups_repository.dart';
import 'package:mess_manager/domain/models/group.dart';

void main() {
  late AppDatabase db;
  late GroupsRepository groups;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    groups = GroupsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('a new mess defaults to a 30-minute poll reminder', () async {
    final group = await groups.createGroup(name: 'Test Mess', type: GroupType.mess);
    expect(group.pollReminderMinutes, 30);
  });

  test('the mess-wide poll reminder can be changed and persists', () async {
    final created = await groups.createGroup(name: 'Test Mess', type: GroupType.mess);

    await groups.updateGroup(created.copyWith(pollReminderMinutes: 15));

    expect((await groups.getGroup(created.id))!.pollReminderMinutes, 15);
  });

  test('reminders can be turned off entirely (0 minutes)', () async {
    final created = await groups.createGroup(name: 'Test Mess', type: GroupType.mess);

    await groups.updateGroup(created.copyWith(pollReminderMinutes: 0));

    expect((await groups.getGroup(created.id))!.pollReminderMinutes, 0);
  });

  test('the reminder setting survives a remote upsert, so it reaches every member', () async {
    // What a member's device does when it pulls the mess from the server.
    final now = DateTime.now();
    await groups.upsertFromRemote(Group(
      id: 'g-remote',
      name: 'Synced Mess',
      type: GroupType.mess,
      currencySymbol: '৳',
      monthStartDay: 1,
      mealEnabled: true,
      pollReminderMinutes: 20,
      archived: false,
      createdAt: now,
      updatedAt: now,
    ));

    expect((await groups.getGroup('g-remote'))!.pollReminderMinutes, 20);
  });

  test('low-balance threshold and auto meal-off default to off for a new mess', () async {
    final group = await groups.createGroup(name: 'Test Mess', type: GroupType.mess);
    expect(group.lowBalanceThresholdPaisa, 0, reason: '0 means no threshold set');
    expect(group.autoMealOffBelowThreshold, isFalse);
  });

  test('the manager can set a low-balance threshold and the auto meal-off toggle', () async {
    final created = await groups.createGroup(name: 'Test Mess', type: GroupType.mess);

    await groups.updateGroup(created.copyWith(
      lowBalanceThresholdPaisa: 20000, // ৳200
      autoMealOffBelowThreshold: true,
    ));

    final after = (await groups.getGroup(created.id))!;
    expect(after.lowBalanceThresholdPaisa, 20000);
    expect(after.autoMealOffBelowThreshold, isTrue);
  });

  test('threshold settings survive a remote upsert, so every member device agrees', () async {
    final now = DateTime.now();
    await groups.upsertFromRemote(Group(
      id: 'g-threshold',
      name: 'Synced Mess',
      type: GroupType.mess,
      currencySymbol: '৳',
      monthStartDay: 1,
      mealEnabled: true,
      lowBalanceThresholdPaisa: 15000,
      autoMealOffBelowThreshold: true,
      archived: false,
      createdAt: now,
      updatedAt: now,
    ));

    final g = (await groups.getGroup('g-threshold'))!;
    expect(g.lowBalanceThresholdPaisa, 15000);
    expect(g.autoMealOffBelowThreshold, isTrue);
  });

  test('renaming a mess keeps its reminder setting intact', () async {
    final created = await groups.createGroup(name: 'Old Name', type: GroupType.mess);
    await groups.updateGroup(created.copyWith(pollReminderMinutes: 45));

    final withReminder = (await groups.getGroup(created.id))!;
    await groups.updateGroup(withReminder.copyWith(name: 'New Name'));

    final after = (await groups.getGroup(created.id))!;
    expect(after.name, 'New Name');
    expect(after.pollReminderMinutes, 45);
  });

  group('deleteGroupLocal', () {
    /// Fills one mess with a row in every table that hangs off it, so a
    /// delete that forgets a table fails loudly instead of passing on an
    /// empty database.
    Future<String> seedFullMess() async {
      final g = await groups.createGroup(name: 'Doomed', type: GroupType.mess);
      final now = DateTime.now().millisecondsSinceEpoch;

      await db.into(db.members).insert(MembersCompanion.insert(
          id: 'm1', groupId: g.id, name: 'Shuvo', joinDate: now, updatedAt: now));
      await db.into(db.categories).insert(CategoriesCompanion.insert(
          id: 'c1', groupId: Value(g.id), name: 'Bazar', icon: 'cart', updatedAt: now));
      await db.into(db.expenses).insert(ExpensesCompanion.insert(
          id: 'e1', groupId: g.id, amountPaisa: 55000, date: now, categoryId: 'c1', updatedAt: now));
      await db.into(db.expensePayers).insert(
          ExpensePayersCompanion.insert(expenseId: 'e1', memberId: 'm1', amountPaidPaisa: 55000));
      await db.into(db.expenseSplits).insert(
          ExpenseSplitsCompanion.insert(expenseId: 'e1', memberId: 'm1', amountPaisa: 55000, splitType: 'meal'));
      await db.into(db.meals).insert(MealsCompanion.insert(
          id: 'meal1', groupId: g.id, memberId: 'm1', date: now, updatedAt: now));
      await db.into(db.deposits).insert(DepositsCompanion.insert(
          id: 'd1', groupId: g.id, memberId: 'm1', amountPaisa: 180000, date: now, updatedAt: now));
      await db.into(db.settlements).insert(SettlementsCompanion.insert(
          id: 's1', groupId: g.id, fromMemberId: 'm1', toMemberId: 'm1', amountPaisa: 5000, date: now, updatedAt: now));
      await db.into(db.mealSlots).insert(MealSlotsCompanion.insert(
          id: 'slot1', groupId: g.id, name: 'Lunch', updatedAt: now));
      await db.into(db.memberMealRoutines).insert(MemberMealRoutinesCompanion.insert(
          id: 'r1', memberId: 'm1', slotId: 'slot1', updatedAt: now));
      await db.into(db.mealLeaves).insert(MealLeavesCompanion.insert(
          id: 'lv1', memberId: 'm1', fromDate: now, toDate: now, updatedAt: now));
      await db.into(db.bazarDuties).insert(BazarDutiesCompanion.insert(
          id: 'b1', groupId: g.id, memberId: 'm1', date: now, updatedAt: now));
      await db.into(db.mealPolls).insert(MealPollsCompanion.insert(
          id: 'p1', groupId: g.id, date: now, type: 'count', closeAt: now, createdByMemberId: 'm1', updatedAt: now));
      await db.into(db.mealPollVotes).insert(
          MealPollVotesCompanion.insert(pollId: 'p1', memberId: 'm1', valueJson: '{}', votedAt: now));
      return g.id;
    }

    test('removes the mess and every row belonging to it', () async {
      final groupId = await seedFullMess();

      await groups.deleteGroupLocal(groupId);

      expect(await groups.getGroup(groupId), isNull);
      expect(await db.select(db.members).get(), isEmpty);
      // Default categories are global (groupId null) and shared by every
      // mess, so they must SURVIVE — only this mess's own are removed.
      final categories = await db.select(db.categories).get();
      expect(categories.where((c) => c.groupId == groupId), isEmpty);
      expect(categories.where((c) => c.groupId == null), isNotEmpty,
          reason: 'shared default categories must not be deleted with a mess');
      expect(await db.select(db.expenses).get(), isEmpty);
      expect(await db.select(db.meals).get(), isEmpty);
      expect(await db.select(db.deposits).get(), isEmpty);
      expect(await db.select(db.settlements).get(), isEmpty);
      expect(await db.select(db.mealSlots).get(), isEmpty);
      expect(await db.select(db.bazarDuties).get(), isEmpty);
      expect(await db.select(db.mealPolls).get(), isEmpty);
    });

    test('leaves no orphaned child rows behind', () async {
      final groupId = await seedFullMess();

      await groups.deleteGroupLocal(groupId);

      // These hang off a parent, not the group, so a delete that only
      // clears group-scoped tables strands them invisibly forever.
      expect(await db.select(db.expensePayers).get(), isEmpty, reason: 'orphaned expense payers');
      expect(await db.select(db.expenseSplits).get(), isEmpty, reason: 'orphaned expense splits');
      expect(await db.select(db.mealPollVotes).get(), isEmpty, reason: 'orphaned poll votes');
      expect(await db.select(db.memberMealRoutines).get(), isEmpty, reason: 'orphaned meal routines');
      expect(await db.select(db.mealLeaves).get(), isEmpty, reason: 'orphaned meal leaves');
    });

    test('does not touch a DIFFERENT mess on the same device', () async {
      final doomed = await seedFullMess();
      final keeper = await groups.createGroup(name: 'Keeper', type: GroupType.mess);
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.into(db.members).insert(MembersCompanion.insert(
          id: 'k1', groupId: keeper.id, name: 'Pijush', joinDate: now, updatedAt: now));

      await groups.deleteGroupLocal(doomed);

      expect(await groups.getGroup(keeper.id), isNotNull, reason: 'the other mess must survive');
      final survivors = await db.select(db.members).get();
      expect(survivors.map((m) => m.id), ['k1']);
    });
  });
}
