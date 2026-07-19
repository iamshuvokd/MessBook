import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/expense.dart' as domain;
import '../db/app_database.dart';

const _uuid = Uuid();

class ExpensesRepository {
  ExpensesRepository(this._db);

  final AppDatabase _db;

  domain.Expense _expenseToDomain(Expense row) => domain.Expense(
        id: row.id,
        groupId: row.groupId,
        amountPaisa: row.amountPaisa,
        date: DateTime.fromMillisecondsSinceEpoch(row.date),
        categoryId: row.categoryId,
        note: row.note,
        receiptPath: row.receiptPath,
        isRecurringInstance: row.isRecurringInstance,
        deleted: row.deleted,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  Stream<List<domain.ExpenseDetail>> watchExpenses(String groupId) {
    final query = _db.select(_db.expenses).join([
      innerJoin(_db.categories, _db.categories.id.equalsExp(_db.expenses.categoryId)),
    ])
      ..where(_db.expenses.groupId.equals(groupId) & _db.expenses.deleted.equals(false))
      ..orderBy([OrderingTerm.desc(_db.expenses.date)]);

    return query.watch().asyncMap((rows) async {
      final expenseIds = rows.map((r) => r.readTable(_db.expenses).id).toList();

      final payerRows = expenseIds.isEmpty
          ? <ExpensePayer>[]
          : await (_db.select(_db.expensePayers)..where((p) => p.expenseId.isIn(expenseIds))).get();
      final splitRows = expenseIds.isEmpty
          ? <ExpenseSplit>[]
          : await (_db.select(_db.expenseSplits)..where((s) => s.expenseId.isIn(expenseIds))).get();

      final payersByExpense = <String, List<domain.ExpensePayerEntry>>{};
      for (final p in payerRows) {
        (payersByExpense[p.expenseId] ??= []).add(
          domain.ExpensePayerEntry(memberId: p.memberId, amountPaisa: p.amountPaidPaisa),
        );
      }
      final splitTypeByExpense = <String, domain.SplitType>{};
      for (final s in splitRows) {
        splitTypeByExpense[s.expenseId] = domain.SplitType.fromDb(s.splitType);
      }

      return [
        for (final row in rows)
          _toDetail(
            row.readTable(_db.expenses),
            row.readTable(_db.categories),
            payersByExpense,
            splitTypeByExpense,
          ),
      ];
    });
  }

  domain.ExpenseDetail _toDetail(
    Expense expenseRow,
    Category categoryRow,
    Map<String, List<domain.ExpensePayerEntry>> payersByExpense,
    Map<String, domain.SplitType> splitTypeByExpense,
  ) {
    return domain.ExpenseDetail(
      expense: _expenseToDomain(expenseRow),
      categoryDefaultKey: categoryRow.defaultKey,
      categoryRawName: categoryRow.name,
      categoryIcon: categoryRow.icon,
      categoryIsMeal: categoryRow.isMealCategory,
      payers: payersByExpense[expenseRow.id] ?? const [],
      splitType: splitTypeByExpense[expenseRow.id] ?? domain.SplitType.equal,
    );
  }

  Future<domain.ExpenseDraft?> getExpense(String id) async {
    final row = await (_db.select(_db.expenses)..where((e) => e.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final payers = await (_db.select(_db.expensePayers)..where((p) => p.expenseId.equals(id))).get();
    final splits = await (_db.select(_db.expenseSplits)..where((s) => s.expenseId.equals(id))).get();
    return domain.ExpenseDraft(
      expense: _expenseToDomain(row),
      payers: [for (final p in payers) domain.ExpensePayerEntry(memberId: p.memberId, amountPaisa: p.amountPaidPaisa)],
      splits: [for (final s in splits) domain.ExpenseSplitEntry(memberId: s.memberId, amountPaisa: s.amountPaisa)],
      splitType: splits.isEmpty ? domain.SplitType.equal : domain.SplitType.fromDb(splits.first.splitType),
    );
  }

  Future<String> createExpense({
    required String groupId,
    required int amountPaisa,
    required DateTime date,
    required String categoryId,
    String? note,
    String? receiptPath,
    required List<domain.ExpensePayerEntry> payers,
    required List<domain.ExpenseSplitEntry> splits,
    required domain.SplitType splitType,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    await _db.transaction(() async {
      await _db.into(_db.expenses).insert(
            ExpensesCompanion.insert(
              id: id,
              groupId: groupId,
              amountPaisa: amountPaisa,
              date: date.millisecondsSinceEpoch,
              categoryId: categoryId,
              note: Value(note),
              receiptPath: Value(receiptPath),
              updatedAt: now,
            ),
          );
      await _writePayersAndSplits(id, payers, splits, splitType);
      await _logAudit(groupId: groupId, entity: 'expense', entityId: id, action: 'create');
    });

    return id;
  }

  Future<void> updateExpense({
    required String id,
    required String groupId,
    required int amountPaisa,
    required DateTime date,
    required String categoryId,
    String? note,
    String? receiptPath,
    required List<domain.ExpensePayerEntry> payers,
    required List<domain.ExpenseSplitEntry> splits,
    required domain.SplitType splitType,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    await _db.transaction(() async {
      await (_db.update(_db.expenses)..where((e) => e.id.equals(id))).write(
        ExpensesCompanion(
          amountPaisa: Value(amountPaisa),
          date: Value(date.millisecondsSinceEpoch),
          categoryId: Value(categoryId),
          note: Value(note),
          receiptPath: Value(receiptPath),
          updatedAt: Value(now),
        ),
      );
      await (_db.delete(_db.expensePayers)..where((p) => p.expenseId.equals(id))).go();
      await (_db.delete(_db.expenseSplits)..where((s) => s.expenseId.equals(id))).go();
      await _writePayersAndSplits(id, payers, splits, splitType);
      await _logAudit(groupId: groupId, entity: 'expense', entityId: id, action: 'update');
    });
  }

  Future<void> deleteExpense(String id, {required String groupId}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.transaction(() async {
      await (_db.update(_db.expenses)..where((e) => e.id.equals(id))).write(
        ExpensesCompanion(deleted: const Value(true), updatedAt: Value(now)),
      );
      await _logAudit(groupId: groupId, entity: 'expense', entityId: id, action: 'delete');
    });
  }

  Future<void> _writePayersAndSplits(
    String expenseId,
    List<domain.ExpensePayerEntry> payers,
    List<domain.ExpenseSplitEntry> splits,
    domain.SplitType splitType,
  ) async {
    await _db.batch((batch) {
      batch.insertAll(_db.expensePayers, [
        for (final p in payers)
          ExpensePayersCompanion.insert(expenseId: expenseId, memberId: p.memberId, amountPaidPaisa: p.amountPaisa),
      ]);
      batch.insertAll(_db.expenseSplits, [
        for (final s in splits)
          ExpenseSplitsCompanion.insert(
            expenseId: expenseId,
            memberId: s.memberId,
            amountPaisa: s.amountPaisa,
            splitType: splitType.name,
          ),
      ]);
    });
  }

  Future<void> _logAudit({
    required String groupId,
    required String entity,
    required String entityId,
    required String action,
  }) async {
    await _db.into(_db.auditLog).insert(
          AuditLogCompanion.insert(
            id: _uuid.v4(),
            groupId: groupId,
            entity: entity,
            entityId: entityId,
            action: action,
            timestamp: DateTime.now().millisecondsSinceEpoch,
            diffJson: Value(jsonEncode({'entity': entity, 'entityId': entityId})),
          ),
        );
  }
}
