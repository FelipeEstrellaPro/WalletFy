import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/analytics_state.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/common/premium_glass_widgets.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(analyticsDataProvider);
    final currentPeriod = ref.watch(analyticsPeriodNotifierProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Premium Soft Background ──
          const SoftAnimatedBackground(),

          // ── Main Content ──
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Glass App Bar ──
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: cs.surface.withValues(alpha: 0.7),
                surfaceTintColor: Colors.transparent,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                elevation: 0,
                expandedHeight: 80,
                toolbarHeight: 70,
                title: Text(
                  'Analíticas',
                  style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      onPressed: () => _exportData(context),
                      icon: const Icon(Icons.file_download_outlined),
                      tooltip: 'Exportar a CSV',
                      style: IconButton.styleFrom(
                        backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),

              SliverPadding(
                padding: const EdgeInsets.only(bottom: 40),
                sliver: stateAsync.when(
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => SliverFillRemaining(
                    child: Center(child: Text('Error: $e')),
                  ),
                  data: (state) {
                    if (state.transactionCount == 0) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyState(context, currentPeriod, ref),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildListDelegate([
                        // Period Selector
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: GlassWrapper(
                            padding: const EdgeInsets.all(8),
                            child: _PeriodSelector(
                              current: currentPeriod,
                              onChanged: (p) => ref
                                  .read(analyticsPeriodNotifierProvider.notifier)
                                  .setPeriod(p),
                            ),
                          ),
                        ),

                        // Overview Cards
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Total Ahorrado',
                                  value: CurrencyFormatter.formatCompact(state.totalDeposited),
                                  icon: Icons.account_balance_wallet_rounded,
                                  color: cs.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _StatCard(
                                  title: 'Abono Promedio',
                                  value: CurrencyFormatter.formatCompact(state.averageDeposit),
                                  icon: Icons.analytics_rounded,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _StatCard(
                                  title: 'Racha Max',
                                  value: '${state.bestStreak}d',
                                  icon: Icons.local_fire_department_rounded,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                        ),

                        // Bar Chart
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: GlassWrapper(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.bar_chart_rounded, color: cs.primary),
                                    const SizedBox(width: 8),
                                    Text('Ahorro por período',
                                        style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  height: 240,
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      barTouchData: BarTouchData(enabled: false),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (v, meta) {
                                              if (v.toInt() >= state.barData.length) return const SizedBox();
                                              final pt = state.barData[v.toInt()];
                                              String label = '';
                                              if (currentPeriod == AnalyticsPeriod.year ||
                                                  currentPeriod == AnalyticsPeriod.all) {
                                                label = pt.label.length >= 7
                                                    ? pt.label.substring(5, 7) // Month
                                                    : pt.label;
                                              } else {
                                                label = pt.label.length >= 10
                                                    ? pt.label.substring(8, 10) // Day
                                                    : pt.label;
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 8),
                                                child: Text(
                                                  label,
                                                  style: tt.labelSmall?.copyWith(
                                                      color: cs.onSurfaceVariant, fontWeight: FontWeight.bold),
                                                ),
                                              );
                                            },
                                            reservedSize: 28,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 40,
                                            getTitlesWidget: (v, meta) => Text(
                                              CurrencyFormatter.formatCompact(v),
                                              style: tt.labelSmall?.copyWith(
                                                  color: cs.onSurfaceVariant),
                                            ),
                                          ),
                                        ),
                                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine: false,
                                        getDrawingHorizontalLine: (value) => FlLine(
                                          color: cs.outlineVariant.withValues(alpha: 0.2),
                                          strokeWidth: 1,
                                          dashArray: [5, 5],
                                        ),
                                      ),
                                      barGroups: state.barData.asMap().entries.map((e) {
                                        return BarChartGroupData(
                                          x: e.key,
                                          barRods: [
                                            BarChartRodData(
                                              toY: e.value.amount,
                                              color: cs.primary,
                                              width: 18,
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(6),
                                                topRight: Radius.circular(6),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate(delay: 200.ms).fadeIn().scaleXY(begin: 0.95),
                        ),

                        // Donut Chart (Distribution)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: GlassWrapper(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.pie_chart_rounded, color: cs.secondary),
                                    const SizedBox(width: 8),
                                    Text('Distribución por Meta',
                                        style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                if (state.donutData.isEmpty)
                                  const Center(child: Text('Sin datos'))
                                else
                                  SizedBox(
                                    height: 220,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: PieChart(
                                            PieChartData(
                                              sectionsSpace: 4,
                                              centerSpaceRadius: 50,
                                              sections: state.donutData.map((slice) {
                                                final color = AppTheme.hexToColor(slice.goal.colorHex);
                                                return PieChartSectionData(
                                                  color: color,
                                                  value: slice.percentage,
                                                  title: '${(slice.percentage * 100).toInt()}%',
                                                  radius: 40,
                                                  titleStyle: tt.labelMedium?.copyWith(
                                                    color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 32),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: state.donutData.length,
                                            itemBuilder: (context, i) {
                                              final slice = state.donutData[i];
                                              final color = AppTheme.hexToColor(slice.goal.colorHex);
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 12),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 14,
                                                      height: 14,
                                                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Text(
                                                        slice.goal.title,
                                                        style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ).animate(delay: 300.ms).fadeIn().scaleXY(begin: 0.95),
                        ),
                      ]),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AnalyticsPeriod period, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: GlassWrapper(
            padding: const EdgeInsets.all(8),
            child: _PeriodSelector(
              current: period,
              onChanged: (p) => ref.read(analyticsPeriodNotifierProvider.notifier).setPeriod(p),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: GlassWrapper(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.query_stats_rounded, size: 64, color: cs.primary),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: -5, end: 5, duration: 3.seconds),
                  const SizedBox(height: 24),
                  Text('Aún no hay datos', style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text('Registra transacciones en este período\npara ver tus analíticas.',
                      textAlign: TextAlign.center,
                      style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ).animate().fadeIn().scaleXY(begin: 0.95),
          ),
        ),
      ],
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportación a CSV generada (Mock FASE 5)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final AnalyticsPeriod current;
  final ValueChanged<AnalyticsPeriod> onChanged;

  const _PeriodSelector({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: AnalyticsPeriod.values.map((p) {
        final isSelected = current == p;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? cs.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [BoxShadow(color: cs.primary.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 2))]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                p.label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GlassWrapper(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: tt.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
