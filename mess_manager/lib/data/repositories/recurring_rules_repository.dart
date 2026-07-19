import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/engines/split_calculator.dart';
import '../../domain/models/recurring_rule.dart' as domain;
import '../db/app_database.dart';
import 'months_repository.dart' show yearMonthKey;

const _uuid = Uuid();

class RecurringRulesRepository {
  RecurringRulesRepository(this._db);

  final AppDatabase _db;

  domain.RecurringRule _toDomain(RecurringRule row) => domain.RecurringRule(
        id: row.id,
        groupId: row.groupId,
        template: domain.RecurringTemplate.fromJson(jsonDecode(row.templateJson) as Map<String, dynamic>),
        dayOfMonth: row.dayOfMonth,
        active: row.active,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      );

  Stream<List<domain.RecurringRule>> watchRules(String groupId) {
    final query = _db.select(_db.recurringRules)
      ..where((r) => r.groupId.equals(groupId))
      ..orderBy([(r) => OrderingTerm.asc(r.dayOfMonth)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> createRule({
    required String groupId,
    required int amountPaisa,
    required String categoryId,
    required String payerMemberId,
    required int dayOfMonth,
    String? note,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final template = domain.RecurringTemplate(
      amountPaisa: amountPaisa,
      categoryId: categoryId,
      note: note,
      payerMemberId: payerMemberId,
    );
    await _db.into(_db.recurringRules).insert(
          RecurringRulesCompanion.insert(
            id: _uuid.v4(),
            groupId: groupId,
            templateJson: jsonEncode(template.toJson()),
            dayOfMonth: dayOfMonth,
            updatedAt: now,
          ),
        );
  }

  Future<void> setActive(String ruleId, bool active) async {
    await (_db.update(_db.recurringRules)..where((r) => r.id.equals(ruleId))).write(
      RecurringRulesCompanion(active: Value(active), updatedAt: Value(DateTime.now().millisecondsSinceEpoch)),
    );
  }

  Future<void> deleteRule(String ruleId) async {
    await (_db.delete(_db.recurringRules)..where((r) => r.id.equals(ruleId))).go();
  }

  /// Generates an expense instance for every active rule that's due (today's
  /// day-of-month has reached the rule's dayOfMonth) and hasn't already
  /// generated one for the current calendar month. Called on app open.
  /// The instance is split equally among the group's active members.
  Future<int> generateDueInstances(String groupId, {DateTime? today}) async {
    final now = today ?? DateTime.now();
    final currentYearMonth = yearMonthKey(now);

    final rules = await (_db.select(_db.recurringRules)
          ..where((r) => r.groupId.equals(groupId) & r.active.equals(true)))
        .get();

    final activeMembers = await (_db.select(_db.members)
          ..where((m) => m.groupId.equals(groupId) & m.active.equals(true)))
        .get();
    if (activeMembers.isEmpty) return 0;
    final memberIds = activeMembers.map((m) => m.id).toList();

    var generated = 0;
    for (final row in rules) {
      final template = domain.RecurringTemplate.fromJson(jsonDecode(row.templateJson) as Map<String, dynamic>);
      final alreadyGenerated = template.lastGeneratedYearMonth == currentYearMonth;
      final isDue = now.day >= row.dayOfMonth;
      if (alreadyGenerated || !isDue) continue;

      final expenseId = _uuid.v4();
      final nowMs = now.millisecondsSinceEpoch;
      final splits = SplitCalculator.equal(template.amountPaisa, memberIds);

      await _db.transaction(() async {
        await _db.into(_db.expenses).insert(
              ExpensesCompanion.insert(
                id: expenseId,
                groupId: groupId,
                amountPaisa: template.amountPaisa,
                date: nowMs,
                categoryId: template.categoryId,
                note: Value(template.note),
                isRecurringInstance: const Value(true),
                updatedAt: nowMs,
              ),
            );
        await _db.into(_db.expensePayers).insert(
              ExpensePayersCompanion.insert(
                expenseId: expenseId,
                memberId: template.payerMemberId,
                amountPaidPaisa: template.amountPaisa,
              ),
            );
        await _db.batch((batch) {
          batch.insertAll(_db.expenseSplits, [
            for (final entry in splits.entries)
              ExpenseSplitsCompanion.insert(
                expenseId: expenseId,
                memberId: entry.key,
                amountPaisa: entry.value,
                splitType: 'equal',
              ),
          ]);
        });

        final updatedTemplate = template.copyWith(lastGeneratedYearMonth: currentYearMonth);
        await (_db.update(_db.recurringRules)..where((r) => r.id.equals(row.id))).write(
          RecurringRulesCompanion(
            templateJson: Value(jsonEncode(updatedTemplate.toJson())),
            updatedAt: Value(nowMs),
          ),
        );
      });
      generated++;
    }
    return generated;
  }
}
