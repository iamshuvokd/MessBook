import '../repositories/meal_routines_repository.dart';
import '../repositories/meal_slots_repository.dart';
import '../repositories/meals_repository.dart';
import '../repositories/members_repository.dart';

/// Materializes today's meal count from each member's standing routine —
/// "customizable auto meal setup" (user decision). Only ever fills a day
/// that has no entry yet, so it never overwrites a manual edit or a poll
/// result; called once per app-open (see `appOpenTasksProvider`).
class MealAutoFillService {
  MealAutoFillService(this._members, this._slots, this._routines, this._meals);

  final MembersRepository _members;
  final MealSlotsRepository _slots;
  final MealRoutinesRepository _routines;
  final MealsRepository _meals;

  Future<int> fillToday(String groupId, {DateTime? today}) async {
    final day = today ?? DateTime.now();
    final activeMembers = await _members.watchMembers(groupId, activeOnly: true).first;
    final activeSlots = await _slots.activeSlots(groupId);
    final weightBySlot = {for (final s in activeSlots) s.id: s.weight};

    var filled = 0;
    for (final member in activeMembers) {
      final existing = await _meals.getMealRow(groupId, member.id, day);
      if (existing != null) continue;

      final slotIds = await _routines.resolveRoutineSlotIds(member.id, day, groupId: groupId);
      if (slotIds.isEmpty) continue;

      final count = slotIds.fold<double>(0, (a, id) => a + (weightBySlot[id] ?? 0));
      if (count <= 0) continue;

      await _meals.setMeal(groupId: groupId, memberId: member.id, date: day, count: count, guestCount: 0, slotIds: slotIds);
      filled++;
    }
    return filled;
  }
}
