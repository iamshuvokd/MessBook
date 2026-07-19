import 'package:drift/drift.dart';

import '../db/app_database.dart';

class CategorySlice {
  const CategorySlice({required this.categoryId, required this.defaultKey, required this.name, required this.amountPaisa});
  final String categoryId;
  final String? defaultKey;
  final String name;
  final int amountPaisa;
}

class MonthlyTotal {
  const MonthlyTotal({required this.month, required this.totalPaisa});
  final DateTime month;
  final int totalPaisa;
}

class ChartsRepository {
  ChartsRepository(this._db);

  final AppDatabase _db;

  Future<List<CategorySlice>> categoryBreakdown(String groupId, DateTime month) async {
    final start = DateTime(month.year, month.month, 1).millisecondsSinceEpoch;
    final end = DateTime(month.year, month.month + 1, 1).millisecondsSinceEpoch;

    final expenses = await (_db.select(_db.expenses)
          ..where((e) =>
              e.groupId.equals(groupId) &
              e.deleted.equals(false) &
              e.date.isBiggerOrEqualValue(start) &
              e.date.isSmallerThanValue(end)))
        .get();
    final categories = {for (final c in await _db.select(_db.categories).get()) c.id: c};

    final totals = <String, int>{};
    for (final e in expenses) {
      totals[e.categoryId] = (totals[e.categoryId] ?? 0) + e.amountPaisa;
    }

    final slices = totals.entries
        .map((entry) {
          final cat = categories[entry.key];
          return CategorySlice(
            categoryId: entry.key,
            defaultKey: cat?.defaultKey,
            name: cat?.name ?? '?',
            amountPaisa: entry.value,
          );
        })
        .toList()
      ..sort((a, b) => b.amountPaisa.compareTo(a.amountPaisa));
    return slices;
  }

  Future<List<MonthlyTotal>> monthlyTrend(String groupId, {int months = 6}) async {
    final now = DateTime.now();
    final results = <MonthlyTotal>[];
    for (var i = months - 1; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final start = month.millisecondsSinceEpoch;
      final end = DateTime(month.year, month.month + 1, 1).millisecondsSinceEpoch;
      final total = await (_db.selectOnly(_db.expenses)
            ..addColumns([_db.expenses.amountPaisa.sum()])
            ..where(_db.expenses.groupId.equals(groupId) &
                _db.expenses.deleted.equals(false) &
                _db.expenses.date.isBiggerOrEqualValue(start) &
                _db.expenses.date.isSmallerThanValue(end)))
          .getSingleOrNull();
      final sum = total?.read(_db.expenses.amountPaisa.sum()) ?? 0;
      results.add(MonthlyTotal(month: month, totalPaisa: sum));
    }
    return results;
  }
}
