import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/meal_poll.dart' as domain;
import '../../domain/models/non_voter_policy.dart';
import '../db/app_database.dart';
import 'meal_routines_repository.dart';
import 'meal_slots_repository.dart';
import 'meals_repository.dart';
import 'members_repository.dart';

const _uuid = Uuid();

/// Daily meal polls — creator-customizable type (slots/count/menu), close
/// time, and non-voter handling (user decision). Closing a poll writes its
/// outcome straight into the meal grid via [MealsRepository.setMeal],
/// respecting each member's most recent choice: a poll's result overwrites
/// an earlier auto-filled entry (identified by `slotsJson != null`) but
/// never a manually-set one (`slotsJson == null` with a positive count) —
/// see the `slotsJson` doc-comment on the `meals` table for why that
/// distinction is free to make.
class PollsRepository {
  PollsRepository(this._db, this._members, this._slots, this._routines, this._meals);

  final AppDatabase _db;
  final MembersRepository _members;
  final MealSlotsRepository _slots;
  final MealRoutinesRepository _routines;
  final MealsRepository _meals;

  domain.MealPoll _pollToDomain(MealPoll row) => domain.MealPoll(
        id: row.id,
        groupId: row.groupId,
        date: DateTime.fromMillisecondsSinceEpoch(row.date),
        type: domain.PollType.fromDb(row.type),
        title: row.title,
        options: domain.MealPoll.decodeOptions(row.optionsJson),
        closeAt: DateTime.fromMillisecondsSinceEpoch(row.closeAt),
        createdByMemberId: row.createdByMemberId,
        nonVoterPolicy: row.nonVoterPolicy == null ? null : NonVoterPolicy.fromDb(row.nonVoterPolicy!),
        closed: row.closed,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  domain.PollVote _voteToDomain(MealPollVote row) => domain.PollVote.fromJson(
        pollId: row.pollId,
        memberId: row.memberId,
        valueJson: row.valueJson,
        votedAt: DateTime.fromMillisecondsSinceEpoch(row.votedAt),
      );

  Stream<List<domain.MealPoll>> watchPolls(String groupId) {
    final query = _db.select(_db.mealPolls)
      ..where((p) => p.groupId.equals(groupId))
      // Newest first: primarily by the meal date, then by updatedAt so that
      // among polls for the same date the most recently created/edited one
      // sits on top (a just-created poll appears first, not buried under
      // older same-date polls in insertion order).
      ..orderBy([(p) => OrderingTerm.desc(p.date), (p) => OrderingTerm.desc(p.updatedAt)]);
    return query.watch().map((rows) => rows.map(_pollToDomain).toList());
  }

  Stream<domain.MealPoll?> watchPoll(String pollId) {
    return (_db.select(_db.mealPolls)..where((p) => p.id.equals(pollId)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _pollToDomain(row));
  }

  Stream<List<domain.PollVote>> watchVotes(String pollId) {
    return (_db.select(_db.mealPollVotes)..where((v) => v.pollId.equals(pollId)))
        .watch()
        .map((rows) => rows.map(_voteToDomain).toList());
  }

  Future<String> createPoll({
    required String groupId,
    required DateTime date,
    required domain.PollType type,
    String? title,
    List<String> options = const [],
    required DateTime closeAt,
    required String createdByMemberId,
    NonVoterPolicy? nonVoterPolicy,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.mealPolls).insert(
          MealPollsCompanion.insert(
            id: id,
            groupId: groupId,
            date: DateTime(date.year, date.month, date.day).millisecondsSinceEpoch,
            type: type.name,
            title: Value(title),
            optionsJson: Value(options.isEmpty ? null : domain.MealPoll.encodeOptions(options)),
            closeAt: closeAt.millisecondsSinceEpoch,
            createdByMemberId: createdByMemberId,
            nonVoterPolicy: Value(nonVoterPolicy?.name),
            updatedAt: now,
          ),
        );
    return id;
  }

  /// Edits an existing (still-open) poll's settings. The poll's date,
  /// creator, and closed flag are untouched; only the creator-editable
  /// fields change. `updatedAt` is bumped so the edit wins the sync
  /// last-write-wins comparison and propagates to every other device.
  Future<void> updatePoll({
    required String pollId,
    required domain.PollType type,
    String? title,
    List<String> options = const [],
    required DateTime closeAt,
    NonVoterPolicy? nonVoterPolicy,
  }) async {
    await (_db.update(_db.mealPolls)..where((p) => p.id.equals(pollId))).write(
      MealPollsCompanion(
        type: Value(type.name),
        title: Value(title),
        optionsJson: Value(options.isEmpty ? null : domain.MealPoll.encodeOptions(options)),
        closeAt: Value(closeAt.millisecondsSinceEpoch),
        nonVoterPolicy: Value(nonVoterPolicy?.name),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Reopens a closed poll and extends its close time — for a mess admin (or
  /// a `pollsManage` holder) who wants to give members more time to vote.
  /// Re-closing later (when [newCloseAt] passes) re-applies results via
  /// [closePoll], which still preserves any manual meal edits made in the
  /// meantime. [newCloseAt] must be in the future or the poll would just
  /// re-close on the next app open.
  Future<void> reopenPoll({required String pollId, required DateTime newCloseAt}) async {
    await (_db.update(_db.mealPolls)..where((p) => p.id.equals(pollId))).write(
      MealPollsCompanion(
        closed: const Value(false),
        closeAt: Value(newCloseAt.millisecondsSinceEpoch),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Permanently deletes a poll and its votes locally. Meals already written
  /// from a previous close are separate rows and stay untouched. For an
  /// online mess the caller also invokes
  /// [SyncApiService.deletePollRemote] so the server drops it too (a hard
  /// local delete alone would reappear on the next pull).
  Future<void> deletePoll(String pollId) async {
    await _db.transaction(() async {
      await (_db.delete(_db.mealPollVotes)..where((v) => v.pollId.equals(pollId))).go();
      await (_db.delete(_db.mealPolls)..where((p) => p.id.equals(pollId))).go();
    });
  }

  Future<void> castVote({required String pollId, required String memberId, required domain.PollVote value}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.mealPollVotes).insertOnConflictUpdate(
          MealPollVotesCompanion.insert(
            pollId: pollId,
            memberId: memberId,
            valueJson: value.toValueJson(),
            votedAt: now,
          ),
        );
  }

  /// Closes every poll past its close time across [groupId], applying
  /// results to the meal grid. Safe to call repeatedly (idempotent — a
  /// closed poll is skipped).
  Future<int> closeDuePolls(String groupId, {Set<String> skipAutoMemberIds = const {}}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final due = await (_db.select(_db.mealPolls)
          ..where((p) => p.groupId.equals(groupId) & p.closed.equals(false) & p.closeAt.isSmallerOrEqualValue(now)))
        .get();
    for (final poll in due) {
      await closePoll(poll.id, skipAutoMemberIds: skipAutoMemberIds);
    }
    return due.length;
  }

  /// [skipAutoMemberIds] are members auto-paused for a low balance: the
  /// non-voter policy is NOT applied to them (no meals auto-added). An
  /// explicit vote still counts — they chose to eat, and the manager can
  /// sort the money out separately.
  Future<void> closePoll(String pollId, {Set<String> skipAutoMemberIds = const {}}) async {
    final pollRow = await (_db.select(_db.mealPolls)..where((p) => p.id.equals(pollId))).getSingleOrNull();
    if (pollRow == null || pollRow.closed) return;

    final group = await (_db.select(_db.groups)..where((g) => g.id.equals(pollRow.groupId))).getSingle();
    final policy = pollRow.nonVoterPolicy == null
        ? NonVoterPolicy.fromDb(group.defaultNonVoterPolicy)
        : NonVoterPolicy.fromDb(pollRow.nonVoterPolicy!);
    final type = domain.PollType.fromDb(pollRow.type);
    final pollDate = DateTime.fromMillisecondsSinceEpoch(pollRow.date);

    final activeMembers = await _members.watchMembers(pollRow.groupId, activeOnly: true).first;
    final voteRows = await (_db.select(_db.mealPollVotes)..where((v) => v.pollId.equals(pollId))).get();
    final votesByMember = {for (final v in voteRows) v.memberId: _voteToDomain(v)};

    // Fetched regardless of [type]: 'slots'-type votes need it directly, and
    // a 'routine' non-voter policy needs slot weights no matter the type.
    final activeSlots = await _slots.activeSlots(pollRow.groupId);
    final weightBySlot = {for (final s in activeSlots) s.id: s.weight};

    for (final member in activeMembers) {
      final vote = votesByMember[member.id];

      if (vote != null) {
        switch (type) {
          case domain.PollType.slots:
            final slotIds = vote.slotIds.where(weightBySlot.containsKey).toList();
            final count = slotIds.fold<double>(0, (a, id) => a + (weightBySlot[id] ?? 0));
            await _meals.setMeal(groupId: pollRow.groupId, memberId: member.id, date: pollDate, count: count, guestCount: 0, slotIds: slotIds);
          case domain.PollType.count:
            await _meals.setMeal(groupId: pollRow.groupId, memberId: member.id, date: pollDate, count: vote.count ?? 0, guestCount: 0);
          case domain.PollType.menu:
            break; // informational only — never touches the meal grid
        }
        continue;
      }

      if (type == domain.PollType.menu) continue;

      // Non-voter: respect a manual edit already sitting there (no
      // slotsJson but a positive count); otherwise apply the policy.
      if (skipAutoMemberIds.contains(member.id)) continue;

      final existing = await _meals.getMealRow(pollRow.groupId, member.id, pollDate);
      final looksManual = existing != null && existing.slotsJson == null && existing.count > 0;
      if (looksManual) continue;

      switch (policy) {
        case NonVoterPolicy.pending:
          continue; // left for the Meal Admin to resolve
        case NonVoterPolicy.zero:
          await _meals.setMeal(groupId: pollRow.groupId, memberId: member.id, date: pollDate, count: 0, guestCount: 0);
        case NonVoterPolicy.repeatYesterday:
          final yesterday = pollDate.subtract(const Duration(days: 1));
          final prior = await _meals.getMealRow(pollRow.groupId, member.id, yesterday);
          await _meals.setMeal(
            groupId: pollRow.groupId,
            memberId: member.id,
            date: pollDate,
            count: prior?.count ?? 0,
            guestCount: prior?.guestCount ?? 0,
          );
        case NonVoterPolicy.routine:
          final slotIds = await _routines.resolveRoutineSlotIds(member.id, pollDate, groupId: pollRow.groupId);
          final count = slotIds.fold<double>(0, (a, id) => a + (weightBySlot[id] ?? 0));
          await _meals.setMeal(groupId: pollRow.groupId, memberId: member.id, date: pollDate, count: count, guestCount: 0, slotIds: slotIds);
      }
    }

    await (_db.update(_db.mealPolls)..where((p) => p.id.equals(pollId))).write(
      MealPollsCompanion(closed: const Value(true), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)),
    );
  }

  /// Active members who neither voted nor got a grid entry from a
  /// 'pending'-policy close — surfaced for the Meal Admin to resolve.
  Future<List<String>> pendingMemberIds(String pollId) async {
    final pollRow = await (_db.select(_db.mealPolls)..where((p) => p.id.equals(pollId))).getSingleOrNull();
    if (pollRow == null) return const [];
    final voteRows = await (_db.select(_db.mealPollVotes)..where((v) => v.pollId.equals(pollId))).get();
    final votedIds = voteRows.map((v) => v.memberId).toSet();
    final activeMembers = await _members.watchMembers(pollRow.groupId, activeOnly: true).first;
    final pollDate = DateTime.fromMillisecondsSinceEpoch(pollRow.date);

    final pending = <String>[];
    for (final member in activeMembers) {
      if (votedIds.contains(member.id)) continue;
      final entry = await _meals.getMealRow(pollRow.groupId, member.id, pollDate);
      if (entry == null) pending.add(member.id);
    }
    return pending;
  }
}
