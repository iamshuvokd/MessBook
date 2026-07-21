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
}
