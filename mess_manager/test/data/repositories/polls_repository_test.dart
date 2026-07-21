import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/data/db/app_database.dart';
import 'package:mess_manager/data/repositories/groups_repository.dart';
import 'package:mess_manager/data/repositories/meal_routines_repository.dart';
import 'package:mess_manager/data/repositories/meal_slots_repository.dart';
import 'package:mess_manager/data/repositories/meals_repository.dart';
import 'package:mess_manager/data/repositories/members_repository.dart';
import 'package:mess_manager/data/repositories/polls_repository.dart';
import 'package:mess_manager/domain/models/group.dart';
import 'package:mess_manager/domain/models/meal_poll.dart';
import 'package:mess_manager/domain/models/non_voter_policy.dart';

void main() {
  // Plain `test()` blocks against a real in-memory Drift DB — see
  // backup_service_test.dart's note on why this avoids the widget-test
  // fake-async hang this project has seen with a real sqlite3 DB.

  late AppDatabase db;
  late GroupsRepository groups;
  late MembersRepository members;
  late MealSlotsRepository slots;
  late MealRoutinesRepository routines;
  late MealsRepository meals;
  late PollsRepository polls;

  late String groupId;
  late String creatorId;
  late String breakfastSlotId;
  late String lunchSlotId;

  final today = DateTime.now();
  final yesterday = today.subtract(const Duration(days: 1));

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    groups = GroupsRepository(db);
    members = MembersRepository(db);
    slots = MealSlotsRepository(db);
    routines = MealRoutinesRepository(db);
    meals = MealsRepository(db);
    polls = PollsRepository(db, members, slots, routines, meals);

    final group = await groups.createGroup(name: 'Test Mess', type: GroupType.mess, mealEnabled: true);
    groupId = group.id;
    final creator = await members.addMember(groupId: groupId, name: 'Creator');
    creatorId = creator.id;

    final seededSlots = await slots.activeSlots(groupId);
    breakfastSlotId = seededSlots.firstWhere((s) => s.defaultKey == 'breakfast').id;
    lunchSlotId = seededSlots.firstWhere((s) => s.defaultKey == 'lunch').id;
  });

  tearDown(() async {
    await db.close();
  });

  Future<String> createPastPoll({
    required PollType type,
    NonVoterPolicy? nonVoterPolicy,
    DateTime? date,
  }) {
    return polls.createPoll(
      groupId: groupId,
      date: date ?? today,
      type: type,
      closeAt: today.subtract(const Duration(minutes: 1)),
      createdByMemberId: creatorId,
      nonVoterPolicy: nonVoterPolicy,
    );
  }

  test('watchPolls lists the most recently created poll first for the same date', () async {
    final first = await polls.createPoll(
        groupId: groupId, date: today, type: PollType.count, closeAt: today.add(const Duration(hours: 1)), createdByMemberId: creatorId);
    // Ensure a strictly later updatedAt for the second poll.
    await Future<void>.delayed(const Duration(milliseconds: 5));
    final second = await polls.createPoll(
        groupId: groupId, date: today, type: PollType.count, closeAt: today.add(const Duration(hours: 2)), createdByMemberId: creatorId);

    final list = await polls.watchPolls(groupId).first;
    expect(list.first.id, second, reason: 'the newest poll for the same date must appear first');
    expect(list[1].id, first);
  });

  test('updatePoll changes the editable fields and bumps updatedAt, keeping date/creator', () async {
    final pollId = await polls.createPoll(
      groupId: groupId,
      date: today,
      type: PollType.count,
      title: 'Original',
      closeAt: today.add(const Duration(hours: 2)),
      createdByMemberId: creatorId,
      nonVoterPolicy: NonVoterPolicy.zero,
    );
    final before = await polls.watchPoll(pollId).first;

    final newCloseAt = today.add(const Duration(hours: 5));
    await polls.updatePoll(
      pollId: pollId,
      type: PollType.menu,
      title: 'Edited',
      options: const ['Rice', 'Khichuri'],
      closeAt: newCloseAt,
      nonVoterPolicy: NonVoterPolicy.routine,
    );

    final after = await polls.watchPoll(pollId).first;
    expect(after!.type, PollType.menu);
    expect(after.title, 'Edited');
    expect(after.options, ['Rice', 'Khichuri']);
    expect(after.closeAt.millisecondsSinceEpoch, newCloseAt.millisecondsSinceEpoch);
    expect(after.nonVoterPolicy, NonVoterPolicy.routine);
    // Preserved:
    expect(after.date, before!.date);
    expect(after.createdByMemberId, creatorId);
    expect(after.closed, isFalse);
  });

  test('reopenPoll reopens a closed poll and extends its close time', () async {
    final pollId = await createPastPoll(type: PollType.count);
    await polls.closePoll(pollId);
    expect((await polls.watchPoll(pollId).first)!.closed, isTrue);

    final newCloseAt = today.add(const Duration(hours: 3));
    await polls.reopenPoll(pollId: pollId, newCloseAt: newCloseAt);

    final reopened = await polls.watchPoll(pollId).first;
    expect(reopened!.closed, isFalse);
    expect(reopened.closeAt.millisecondsSinceEpoch, newCloseAt.millisecondsSinceEpoch);
  });

  test('a reopened poll is picked up again by closeDuePolls once its new time passes', () async {
    final pollId = await createPastPoll(type: PollType.count);
    await polls.closePoll(pollId);

    // Reopen with a close time already in the past → it should re-close on the
    // next closeDuePolls sweep (proving reopen fully returns it to the pool).
    await polls.reopenPoll(pollId: pollId, newCloseAt: today.subtract(const Duration(minutes: 1)));
    expect((await polls.watchPoll(pollId).first)!.closed, isFalse);

    final closed = await polls.closeDuePolls(groupId);
    expect(closed, 1);
    expect((await polls.watchPoll(pollId).first)!.closed, isTrue);
  });

  test('closing a still-open poll early applies votes to the meal sheet immediately', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    // An OPEN poll (closes in the future) — "Close now" should still apply it.
    final pollId = await polls.createPoll(
      groupId: groupId,
      date: today,
      type: PollType.count,
      closeAt: today.add(const Duration(hours: 6)),
      createdByMemberId: creatorId,
    );
    await polls.castVote(pollId: pollId, memberId: member.id, value: PollVote(pollId: pollId, memberId: member.id, count: 2, votedAt: today));

    // No meal yet — votes only apply on close.
    expect(await meals.getMealRow(groupId, member.id, today), isNull);

    await polls.closePoll(pollId); // what "Close now & apply" invokes

    final row = await meals.getMealRow(groupId, member.id, today);
    expect(row, isNotNull);
    expect(row!.count, 2);
    expect((await polls.watchPoll(pollId).first)!.closed, isTrue);
  });

  test('deletePoll removes the poll and its votes, leaving meals intact', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    final pollId = await polls.createPoll(
      groupId: groupId,
      date: today,
      type: PollType.count,
      closeAt: today.add(const Duration(hours: 1)),
      createdByMemberId: creatorId,
    );
    await polls.castVote(pollId: pollId, memberId: member.id, value: PollVote(pollId: pollId, memberId: member.id, count: 2, votedAt: today));
    // A meal recorded independently must survive the poll deletion.
    await meals.setMeal(groupId: groupId, memberId: member.id, date: today, count: 3, guestCount: 0);

    await polls.deletePoll(pollId);

    expect(await polls.watchPoll(pollId).first, isNull);
    expect(await polls.watchVotes(pollId).first, isEmpty);
    expect((await meals.getMealRow(groupId, member.id, today))!.count, 3);
  });

  test('an auto-paused member gets no meal from the non-voter policy', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    final pollId = await createPastPoll(type: PollType.count, nonVoterPolicy: NonVoterPolicy.repeatYesterday);
    await meals.setMeal(groupId: groupId, memberId: member.id, date: yesterday, count: 2, guestCount: 0);

    await polls.closePoll(pollId, skipAutoMemberIds: {member.id});

    expect(await meals.getMealRow(groupId, member.id, today), isNull,
        reason: 'a low-balance member should not be auto-given meals');
  });

  test('an auto-paused member who DID vote still gets their chosen meal', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    final pollId = await createPastPoll(type: PollType.count);
    await polls.castVote(
        pollId: pollId, memberId: member.id, value: PollVote(pollId: pollId, memberId: member.id, count: 2, votedAt: today));

    await polls.closePoll(pollId, skipAutoMemberIds: {member.id});

    final row = await meals.getMealRow(groupId, member.id, today);
    expect(row!.count, 2, reason: 'an explicit vote is the member choosing to eat; only AUTO adds are paused');
  });

  test('a menu-type poll never touches the meal grid', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    final pollId = await createPastPoll(type: PollType.menu, nonVoterPolicy: NonVoterPolicy.zero);

    await polls.closePoll(pollId);

    expect(await meals.getMealRow(groupId, member.id, today), isNull);
    final poll = await polls.watchPoll(pollId).first;
    expect(poll!.closed, isTrue);
  });

  test('a count-type vote sets the exact voted count', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    final pollId = await createPastPoll(type: PollType.count);
    await polls.castVote(pollId: pollId, memberId: member.id, value: PollVote(pollId: pollId, memberId: member.id, count: 2, votedAt: today));

    await polls.closePoll(pollId);

    final row = await meals.getMealRow(groupId, member.id, today);
    expect(row, isNotNull);
    expect(row!.count, 2);
  });

  test('a slots-type vote weights the meal count by the chosen slots', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    final pollId = await createPastPoll(type: PollType.slots);
    await polls.castVote(
      pollId: pollId,
      memberId: member.id,
      value: PollVote(pollId: pollId, memberId: member.id, slotIds: [breakfastSlotId, lunchSlotId], votedAt: today),
    );

    await polls.closePoll(pollId);

    final row = await meals.getMealRow(groupId, member.id, today);
    expect(row, isNotNull);
    expect(row!.count, 1.5); // breakfast 0.5 + lunch 1
  });

  test('closing a poll never overwrites an already-manually-set entry for a non-voter', () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    // A manual entry: no slotIds recorded, matching the app's "looksManual" signal.
    await meals.setMeal(groupId: groupId, memberId: member.id, date: today, count: 3, guestCount: 0);
    final pollId = await createPastPoll(type: PollType.count, nonVoterPolicy: NonVoterPolicy.zero);

    await polls.closePoll(pollId);

    final row = await meals.getMealRow(groupId, member.id, today);
    expect(row!.count, 3, reason: 'the manual entry must survive the zero non-voter policy');
  });

  test("non-voter policy 'zero' results in no meal entry (setMeal(0) never creates a row)", () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    final pollId = await createPastPoll(type: PollType.count, nonVoterPolicy: NonVoterPolicy.zero);

    await polls.closePoll(pollId);

    expect(await meals.getMealRow(groupId, member.id, today), isNull);
  });

  test("non-voter policy 'pending' leaves the member unresolved for the Meal Admin", () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    final pollId = await createPastPoll(type: PollType.count, nonVoterPolicy: NonVoterPolicy.pending);

    await polls.closePoll(pollId);

    expect(await meals.getMealRow(groupId, member.id, today), isNull);
    expect(await polls.pendingMemberIds(pollId), contains(member.id));
  });

  test("non-voter policy 'repeatYesterday' copies yesterday's count", () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    await meals.setMeal(groupId: groupId, memberId: member.id, date: yesterday, count: 2, guestCount: 1);
    final pollId = await createPastPoll(type: PollType.count, nonVoterPolicy: NonVoterPolicy.repeatYesterday);

    await polls.closePoll(pollId);

    final row = await meals.getMealRow(groupId, member.id, today);
    expect(row!.count, 2);
    expect(row.guestCount, 1);
  });

  test("non-voter policy 'repeatYesterday' with no prior entry results in no meal row", () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    final pollId = await createPastPoll(type: PollType.count, nonVoterPolicy: NonVoterPolicy.repeatYesterday);

    await polls.closePoll(pollId);

    expect(await meals.getMealRow(groupId, member.id, today), isNull);
  });

  test("non-voter policy 'routine' applies the member's standing auto-routine", () async {
    final member = await members.addMember(groupId: groupId, name: 'Alice');
    await routines.setRoutine(memberId: member.id, slotId: breakfastSlotId, enabled: true); // every day
    final pollId = await createPastPoll(type: PollType.count, nonVoterPolicy: NonVoterPolicy.routine);

    await polls.closePoll(pollId);

    final row = await meals.getMealRow(groupId, member.id, today);
    expect(row, isNotNull);
    expect(row!.count, 0.5);
    expect(row.slotsJson, isNotNull, reason: 'routine-driven writes record which slots produced the count');
  });

  test('closeDuePolls only closes polls whose close time has passed', () async {
    final duePollId = await createPastPoll(type: PollType.menu);
    final futurePollId = await polls.createPoll(
      groupId: groupId,
      date: today,
      type: PollType.menu,
      closeAt: today.add(const Duration(days: 1)),
      createdByMemberId: creatorId,
    );

    final closedCount = await polls.closeDuePolls(groupId);

    expect(closedCount, 1);
    expect((await polls.watchPoll(duePollId).first)!.closed, isTrue);
    expect((await polls.watchPoll(futurePollId).first)!.closed, isFalse);
  });

  test('closing an already-closed poll is a safe no-op', () async {
    final pollId = await createPastPoll(type: PollType.menu);
    await polls.closePoll(pollId);

    await polls.closePoll(pollId); // must not throw

    expect((await polls.watchPoll(pollId).first)!.closed, isTrue);
  });
}
