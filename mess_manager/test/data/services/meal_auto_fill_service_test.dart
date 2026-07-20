import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/data/db/app_database.dart';
import 'package:mess_manager/data/repositories/groups_repository.dart';
import 'package:mess_manager/data/repositories/meal_routines_repository.dart';
import 'package:mess_manager/data/repositories/meal_slots_repository.dart';
import 'package:mess_manager/data/repositories/meals_repository.dart';
import 'package:mess_manager/data/repositories/members_repository.dart';
import 'package:mess_manager/data/services/meal_auto_fill_service.dart';
import 'package:mess_manager/domain/models/group.dart';

void main() {
  late AppDatabase db;
  late GroupsRepository groups;
  late MembersRepository members;
  late MealSlotsRepository slots;
  late MealRoutinesRepository routines;
  late MealsRepository meals;
  late MealAutoFillService autoFill;

  late String groupId;
  late String breakfastSlotId;

  final today = DateTime.now();

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    groups = GroupsRepository(db);
    members = MembersRepository(db);
    slots = MealSlotsRepository(db);
    routines = MealRoutinesRepository(db);
    meals = MealsRepository(db);
    autoFill = MealAutoFillService(members, slots, routines, meals);

    final group = await groups.createGroup(name: 'Test Mess', type: GroupType.mess, mealEnabled: true);
    groupId = group.id;
    breakfastSlotId = (await slots.activeSlots(groupId)).firstWhere((s) => s.defaultKey == 'breakfast').id;
  });

  tearDown(() async {
    await db.close();
  });

  test('fills today for a member with a standing routine and no existing entry', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    await routines.setRoutine(memberId: member.id, slotId: breakfastSlotId, enabled: true);

    final filled = await autoFill.fillToday(groupId, today: today);

    expect(filled, 1);
    final row = await meals.getMealRow(groupId, member.id, today);
    expect(row, isNotNull);
    expect(row!.count, 0.5);
    expect(row.slotsJson, isNotNull);
  });

  test('never overwrites a day that already has an entry (manual or otherwise)', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    await routines.setRoutine(memberId: member.id, slotId: breakfastSlotId, enabled: true);
    await meals.setMeal(groupId: groupId, memberId: member.id, date: today, count: 5, guestCount: 0);

    final filled = await autoFill.fillToday(groupId, today: today);

    expect(filled, 0);
    final row = await meals.getMealRow(groupId, member.id, today);
    expect(row!.count, 5, reason: 'the pre-existing entry must survive untouched');
  });

  test('skips a member with no routine configured', () async {
    await members.addMember(groupId: groupId, name: 'Alice'); // no routine set

    final filled = await autoFill.fillToday(groupId, today: today);

    expect(filled, 0);
  });

  test('an active meal-leave zeroes the routine for that day, so no fill happens', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    await routines.setRoutine(memberId: member.id, slotId: breakfastSlotId, enabled: true);
    await routines.addLeave(memberId: member.id, fromDate: today, toDate: today);

    final filled = await autoFill.fillToday(groupId, today: today);

    expect(filled, 0);
    expect(await meals.getMealRow(groupId, member.id, today), isNull);
  });

  test('an inactive member is never auto-filled', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    await routines.setRoutine(memberId: member.id, slotId: breakfastSlotId, enabled: true);
    await members.deactivateMember(member.id, leaveDate: today);

    final filled = await autoFill.fillToday(groupId, today: today);

    expect(filled, 0);
    expect(await meals.getMealRow(groupId, member.id, today), isNull);
  });

  test('fills multiple members independently and returns the correct count', () async {
    final alice = await members.addMember(groupId: groupId, name: 'Alice');
    final bob = await members.addMember(groupId: groupId, name: 'Bob');
    await routines.setRoutine(memberId: alice.id, slotId: breakfastSlotId, enabled: true);
    await routines.setRoutine(memberId: bob.id, slotId: breakfastSlotId, enabled: true);

    final filled = await autoFill.fillToday(groupId, today: today);

    expect(filled, 2);
  });
}
