import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/meal_slot.dart' as domain;
import '../db/app_database.dart';

const _uuid = Uuid();

/// Meal slots (Breakfast/Lunch/Dinner by default) — fully customizable per
/// group: the App Admin can rename, re-weight, add, and deactivate them.
class MealSlotsRepository {
  MealSlotsRepository(this._db);

  final AppDatabase _db;

  domain.MealSlot _toDomain(MealSlot row) => domain.MealSlot(
        id: row.id,
        groupId: row.groupId,
        name: row.name,
        defaultKey: row.defaultKey,
        weight: row.weight,
        sortOrder: row.sortOrder,
        active: row.active,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  Stream<List<domain.MealSlot>> watchSlots(String groupId, {bool activeOnly = false}) {
    final query = _db.select(_db.mealSlots)..where((s) => s.groupId.equals(groupId));
    if (activeOnly) {
      query.where((s) => s.active.equals(true));
    }
    query.orderBy([(s) => OrderingTerm.asc(s.sortOrder)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<List<domain.MealSlot>> activeSlots(String groupId) async {
    final rows = await (_db.select(_db.mealSlots)
          ..where((s) => s.groupId.equals(groupId) & s.active.equals(true)))
        .get();
    return rows.map(_toDomain).toList();
  }

  Future<void> addSlot({required String groupId, required String name, double weight = 1}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final maxOrder = await (_db.selectOnly(_db.mealSlots)
          ..addColumns([_db.mealSlots.sortOrder.max()])
          ..where(_db.mealSlots.groupId.equals(groupId)))
        .map((row) => row.read(_db.mealSlots.sortOrder.max()) ?? -1)
        .getSingle();
    await _db.into(_db.mealSlots).insert(
          MealSlotsCompanion.insert(
            id: _uuid.v4(),
            groupId: groupId,
            name: name,
            weight: Value(weight),
            sortOrder: Value(maxOrder + 1),
            updatedAt: now,
          ),
        );
  }

  Future<void> updateSlot(domain.MealSlot slot) async {
    await (_db.update(_db.mealSlots)..where((s) => s.id.equals(slot.id))).write(
      MealSlotsCompanion(
        name: Value(slot.name),
        defaultKey: Value(slot.defaultKey),
        weight: Value(slot.weight),
        sortOrder: Value(slot.sortOrder),
        active: Value(slot.active),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> setActive(String slotId, bool active) async {
    await (_db.update(_db.mealSlots)..where((s) => s.id.equals(slotId))).write(
      MealSlotsCompanion(active: Value(active), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)),
    );
  }
}
