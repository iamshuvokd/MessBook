/// A single member's row in a month summary report.
class MonthReportRow {
  const MonthReportRow({
    required this.memberId,
    required this.meals,
    required this.mealBillPaisa,
    required this.sharedCostsPaisa,
    required this.paidPlusDepositsPaisa,
    required this.duePaisa,
  });

  final String memberId;
  final double meals;
  final int mealBillPaisa;
  final int sharedCostsPaisa;
  final int paidPlusDepositsPaisa;
  final int duePaisa;

  factory MonthReportRow.fromJson(Map<String, dynamic> json) => MonthReportRow(
        memberId: json['memberId'] as String,
        meals: (json['meals'] as num).toDouble(),
        mealBillPaisa: json['mealBillPaisa'] as int,
        sharedCostsPaisa: json['sharedCostsPaisa'] as int,
        paidPlusDepositsPaisa: json['paidPlusDepositsPaisa'] as int,
        duePaisa: json['duePaisa'] as int,
      );

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'meals': meals,
        'mealBillPaisa': mealBillPaisa,
        'sharedCostsPaisa': sharedCostsPaisa,
        'paidPlusDepositsPaisa': paidPlusDepositsPaisa,
        'duePaisa': duePaisa,
      };
}

/// Full frozen report for one group's month, as stored in `months.snapshotJson`.
class MonthReport {
  const MonthReport({
    required this.yearMonth,
    required this.totalSpentPaisa,
    required this.totalMeals,
    required this.mealRatePaisaX100,
    required this.rows,
  });

  final String yearMonth; // 'YYYY-MM'
  final int totalSpentPaisa;
  final double totalMeals;
  final int mealRatePaisaX100;
  final List<MonthReportRow> rows;

  factory MonthReport.fromJson(Map<String, dynamic> json) => MonthReport(
        yearMonth: json['yearMonth'] as String,
        totalSpentPaisa: json['totalSpentPaisa'] as int,
        totalMeals: (json['totalMeals'] as num).toDouble(),
        mealRatePaisaX100: json['mealRatePaisaX100'] as int,
        rows: [for (final r in json['rows'] as List) MonthReportRow.fromJson(r as Map<String, dynamic>)],
      );

  Map<String, dynamic> toJson() => {
        'yearMonth': yearMonth,
        'totalSpentPaisa': totalSpentPaisa,
        'totalMeals': totalMeals,
        'mealRatePaisaX100': mealRatePaisaX100,
        'rows': [for (final r in rows) r.toJson()],
      };
}
