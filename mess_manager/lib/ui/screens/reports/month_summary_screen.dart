import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../../data/services/pdf_report_service.dart';
import '../../../domain/models/ledger_purpose.dart';
import '../../../domain/models/member.dart';
import '../../../domain/models/month_report.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/sync_refresh_indicator.dart';

class MonthSummaryScreen extends ConsumerStatefulWidget {
  const MonthSummaryScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<MonthSummaryScreen> createState() => _MonthSummaryScreenState();
}

class _MonthSummaryScreenState extends ConsumerState<MonthSummaryScreen> {
  final _shareKey = GlobalKey();
  bool _sharing = false;
  bool _exportingPdf = false;
  bool _closing = false;
  LedgerPurpose _ledger = LedgerPurpose.meal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != widget.groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(widget.groupId);
      }
    });

    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final month = ref.watch(selectedMonthProvider);
    final ledgerSeparate = ref.watch(selectedGroupProvider)?.mealLedgerSeparate ?? false;
    final reportAsync = ledgerSeparate
        ? ref.watch(monthReportByLedgerProvider(_ledger))
        : ref.watch(monthReportProvider);
    final members = ref.watch(membersOfSelectedGroupProvider).value ?? const [];
    final isClosed = ledgerSeparate
        ? ref.watch(isSelectedMonthClosedByLedgerProvider(_ledger))
        : ref.watch(isSelectedMonthClosedProvider);
    final groups = ref.watch(activeGroupsProvider).value ?? const [];
    final matchingGroup = groups.where((g) => g.id == widget.groupId);
    final groupName = matchingGroup.isEmpty ? '' : matchingGroup.first.name;
    final premium = ref.watch(premiumUnlockedProvider).value ?? false;

    return Scaffold(
      drawer: AppDrawer(groupId: widget.groupId),
      appBar: AppBar(
        title: Text(l10n.reportTitle(fmt.monthYear(month))),
        actions: [
          IconButton(icon: const Icon(Icons.chevron_left_rounded), onPressed: () => _goPrevious(context, month, premium)),
          IconButton(icon: const Icon(Icons.chevron_right_rounded), onPressed: () => ref.read(selectedMonthProvider.notifier).next()),
        ],
      ),
      body: SyncRefreshIndicator(
        groupId: widget.groupId,
        child: reportAsync.when(
        data: (report) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (ledgerSeparate) ...[
              SegmentedButton<LedgerPurpose>(
                segments: [
                  ButtonSegment(value: LedgerPurpose.meal, label: Text(l10n.ledgerMealTab), icon: const Icon(Icons.restaurant_rounded, size: 16)),
                  ButtonSegment(value: LedgerPurpose.general, label: Text(l10n.ledgerGeneralTab), icon: const Icon(Icons.home_rounded, size: 16)),
                ],
                selected: {_ledger},
                onSelectionChanged: (s) => setState(() => _ledger = s.first),
              ),
              const SizedBox(height: 14),
            ],
            if (isClosed)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                  border: Border.all(color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_rounded, size: 18, color: Theme.of(context).colorScheme.tertiary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(l10n.reportLockedBanner, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
            RepaintBoundary(
              key: _shareKey,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(4),
                child: _ReportContent(report: report, members: members, l10n: l10n, fmt: fmt, groupName: groupName),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: FilledButton.icon(
                    onPressed: _sharing ? null : () => _shareAsImage(context),
                    icon: const Icon(Icons.image_rounded, size: 18),
                    label: Text(l10n.reportShareImage, style: const TextStyle(fontSize: 12.5)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _exportingPdf
                        ? null
                        : () => premium ? _exportPdf(context, report, members, l10n, fmt, groupName) : context.push('/premium/paywall'),
                    child: Text(l10n.reportPdf, style: const TextStyle(fontSize: 12.5)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => premium ? _exportCsv(context, report, members) : context.push('/premium/paywall'),
                    child: Text(l10n.reportCsv, style: const TextStyle(fontSize: 12.5)),
                  ),
                ),
              ],
            ),
            if (!isClosed) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _closing ? null : () => _showCloseSheet(context, report),
                icon: Icon(Icons.lock_rounded, color: Theme.of(context).colorScheme.error, size: 18),
                label: Text(l10n.reportCloseMonth, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: BorderSide(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.4)),
                ),
              ),
            ],
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.commonErrorPrefix(e.toString()))),
        ),
      ),
      bottomNavigationBar: AppBottomNav(groupId: widget.groupId, current: AppTab.report),
    );
  }

  void _goPrevious(BuildContext context, DateTime currentMonth, bool premium) {
    final now = DateTime.now();
    final earliestFree = DateTime(now.year, now.month - 1, 1);
    if (!premium && !currentMonth.isAfter(earliestFree)) {
      context.push('/premium/paywall');
      return;
    }
    ref.read(selectedMonthProvider.notifier).previous();
  }

  Future<void> _shareAsImage(BuildContext context) async {
    setState(() => _sharing = true);
    try {
      final boundary = _shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 2.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/messbook_report_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      final l10n = context.mounted ? AppLocalizations.of(context) : null;
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: l10n?.reportShareChooserTitle),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _exportPdf(
    BuildContext context,
    MonthReport report,
    List<Member> members,
    AppLocalizations l10n,
    BdFormatter fmt,
    String groupName,
  ) async {
    setState(() => _exportingPdf = true);
    try {
      final doc = await PdfReportService.buildMonthReport(
        report: report,
        members: members,
        l10n: l10n,
        fmt: fmt,
        groupName: groupName,
      );
      final bytes = await doc.save();
      await Printing.sharePdf(bytes: Uint8List.fromList(bytes), filename: 'messbook_${report.yearMonth}.pdf');
    } finally {
      if (mounted) setState(() => _exportingPdf = false);
    }
  }

  Future<void> _exportCsv(BuildContext context, MonthReport report, List<Member> members) async {
    String nameOf(String id) {
      final matching = members.where((m) => m.id == id);
      return matching.isEmpty ? '?' : matching.first.name;
    }

    final buffer = StringBuffer('Member,Meals,MealBill,Shared,Paid+Deposits,Due\n');
    for (final row in report.rows) {
      buffer.writeln(
        '${nameOf(row.memberId)},${row.meals},${row.mealBillPaisa / 100},${row.sharedCostsPaisa / 100},${row.paidPlusDepositsPaisa / 100},${row.duePaisa / 100}',
      );
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/messbook_${report.yearMonth}.csv');
    await file.writeAsString(buffer.toString());
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  Future<void> _showCloseSheet(BuildContext context, MonthReport report) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final month = ref.read(selectedMonthProvider);
    final locale = ref.read(localeProvider);
    final banglaDigits = ref.read(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  child: const Icon(Icons.lock_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(l10n.reportCloseConfirmTitle(fmt.monthYear(month)), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
              ],
            ),
            const SizedBox(height: 10),
            Text(l10n.reportCloseConfirmBody, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: Text(l10n.reportCloseSnapshotSaved, style: const TextStyle(fontSize: 14)),
              subtitle: Text(l10n.reportCloseSnapshotSub, style: const TextStyle(fontSize: 11.5)),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: const Icon(Icons.move_down_rounded),
              title: Text(l10n.reportCloseCarryForward, style: const TextStyle(fontSize: 14)),
              subtitle: Text(l10n.reportCloseCarryForwardSub, style: const TextStyle(fontSize: 11.5)),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.of(sheetContext).pop(false), child: Text(l10n.commonCancel))),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(sheetContext).pop(true),
                    icon: const Icon(Icons.lock_rounded),
                    label: Text(l10n.reportCloseMonth),
                    style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;
    setState(() => _closing = true);
    try {
      final ledgerSeparate = ref.read(selectedGroupProvider)?.mealLedgerSeparate ?? false;
      await ref.read(monthsRepositoryProvider).closeMonth(
            groupId: widget.groupId,
            month: month,
            report: report,
            ledger: ledgerSeparate ? _ledger : LedgerPurpose.general,
          );
      triggerBackgroundSync(ref, widget.groupId);
      messenger.showSnackBar(SnackBar(
        content: Text(l10n.reportMonthClosed),
        action: SnackBarAction(
          label: l10n.reportStartNewMonth,
          onPressed: () => ref.read(selectedMonthProvider.notifier).next(),
        ),
      ));
    } finally {
      if (mounted) setState(() => _closing = false);
    }
  }

}

class _ReportContent extends StatelessWidget {
  const _ReportContent({required this.report, required this.members, required this.l10n, required this.fmt, required this.groupName});

  final MonthReport report;
  final List<Member> members;
  final AppLocalizations l10n;
  final BdFormatter fmt;
  final String groupName;

  String _nameOf(String memberId) {
    final matching = members.where((m) => m.id == memberId);
    return matching.isEmpty ? '?' : matching.first.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: AppColors.heroGradient, borderRadius: BorderRadius.circular(AppRadius.xxl)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(groupName, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _stat(l10n.reportTotalSpent, fmt.currency(report.totalSpentPaisa)),
                  _stat(l10n.reportTotalMeals, fmt.number(report.totalMeals)),
                  _stat(l10n.reportMealRate, fmt.currency(report.mealRatePaisaX100 ~/ 100)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 34,
                dataRowMinHeight: 34,
                dataRowMaxHeight: 34,
                columns: [
                  DataColumn(label: Text(l10n.reportColMember, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
                  DataColumn(label: Text(l10n.reportColMeals, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)), numeric: true),
                  DataColumn(label: Text(l10n.reportColMealBill, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)), numeric: true),
                  DataColumn(label: Text(l10n.reportColShared, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)), numeric: true),
                  DataColumn(label: Text(l10n.reportColPaid, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)), numeric: true),
                  DataColumn(label: Text(l10n.reportColDue, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)), numeric: true),
                ],
                rows: [
                  for (final row in report.rows)
                    DataRow(cells: [
                      DataCell(Text(_nameOf(row.memberId), style: const TextStyle(fontSize: 12))),
                      DataCell(Text(fmt.number(row.meals), style: const TextStyle(fontSize: 12, fontFamily: moneyFontFamily))),
                      DataCell(Text(fmt.number(row.mealBillPaisa / 100, decimals: 0), style: const TextStyle(fontSize: 12, fontFamily: moneyFontFamily))),
                      DataCell(Text(fmt.number(row.sharedCostsPaisa / 100, decimals: 0), style: const TextStyle(fontSize: 12, fontFamily: moneyFontFamily))),
                      DataCell(Text(fmt.number(row.paidPlusDepositsPaisa / 100, decimals: 0), style: const TextStyle(fontSize: 12, fontFamily: moneyFontFamily))),
                      DataCell(Text(
                        fmt.number(row.duePaisa / 100, decimals: 0),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: moneyFontFamily,
                          fontWeight: FontWeight.w800,
                          color: row.duePaisa >= 0 ? AppColors.teal700 : AppColors.coral600,
                        ),
                      )),
                    ]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
          const SizedBox(height: 2),
          Text(value, style: moneyTextStyle(fontSize: 15, color: Colors.white)),
        ],
      ),
    );
  }
}
