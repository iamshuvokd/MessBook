import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mess_manager/data/db/app_database.dart';
import 'package:mess_manager/data/repositories/balances_repository.dart';
import 'package:mess_manager/data/repositories/deposits_repository.dart';
import 'package:mess_manager/data/repositories/expenses_repository.dart';
import 'package:mess_manager/data/repositories/groups_repository.dart';
import 'package:mess_manager/data/repositories/members_repository.dart';
import 'package:mess_manager/data/repositories/settlements_repository.dart';
import 'package:mess_manager/domain/models/expense.dart';
import 'package:mess_manager/domain/models/group.dart';
import 'package:mess_manager/domain/models/ledger_purpose.dart';

void main() {
  late AppDatabase db;
  late GroupsRepository groups;
  late MembersRepository members;
  late ExpensesRepository expenses;
  late DepositsRepository deposits;
  late SettlementsRepository settlements;
  late BalancesRepository balances;

  late String groupId;
  late String aliceId;
  late String bobId;
  late String mealCategoryId;
  late String generalCategoryId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    groups = GroupsRepository(db);
    members = MembersRepository(db);
    expenses = ExpensesRepository(db);
    deposits = DepositsRepository(db);
    settlements = SettlementsRepository(db);
    balances = BalancesRepository(db);

    final group = await groups.createGroup(name: 'Test Mess', type: GroupType.mess, mealEnabled: true);
    groupId = group.id;
    aliceId = (await members.addMember(groupId: groupId, name: 'Alice')).id;
    bobId = (await members.addMember(groupId: groupId, name: 'Bob')).id;

    final categories = await db.select(db.categories).get();
    mealCategoryId = categories.firstWhere((c) => c.isMealCategory).id;
    generalCategoryId = categories.firstWhere((c) => !c.isMealCategory).id;
  });

  tearDown(() async {
    await db.close();
  });

  test('combined balances: net = paid + deposits - share + settlementsPaid - settlementsReceived', () async {
    // ৳100 expense, Alice pays it all, split equally (৳50 each).
    await expenses.createExpense(
      groupId: groupId,
      amountPaisa: 10000,
      date: DateTime.now(),
      categoryId: generalCategoryId,
      payers: [ExpensePayerEntry(memberId: aliceId, amountPaisa: 10000)],
      splits: [ExpenseSplitEntry(memberId: aliceId, amountPaisa: 5000), ExpenseSplitEntry(memberId: bobId, amountPaisa: 5000)],
      splitType: SplitType.equal,
    );

    var result = await balances.computeBalances(groupId);
    var byMember = {for (final b in result) b.memberId: b};
    expect(byMember[aliceId]!.net, 5000); // paid 10000, owes 5000 -> +5000
    expect(byMember[bobId]!.net, -5000); // paid 0, owes 5000 -> -5000

    // Bob settles up with Alice.
    await settlements.recordSettlement(groupId: groupId, fromMemberId: bobId, toMemberId: aliceId, amountPaisa: 5000);

    result = await balances.computeBalances(groupId);
    byMember = {for (final b in result) b.memberId: b};
    expect(byMember[aliceId]!.net, 0);
    expect(byMember[bobId]!.net, 0);
  });

  test('a deposit increases the depositor\'s net without affecting the other member', () async {
    await deposits.addDeposit(groupId: groupId, memberId: aliceId, amountPaisa: 2000);

    final result = await balances.computeBalances(groupId);
    final byMember = {for (final b in result) b.memberId: b};
    expect(byMember[aliceId]!.net, 2000);
    expect(byMember[bobId]!.net, 0);
  });

  test('per-ledger split: meal and general expenses/deposits/settlements stay in their own ledger, and sum back to the combined net', () async {
    // Meal ledger: ৳60 expense, Alice pays, split equal (৳30 each).
    await expenses.createExpense(
      groupId: groupId,
      amountPaisa: 6000,
      date: DateTime.now(),
      categoryId: mealCategoryId,
      payers: [ExpensePayerEntry(memberId: aliceId, amountPaisa: 6000)],
      splits: [ExpenseSplitEntry(memberId: aliceId, amountPaisa: 3000), ExpenseSplitEntry(memberId: bobId, amountPaisa: 3000)],
      splitType: SplitType.equal,
    );
    // General ledger: ৳40 expense, Bob pays, split equal (৳20 each).
    await expenses.createExpense(
      groupId: groupId,
      amountPaisa: 4000,
      date: DateTime.now(),
      categoryId: generalCategoryId,
      payers: [ExpensePayerEntry(memberId: bobId, amountPaisa: 4000)],
      splits: [ExpenseSplitEntry(memberId: aliceId, amountPaisa: 2000), ExpenseSplitEntry(memberId: bobId, amountPaisa: 2000)],
      splitType: SplitType.equal,
    );
    await deposits.addDeposit(groupId: groupId, memberId: aliceId, amountPaisa: 1000, purpose: LedgerPurpose.meal);
    await settlements.recordSettlement(
      groupId: groupId,
      fromMemberId: bobId,
      toMemberId: aliceId,
      amountPaisa: 500,
      purpose: LedgerPurpose.general,
    );

    final combined = {for (final b in await balances.computeBalances(groupId)) b.memberId: b.net};
    final meal = {for (final b in await balances.computeBalances(groupId, ledger: LedgerPurpose.meal)) b.memberId: b.net};
    final general = {for (final b in await balances.computeBalances(groupId, ledger: LedgerPurpose.general)) b.memberId: b.net};

    // Meal ledger only sees the meal expense + the meal-tagged deposit.
    expect(meal[aliceId], 4000); // paid 6000 + deposit 1000 - share 3000
    expect(meal[bobId], -3000); // paid 0 - share 3000

    // General ledger only sees the general expense + the general-tagged settlement.
    expect(general[aliceId], -2500); // paid 0 - share 2000 - settlementReceived 500
    expect(general[bobId], 2500); // paid 4000 - share 2000 + settlementPaid 500

    // Invariant: per-ledger nets always sum back to the combined (unfiltered) net.
    expect(meal[aliceId]! + general[aliceId]!, combined[aliceId]);
    expect(meal[bobId]! + general[bobId]!, combined[bobId]);
  });

  test('an inactive (deactivated) member is excluded from balances entirely', () async {
    await deposits.addDeposit(groupId: groupId, memberId: bobId, amountPaisa: 1000);
    await members.deactivateMember(bobId);

    final result = await balances.computeBalances(groupId);
    expect(result.any((b) => b.memberId == bobId), isFalse);
  });
}
