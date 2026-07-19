import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

import 'tables.dart';

part 'app_database.g.dart';

const _uuid = Uuid();

/// groupId == null → default category available to every group.
/// key, icon, isMealCategory mirror spec §3's seed list.
const defaultCategorySeeds = [
  (key: 'bazar', icon: 'shopping_basket', isMealCategory: true),
  (key: 'rent', icon: 'home', isMealCategory: false),
  (key: 'utility', icon: 'bolt', isMealCategory: false),
  (key: 'wifi', icon: 'wifi', isMealCategory: false),
  (key: 'maid', icon: 'cleaning_services', isMealCategory: false),
  (key: 'gas', icon: 'propane_tank', isMealCategory: false),
  (key: 'repairs', icon: 'build', isMealCategory: false),
  (key: 'misc', icon: 'category', isMealCategory: false),
];

/// Seeded per group that has meals enabled — admin-renameable/re-weighable,
/// per spec §user-decision "customizable auto meal setup, breakfast/lunch/
/// dinner like that". Weight 0.5 for breakfast matches common BD mess
/// convention; every number here is just a starting point.
const defaultMealSlotSeeds = [
  (key: 'breakfast', weight: 0.5),
  (key: 'lunch', weight: 1.0),
  (key: 'dinner', weight: 1.0),
];

@DriftDatabase(tables: [
  Groups,
  Members,
  Categories,
  Expenses,
  ExpensePayers,
  ExpenseSplits,
  Meals,
  Deposits,
  Settlements,
  Months,
  RecurringRules,
  MealPolls,
  MealPollVotes,
  MealSlots,
  MemberMealRoutines,
  MealLeaves,
  BazarDuties,
  AuditLog,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultCategories(this);
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Meal/rent ledger separation (M11): additive columns only, no
            // existing data touched — every pre-existing row defaults to
            // "combined" (mealLedgerSeparate=false, purpose='general').
            await m.addColumn(groups, groups.mealLedgerSeparate);
            await m.addColumn(deposits, deposits.purpose);
            await m.addColumn(settlements, settlements.purpose);
            await m.addColumn(months, months.mealClosedAt);
            await m.addColumn(months, months.mealSnapshotJson);
          }
          if (from < 3) {
            // Roles & customizable permissions (M12): additive only; every
            // pre-existing member defaults to role='member' with no
            // permissions, and gating stays fully permissive (see
            // rolesConfiguredProvider) until an App Admin is explicitly set.
            await m.addColumn(members, members.role);
            await m.addColumn(members, members.permissions);
          }
          if (from < 4) {
            // Meal automation (Step 2): slots, member routines, leave dates,
            // and daily polls. All new tables / additive columns only.
            await m.addColumn(groups, groups.defaultNonVoterPolicy);
            await m.addColumn(meals, meals.slotsJson);
            await m.createTable(mealPolls);
            await m.createTable(mealPollVotes);
            await m.createTable(mealSlots);
            await m.createTable(memberMealRoutines);
            await m.createTable(mealLeaves);

            // Every pre-existing group with meals on gets the default
            // Breakfast/Lunch/Dinner slots so auto-fill/polls work right away.
            final existingGroups = await (select(groups)..where((g) => g.mealEnabled.equals(true))).get();
            for (final group in existingGroups) {
              await seedDefaultMealSlots(this, group.id);
            }
          }
          if (from < 5) {
            // Online sync (Step 5): additive-only invite-code column, null
            // for every pre-existing (still-local) group.
            await m.addColumn(groups, groups.inviteCode);
          }
          if (from < 6) {
            // Bazar duty roster: one new table, nothing existing touched.
            await m.createTable(bazarDuties);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'mess_manager',
      native: const DriftNativeOptions(shareAcrossIsolates: true),
    );
  }
}

Future<void> _seedDefaultCategories(AppDatabase db) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  await db.batch((batch) {
    batch.insertAll(
      db.categories,
      [
        for (final seed in defaultCategorySeeds)
          CategoriesCompanion.insert(
            id: _uuid.v4(),
            groupId: const Value(null),
            name: seed.key, // canonical fallback; UI resolves via defaultKey + l10n
            defaultKey: Value(seed.key),
            isMealCategory: Value(seed.isMealCategory),
            icon: seed.icon,
            updatedAt: now,
          ),
      ],
    );
  });
}

/// Called both from group creation and from the v4 migration (for
/// pre-existing groups) so every meal-enabled group always has slots.
Future<void> seedDefaultMealSlots(AppDatabase db, String groupId) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  await db.batch((batch) {
    batch.insertAll(
      db.mealSlots,
      [
        for (var i = 0; i < defaultMealSlotSeeds.length; i++)
          MealSlotsCompanion.insert(
            id: _uuid.v4(),
            groupId: groupId,
            name: defaultMealSlotSeeds[i].key,
            defaultKey: Value(defaultMealSlotSeeds[i].key),
            weight: Value(defaultMealSlotSeeds[i].weight),
            sortOrder: Value(i),
            updatedAt: now,
          ),
      ],
    );
  });
}
