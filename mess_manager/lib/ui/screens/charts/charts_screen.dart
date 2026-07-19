import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/category_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/bd_formatter.dart';
import '../../providers/app_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/sync_refresh_indicator.dart';

const _sliceColors = [
  AppColors.teal400,
  AppColors.honey300,
  AppColors.coral400,
  AppColors.neutral500,
  AppColors.teal700,
  AppColors.honey600,
];

class ChartsScreen extends ConsumerWidget {
  const ChartsScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    Future.microtask(() {
      if (ref.read(selectedGroupIdProvider) != groupId) {
        ref.read(selectedGroupIdProvider.notifier).select(groupId);
      }
    });

    final locale = ref.watch(localeProvider);
    final banglaDigits = ref.watch(banglaDigitsProvider);
    final fmt = BdFormatter(useBanglaDigits: banglaDigits, locale: locale.languageCode);
    final month = ref.watch(selectedMonthProvider);
    final breakdown = ref.watch(categoryBreakdownProvider);
    final trend = ref.watch(monthlyTrendProvider);
    final premium = ref.watch(premiumUnlockedProvider).value ?? false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Row(children: [
          Text(l10n.chartsTitle),
          const SizedBox(width: 8),
          Chip(label: Text(l10n.commonProBadge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)), visualDensity: VisualDensity.compact),
        ]),
      ),
      body: !premium
          ? _PremiumGate(l10n: l10n)
          : SyncRefreshIndicator(
        groupId: groupId,
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.chartsWhereWentTitle(fmt.monthYear(month)), style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  breakdown.when(
                    data: (slices) {
                      if (slices.isEmpty) return Padding(padding: const EdgeInsets.all(20), child: Text(l10n.chartsNoData));
                      final total = slices.fold<int>(0, (a, s) => a + s.amountPaisa);
                      return Row(
                        children: [
                          SizedBox(
                            width: 130,
                            height: 130,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 40,
                                    sections: [
                                      for (var i = 0; i < slices.length; i++)
                                        PieChartSectionData(
                                          value: slices[i].amountPaisa.toDouble(),
                                          color: _sliceColors[i % _sliceColors.length],
                                          radius: 20,
                                          showTitle: false,
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(fmt.currency(total), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                                    Text(l10n.chartsTotal, style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: [
                                for (var i = 0; i < slices.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Container(width: 10, height: 10, decoration: BoxDecoration(color: _sliceColors[i % _sliceColors.length], borderRadius: BorderRadius.circular(3))),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(resolveCategoryName(l10n, slices[i].defaultKey, slices[i].name), style: const TextStyle(fontSize: 12.5), overflow: TextOverflow.ellipsis)),
                                        Text('${(slices[i].amountPaisa / total * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Padding(padding: EdgeInsets.all(30), child: Center(child: CircularProgressIndicator())),
                    error: (e, _) => Text(l10n.commonErrorPrefix(e.toString())),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.chartsTrendTitle, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
                      Text(l10n.chartsTrendMonths(6), style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  trend.when(
                    data: (months) {
                      if (months.every((m) => m.totalPaisa == 0)) {
                        return Padding(padding: const EdgeInsets.all(20), child: Text(l10n.chartsNoData));
                      }
                      final maxY = months.map((m) => m.totalPaisa).fold<int>(0, (a, b) => a > b ? a : b).toDouble();
                      return SizedBox(
                        height: 140,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final i = value.toInt();
                                    if (i < 0 || i >= months.length) return const SizedBox.shrink();
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(_shortMonth(months[i].month, locale.languageCode), style: const TextStyle(fontSize: 9)),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            minY: 0,
                            maxY: maxY == 0 ? 1 : maxY * 1.2,
                            lineBarsData: [
                              LineChartBarData(
                                spots: [for (var i = 0; i < months.length; i++) FlSpot(i.toDouble(), months[i].totalPaisa.toDouble())],
                                isCurved: true,
                                color: AppColors.teal400,
                                barWidth: 2.5,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(show: true, color: AppColors.teal400.withValues(alpha: 0.12)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const Padding(padding: EdgeInsets.all(30), child: Center(child: CircularProgressIndicator())),
                    error: (e, _) => Text(l10n.commonErrorPrefix(e.toString())),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  String _shortMonth(DateTime month, String locale) {
    const enNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const bnNames = ['জানু', 'ফেব্রু', 'মার্চ', 'এপ্রি', 'মে', 'জুন', 'জুলা', 'আগ', 'সেপ্টে', 'অক্টো', 'নভে', 'ডিসে'];
    return locale == 'bn' ? bnNames[month.month - 1] : enNames[month.month - 1];
  }
}

class _PremiumGate extends StatelessWidget {
  const _PremiumGate({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(gradient: AppColors.accentGradient, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Icon(Icons.insights_rounded, color: Color(0xFF3D2C05), size: 32),
            ),
            const SizedBox(height: 20),
            Text(l10n.chartsPremiumTitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(l10n.chartsPremiumBody, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 20),
            FilledButton(onPressed: () => context.push('/premium/paywall'), child: Text(l10n.chartsUnlockButton)),
          ],
        ),
      ),
    );
  }
}
