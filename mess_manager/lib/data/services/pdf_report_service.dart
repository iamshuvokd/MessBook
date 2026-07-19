import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/l10n/app_localizations.dart';
import '../../core/utils/bd_formatter.dart';
import '../../domain/models/member.dart';
import '../../domain/models/month_report.dart';

class PdfReportService {
  /// Builds a per-member month summary PDF. Embeds Hind Siliguri so Bengali
  /// text/digits render correctly regardless of the active locale.
  static Future<pw.Document> buildMonthReport({
    required MonthReport report,
    required List<Member> members,
    required AppLocalizations l10n,
    required BdFormatter fmt,
    required String groupName,
  }) async {
    final fontData = await rootBundle.load('assets/fonts/HindSiliguri-Regular.ttf');
    final boldFontData = await rootBundle.load('assets/fonts/HindSiliguri-SemiBold.ttf');
    final font = pw.Font.ttf(fontData);
    final boldFont = pw.Font.ttf(boldFontData);

    String nameOf(String memberId) {
      final matching = members.where((m) => m.id == memberId);
      return matching.isEmpty ? '?' : matching.first.name;
    }

    final doc = pw.Document(theme: pw.ThemeData.withFont(base: font, bold: boldFont));

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(groupName, style: pw.TextStyle(font: boldFont, fontSize: 20)),
              pw.SizedBox(height: 4),
              pw.Text(l10n.reportTitle(fmt.monthYear(DateTime.parse('${report.yearMonth}-01')))),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${l10n.reportTotalSpent}: ${fmt.currency(report.totalSpentPaisa)}'),
                  pw.Text('${l10n.reportTotalMeals}: ${fmt.number(report.totalMeals)}'),
                  pw.Text('${l10n.reportMealRate}: ${fmt.currency(report.mealRatePaisaX100 ~/ 100)}'),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(1.4),
                  3: pw.FlexColumnWidth(1.4),
                  4: pw.FlexColumnWidth(1.4),
                  5: pw.FlexColumnWidth(1.2),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _cell(l10n.reportColMember, boldFont, header: true),
                      _cell(l10n.reportColMeals, boldFont, header: true),
                      _cell(l10n.reportColMealBill, boldFont, header: true),
                      _cell(l10n.reportColShared, boldFont, header: true),
                      _cell(l10n.reportColPaid, boldFont, header: true),
                      _cell(l10n.reportColDue, boldFont, header: true),
                    ],
                  ),
                  for (final row in report.rows)
                    pw.TableRow(
                      children: [
                        _cell(nameOf(row.memberId), font),
                        _cell(fmt.number(row.meals), font),
                        _cell(fmt.number(row.mealBillPaisa / 100, decimals: 2), font),
                        _cell(fmt.number(row.sharedCostsPaisa / 100, decimals: 2), font),
                        _cell(fmt.number(row.paidPlusDepositsPaisa / 100, decimals: 2), font),
                        _cell(fmt.number(row.duePaisa / 100, decimals: 2), font),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return doc;
  }

  static pw.Widget _cell(String text, pw.Font font, {bool header = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: header ? 10 : 9, fontWeight: header ? pw.FontWeight.bold : null),
      ),
    );
  }
}
