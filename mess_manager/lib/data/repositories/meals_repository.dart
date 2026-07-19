import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/meal.dart' as domain;
import '../db/app_database.dart';

const _uuid = Uuid();

class MealsRepository {
  MealsRepository(this._db);

  final AppDatabase _db;

  domain.Meal _toDomain(Meal row) => domain.Meal(
        id: row.id,
        groupId: row.groupId,
        memberId: row.memberId,
        date: DateTime.fromMillisecondsSinceEpoch(row.date),
        count: row.count,
        guestCount: row.guestCount,
        slotIds: row.slotsJson == null ? null : List<String>.from(jsonDecode(row.slotsJson!) as List),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  /// The raw row for a single member/day, or null if no entry exists yet —
  /// used by the poll/auto-fill engines to decide whether to write.
  Future<Meal?> getMealRow(String groupId, String memberId, DateTime date) {
    final dayKey = _dayKey(date);
    return (_db.select(_db.meals)
          ..where((m) => m.groupId.equals(groupId) & m.memberId.equals(memberId) & m.date.equals(dayKey)))
        .getSingleOrNull();
  }

  int _dayKey(DateTime d) => DateTime(d.year, d.month, d.day).millisecondsSinceEpoch;

  /// Watches all meals for a group within [start, end) (end exclusive).
  Stream<List<domain.Meal>> watchMealsInRange(String groupId, DateTime start, DateTime end) {
    final startKey = _dayKey(start);
    final endKey = _dayKey(end);
    final query = _db.select(_db.meals)
      ..where((m) => m.groupId.equals(groupId) & m.date.isBiggerOrEqualValue(startKey) & m.date.isSmallerThanValue(endKey));
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  /// Sets a member's meal count for a single day, creating the row if needed
  /// (and deleting it if both counts are zeroed out, to keep the table tidy).
  /// [slotIds], when given, is a display-only record of which meal slots
  /// (auto-fill or a 'slots'-type poll) produced this count.
  Future<void> setMeal({
    required String groupId,
    required String memberId,
    required DateTime date,
    required double count,
    required double guestCount,
    List<String>? slotIds,
  }) async {
    final dayKey = _dayKey(date);
    final now = DateTime.now().millisecondsSinceEpoch;

    final existing = await (_db.select(_db.meals)
          ..where((m) => m.groupId.equals(groupId) & m.memberId.equals(memberId) & m.date.equals(dayKey)))
        .getSingleOrNull();

    if (count <= 0 && guestCount <= 0) {
      if (existing != null) {
        await (_db.delete(_db.meals)..where((m) => m.id.equals(existing.id))).go();
      }
      return;
    }

    final slotsJson = slotIds == null ? null : jsonEncode(slotIds);

    if (existing != null) {
      await (_db.update(_db.meals)..where((m) => m.id.equals(existing.id))).write(
        MealsCompanion(
          count: Value(count),
          guestCount: Value(guestCount),
          slotsJson: Value(slotsJson),
          updatedAt: Value(now),
        ),
      );
    } else {
      await _db.into(_db.meals).insert(
            MealsCompanion.insert(
              id: _uuid.v4(),
              groupId: groupId,
              memberId: memberId,
              date: dayKey,
              count: Value(count),
              guestCount: Value(guestCount),
              slotsJson: Value(slotsJson),
              updatedAt: now,
            ),
          );
    }
  }

  /// Copies every member's meal entry from [fromDay] to [toDay] (used by
  /// "same as yesterday"). Skips members with no entry on [fromDay].
  Future<void> copyDay({
    required String groupId,
    required DateTime fromDay,
    required DateTime toDay,
    required List<String> memberIds,
  }) async {
    final fromKey = _dayKey(fromDay);
    final sourceRows = await (_db.select(_db.meals)
          ..where((m) => m.groupId.equals(groupId) & m.date.equals(fromKey) & m.memberId.isIn(memberIds)))
        .get();
    for (final row in sourceRows) {
      await setMeal(
        groupId: groupId,
        memberId: row.memberId,
        date: toDay,
        count: row.count,
        guestCount: row.guestCount,
      );
    }
  }

  /// Sets the same meal count for every member on [day] (used by "bulk fill").
  Future<void> bulkFill({
    required String groupId,
    required DateTime day,
    required List<String> memberIds,
    required double count,
  }) async {
    for (final id in memberIds) {
      await setMeal(groupId: groupId, memberId: id, date: day, count: count, guestCount: 0);
    }
  }
}
