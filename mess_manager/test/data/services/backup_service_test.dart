import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/data/db/app_database.dart';
import 'package:mess_manager/data/services/backup_service.dart';

void main() {
  // Plain `test()` blocks (not `testWidgets`) run as ordinary async Dart code
  // with no Flutter widget-test fake-async zone involved, so a real Drift
  // NativeDatabase works reliably here — unlike widget tests touching a
  // real DB, which hang on this machine (see MESS_MANAGER_PLAN.md notes).

  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedSampleData() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.into(db.groups).insert(GroupsCompanion.insert(
          id: 'g1',
          name: 'Green House Mess',
          createdAt: now,
          updatedAt: now,
        ));
    await db.into(db.members).insert(MembersCompanion.insert(
          id: 'm1',
          groupId: 'g1',
          name: 'Rahim',
          joinDate: now,
          updatedAt: now,
        ));
    final categoryId = (await db.select(db.categories).get()).first.id;
    await db.into(db.expenses).insert(ExpensesCompanion.insert(
          id: 'e1',
          groupId: 'g1',
          amountPaisa: 15000,
          date: now,
          categoryId: categoryId,
          updatedAt: now,
        ));
    await db.into(db.expensePayers).insert(ExpensePayersCompanion.insert(
          expenseId: 'e1',
          memberId: 'm1',
          amountPaidPaisa: 15000,
        ));
    await db.into(db.expenseSplits).insert(ExpenseSplitsCompanion.insert(
          expenseId: 'e1',
          memberId: 'm1',
          amountPaisa: 15000,
          splitType: 'equal',
        ));
    await db.into(db.meals).insert(MealsCompanion.insert(
          id: 'meal1',
          groupId: 'g1',
          memberId: 'm1',
          date: now,
          updatedAt: now,
        ));
    await db.into(db.deposits).insert(DepositsCompanion.insert(
          id: 'd1',
          groupId: 'g1',
          memberId: 'm1',
          amountPaisa: 50000,
          date: now,
          updatedAt: now,
        ));
  }

  test('export produces a valid envelope with a matching checksum', () async {
    await seedSampleData();
    final service = BackupService(db);
    final json = await service.exportJson();
    final preview = service.preview(json);

    expect(preview.schemaVersion, 1);
    expect(preview.groupCount, 1);
    expect(preview.memberCount, 1);
    expect(preview.expenseCount, 1);
    expect(preview.mealCount, 1);
    expect(preview.depositCount, 1);
  });

  test('export -> wipe -> import round-trips every table exactly', () async {
    await seedSampleData();
    final service = BackupService(db);
    final json = await service.exportJson();

    // Wipe everything (simulating a fresh install / data loss).
    await db.delete(db.deposits).go();
    await db.delete(db.meals).go();
    await db.delete(db.expenseSplits).go();
    await db.delete(db.expensePayers).go();
    await db.delete(db.expenses).go();
    await db.delete(db.categories).go();
    await db.delete(db.members).go();
    await db.delete(db.groups).go();
    expect(await db.select(db.groups).get(), isEmpty);

    await service.importReplaceAll(json);

    final groups = await db.select(db.groups).get();
    final members = await db.select(db.members).get();
    final expenses = await db.select(db.expenses).get();
    final payers = await db.select(db.expensePayers).get();
    final splits = await db.select(db.expenseSplits).get();
    final meals = await db.select(db.meals).get();
    final deposits = await db.select(db.deposits).get();
    final categories = await db.select(db.categories).get();

    expect(groups, hasLength(1));
    expect(groups.first.name, 'Green House Mess');
    expect(members, hasLength(1));
    expect(members.first.name, 'Rahim');
    expect(expenses, hasLength(1));
    expect(expenses.first.amountPaisa, 15000);
    expect(payers, hasLength(1));
    expect(splits, hasLength(1));
    expect(meals, hasLength(1));
    expect(deposits, hasLength(1));
    expect(deposits.first.amountPaisa, 50000);
    expect(categories, hasLength(8)); // the seeded defaults, round-tripped too
  });

  test('rejects a backup file whose checksum does not match its payload', () async {
    await seedSampleData();
    final service = BackupService(db);
    final json = await service.exportJson();
    final tampered = json.replaceFirst('"Rahim"', '"Tampered"');

    expect(
      () => service.importReplaceAll(tampered),
      throwsA(isA<BackupValidationError>()),
    );
  });

  test('rejects a backup with a newer schema version than this app supports', () async {
    await seedSampleData();
    final service = BackupService(db);
    final json = await service.exportJson();
    final newerVersion = json.replaceFirst('"schemaVersion":1', '"schemaVersion":999');

    expect(
      () => service.importReplaceAll(newerVersion),
      throwsA(isA<BackupValidationError>()),
    );
  });

  test('rejects malformed JSON gracefully instead of crashing', () {
    final service = BackupService(db);
    expect(() => service.preview('not json'), throwsA(isA<BackupValidationError>()));
  });
}
