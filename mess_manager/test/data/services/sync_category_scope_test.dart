// Regression: a member's month report showed no data.
//
// Default categories are seeded per device with no groupId (shared by every
// mess on that phone), but the push only sent categories WHERE groupId =
// this group, and the server's pull is `WHERE group_id = ?`. So the "Bazar"
// category every bazar expense pointed at never reached other members. On
// their device the expense's categoryId resolved to nothing, so no expense
// counted as meal-category: the meal rate came out 0 and — for a mess that
// keeps the meal ledger separate — the meal report was completely empty.
import 'package:drift/drift.dart' show Value, InsertMode;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/data/db/app_database.dart' hide Group;
import 'package:mess_manager/data/repositories/month_report_repository.dart';
import 'package:mess_manager/data/services/sync_api_service.dart';
import 'package:mess_manager/domain/models/ledger_purpose.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Category category({required String id, String? groupId, required bool isMeal}) => Category(
        id: id,
        groupId: groupId,
        name: 'Bazar',
        defaultKey: 'bazar',
        isMealCategory: isMeal,
        icon: 'cart',
        updatedAt: 1,
      );

  group('keepLocallyGlobal', () {
    test('a category this device holds globally stays global', () {
      final pulled = category(id: 'c1', groupId: 'g1', isMeal: true);
      expect(keepLocallyGlobal(pulled, {'c1'}).groupId, isNull,
          reason: 'a shared default must not be re-scoped to one mess');
    });

    test('a category this device does NOT hold globally keeps its group', () {
      final pulled = category(id: 'c2', groupId: 'g1', isMeal: true);
      expect(keepLocallyGlobal(pulled, {'c1'}).groupId, 'g1');
    });

    test('the rest of the row is untouched either way', () {
      final pulled = category(id: 'c1', groupId: 'g1', isMeal: true);
      final kept = keepLocallyGlobal(pulled, {'c1'});
      expect(kept.isMealCategory, isTrue);
      expect(kept.name, 'Bazar');
      expect(kept.id, 'c1');
    });
  });

  group("the receiving member's month report", () {
    /// Seeds a member's device exactly as a pull leaves it: the mess, one
    /// member, one bazar expense split to them, and their meals.
    Future<void> seedPulledMess({required Category? syncedCategory}) async {
      const groupId = 'g1';
      final now = DateTime.now();
      final ms = DateTime(now.year, now.month, 15).millisecondsSinceEpoch;

      await db.into(db.groups).insert(
          GroupsCompanion.insert(id: groupId, name: 'Mess', createdAt: ms, updatedAt: ms));
      await db.into(db.members).insert(MembersCompanion.insert(
          id: 'm1', groupId: groupId, name: 'Shuvo', joinDate: ms, updatedAt: ms));

      // The category as it arrives from the server — or not at all, which is
      // what the bug produced.
      if (syncedCategory != null) {
        await db.into(db.categories).insert(syncedCategory, mode: InsertMode.insertOrReplace);
      }

      await db.into(db.expenses).insert(ExpensesCompanion.insert(
          id: 'e1', groupId: groupId, amountPaisa: 55000, date: ms, categoryId: 'cat-bazar', updatedAt: ms));
      await db.into(db.expenseSplits).insert(ExpenseSplitsCompanion.insert(
          expenseId: 'e1', memberId: 'm1', amountPaisa: 55000, splitType: 'meal'));
      await db.into(db.meals).insert(MealsCompanion.insert(
          id: 'meal1', groupId: groupId, memberId: 'm1', date: ms, count: const Value(5), updatedAt: ms));
    }

    test('BUG: with the category missing, the meal ledger report is empty', () async {
      await seedPulledMess(syncedCategory: null);

      final report = await MonthReportRepository(db).compute('g1', DateTime.now(), ledger: LedgerPurpose.meal);

      // Nothing is recognised as a meal expense, so the member sees nothing.
      expect(report.totalSpentPaisa, 0);
      expect(report.mealRatePaisaX100, 0);
    });

    test('with the category synced, the member sees the real numbers', () async {
      await seedPulledMess(syncedCategory: category(id: 'cat-bazar', groupId: 'g1', isMeal: true));

      final report = await MonthReportRepository(db).compute('g1', DateTime.now(), ledger: LedgerPurpose.meal);

      expect(report.totalSpentPaisa, 55000, reason: 'the bazar expense must count');
      expect(report.totalMeals, 5);
      // 550 taka over 5 meals = 110 taka per meal.
      expect(report.mealRatePaisaX100, 55000 * 100 ~/ 5);
      expect(report.rows.single.meals, 5);
    });

    test('a global (groupId null) category is still recognised locally', () async {
      // The sender's own device keeps its default global — the report must
      // work there too, which is why the push stamps a copy rather than
      // re-scoping the row.
      await seedPulledMess(syncedCategory: category(id: 'cat-bazar', groupId: null, isMeal: true));

      final report = await MonthReportRepository(db).compute('g1', DateTime.now(), ledger: LedgerPurpose.meal);

      expect(report.totalSpentPaisa, 55000);
      expect(report.mealRatePaisaX100, 55000 * 100 ~/ 5);
    });
  });
}
