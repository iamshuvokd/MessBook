import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/data/db/app_database.dart';
import 'package:mess_manager/data/repositories/groups_repository.dart';
import 'package:mess_manager/data/repositories/meal_routines_repository.dart';
import 'package:mess_manager/data/repositories/meal_slots_repository.dart';
import 'package:mess_manager/data/repositories/members_repository.dart';
import 'package:mess_manager/domain/models/group.dart';

void main() {
  late AppDatabase db;
  late GroupsRepository groups;
  late MembersRepository members;
  late MealSlotsRepository slots;
  late MealRoutinesRepository routines;

  late String groupId;
  late String memberId;
  late String breakfastSlotId;
  late String lunchSlotId;

  // A fixed Wednesday, so weekday-specific tests are deterministic
  // regardless of when the suite actually runs.
  final wednesday = DateTime(2026, 7, 22);
  final thursday = DateTime(2026, 7, 23);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    groups = GroupsRepository(db);
    members = MembersRepository(db);
    slots = MealSlotsRepository(db);
    routines = MealRoutinesRepository(db);

    final group = await groups.createGroup(name: 'Test Mess', type: GroupType.mess, mealEnabled: true);
    groupId = group.id;
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    memberId = member.id;
    final seeded = await slots.activeSlots(groupId);
    breakfastSlotId = seeded.firstWhere((s) => s.defaultKey == 'breakfast').id;
    lunchSlotId = seeded.firstWhere((s) => s.defaultKey == 'lunch').id;
  });

  tearDown(() async {
    await db.close();
  });

  test('a member with no routines resolves to no slots', () async {
    expect(await routines.resolveRoutineSlotIds(memberId, wednesday, groupId: groupId), isEmpty);
  });

  test('an "every day" routine (null weekday) applies on any day', () async {
    await routines.setRoutine(memberId: memberId, slotId: breakfastSlotId, enabled: true);

    expect(await routines.resolveRoutineSlotIds(memberId, wednesday, groupId: groupId), [breakfastSlotId]);
    expect(await routines.resolveRoutineSlotIds(memberId, thursday, groupId: groupId), [breakfastSlotId]);
  });

  test('a weekday-specific rule beats "every day" for the same slot on that weekday', () async {
    // Every day: take breakfast. But explicitly OFF on Wednesdays specifically.
    await routines.setRoutine(memberId: memberId, slotId: breakfastSlotId, enabled: true);
    await routines.setRoutine(memberId: memberId, slotId: breakfastSlotId, weekday: wednesday.weekday, enabled: false);

    expect(await routines.resolveRoutineSlotIds(memberId, wednesday, groupId: groupId), isEmpty,
        reason: 'the Wednesday-specific override wins over the every-day rule');
    expect(await routines.resolveRoutineSlotIds(memberId, thursday, groupId: groupId), [breakfastSlotId],
        reason: 'Thursday still falls back to the every-day rule');
  });

  test('a disabled routine (no weekday override) contributes nothing', () async {
    await routines.setRoutine(memberId: memberId, slotId: breakfastSlotId, enabled: false);

    expect(await routines.resolveRoutineSlotIds(memberId, wednesday, groupId: groupId), isEmpty);
  });

  test('multiple slots resolve independently', () async {
    await routines.setRoutine(memberId: memberId, slotId: breakfastSlotId, enabled: true);
    await routines.setRoutine(memberId: memberId, slotId: lunchSlotId, weekday: wednesday.weekday, enabled: true);

    final result = await routines.resolveRoutineSlotIds(memberId, wednesday, groupId: groupId);
    expect(result, containsAll([breakfastSlotId, lunchSlotId]));
    expect(result, hasLength(2));
  });

  test('a deactivated slot is excluded from the result even if a routine references it', () async {
    await routines.setRoutine(memberId: memberId, slotId: breakfastSlotId, enabled: true);
    await slots.setActive(breakfastSlotId, false);

    expect(await routines.resolveRoutineSlotIds(memberId, wednesday, groupId: groupId), isEmpty);
  });

  test('an active meal-leave overrides every routine to nothing for that date range', () async {
    await routines.setRoutine(memberId: memberId, slotId: breakfastSlotId, enabled: true);
    await routines.addLeave(memberId: memberId, fromDate: wednesday, toDate: thursday);

    expect(await routines.resolveRoutineSlotIds(memberId, wednesday, groupId: groupId), isEmpty);
    expect(await routines.resolveRoutineSlotIds(memberId, thursday, groupId: groupId), isEmpty);
    final afterLeave = thursday.add(const Duration(days: 1));
    expect(await routines.resolveRoutineSlotIds(memberId, afterLeave, groupId: groupId), [breakfastSlotId],
        reason: 'the routine resumes once the leave range ends');
  });
}
