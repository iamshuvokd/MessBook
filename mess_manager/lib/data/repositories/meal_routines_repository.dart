import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/meal_routine.dart' as domain;
import '../db/app_database.dart';

const _uuid = Uuid();

/// Member auto-meal routines ("customizable auto meal setup" — user
/// decision) and leave date-ranges. [resolveRoutineSlotIds] is the shared
/// logic used by both the daily auto-fill engine and a poll's 'routine'
/// non-voter policy.
class MealRoutinesRepository {
  MealRoutinesRepository(this._db);

  final AppDatabase _db;

  domain.MemberMealRoutine _routineToDomain(MemberMealRoutine row) => domain.MemberMealRoutine(
        id: row.id,
        memberId: row.memberId,
        slotId: row.slotId,
        weekday: row.weekday,
        enabled: row.enabled,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  domain.MealLeave _leaveToDomain(MealLeave row) => domain.MealLeave(
        id: row.id,
        memberId: row.memberId,
        fromDate: DateTime.fromMillisecondsSinceEpoch(row.fromDate),
        toDate: DateTime.fromMillisecondsSinceEpoch(row.toDate),
        note: row.note,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  Stream<List<domain.MemberMealRoutine>> watchRoutines(String memberId) {
    return (_db.select(_db.memberMealRoutines)..where((r) => r.memberId.equals(memberId)))
        .watch()
        .map((rows) => rows.map(_routineToDomain).toList());
  }

  /// Sets whether [memberId] takes [slotId] on [weekday] (null = every day),
  /// creating or updating the single matching row (one row per
  /// member+slot+weekday combo, upserted at the app layer).
  Future<void> setRoutine({
    required String memberId,
    required String slotId,
    int? weekday,
    required bool enabled,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existing = await (_db.select(_db.memberMealRoutines)
          ..where((r) =>
              r.memberId.equals(memberId) &
              r.slotId.equals(slotId) &
              (weekday == null ? r.weekday.isNull() : r.weekday.equals(weekday))))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.memberMealRoutines)..where((r) => r.id.equals(existing.id))).write(
        MemberMealRoutinesCompanion(enabled: Value(enabled), updatedAt: Value(now)),
      );
    } else {
      await _db.into(_db.memberMealRoutines).insert(
            MemberMealRoutinesCompanion.insert(
              id: _uuid.v4(),
              memberId: memberId,
              slotId: slotId,
              weekday: Value(weekday),
              enabled: Value(enabled),
              updatedAt: now,
            ),
          );
    }
  }

  Stream<List<domain.MealLeave>> watchLeaves(String memberId) {
    return (_db.select(_db.mealLeaves)..where((l) => l.memberId.equals(memberId)))
        .watch()
        .map((rows) => rows.map(_leaveToDomain).toList());
  }

  Future<void> addLeave({
    required String memberId,
    required DateTime fromDate,
    required DateTime toDate,
    String? note,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.mealLeaves).insert(
          MealLeavesCompanion.insert(
            id: _uuid.v4(),
            memberId: memberId,
            fromDate: DateTime(fromDate.year, fromDate.month, fromDate.day).millisecondsSinceEpoch,
            toDate: DateTime(toDate.year, toDate.month, toDate.day).millisecondsSinceEpoch,
            note: Value(note),
            updatedAt: now,
          ),
        );
  }

  Future<void> deleteLeave(String id) async {
    await (_db.delete(_db.mealLeaves)..where((l) => l.id.equals(id))).go();
  }

  Future<bool> isOnLeave(String memberId, DateTime date) async {
    final dayKey = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final matching = await (_db.select(_db.mealLeaves)
          ..where((l) => l.memberId.equals(memberId) & l.fromDate.isSmallerOrEqualValue(dayKey) & l.toDate.isBiggerOrEqualValue(dayKey)))
        .get();
    return matching.isNotEmpty;
  }

  /// Resolves which slot ids [memberId] takes on [date] per their standing
  /// routine: a weekday-specific row beats an "every day" row for the same
  /// slot; leave overrides everything to none. Only active slots count.
  Future<List<String>> resolveRoutineSlotIds(String memberId, DateTime date, {String? groupId}) async {
    if (await isOnLeave(memberId, date)) return const [];

    final rows = await (_db.select(_db.memberMealRoutines)..where((r) => r.memberId.equals(memberId))).get();
    if (rows.isEmpty) return const [];

    final activeSlotIds = groupId == null
        ? null
        : (await (_db.select(_db.mealSlots)..where((s) => s.groupId.equals(groupId) & s.active.equals(true))).get())
            .map((s) => s.id)
            .toSet();

    final bySlot = <String, List<MemberMealRoutine>>{};
    for (final row in rows) {
      (bySlot[row.slotId] ??= []).add(row);
    }

    final weekday = date.weekday;
    final result = <String>[];
    for (final entry in bySlot.entries) {
      if (activeSlotIds != null && !activeSlotIds.contains(entry.key)) continue;
      final specific = entry.value.where((r) => r.weekday == weekday);
      final everyDay = entry.value.where((r) => r.weekday == null);
      final effective = specific.isNotEmpty ? specific.first : (everyDay.isNotEmpty ? everyDay.first : null);
      if (effective != null && effective.enabled) result.add(entry.key);
    }
    return result;
  }
}
