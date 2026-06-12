import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/motivational_quotes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/goal_entity.dart';
import '../../providers/goals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/common/quick_deposit_dialog.dart';
import '../../widgets/goals/goal_progress_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsStreamProvider);
    final goalsAsync = ref.watch(activeGoalsProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final settings = settingsAsync.valueOrNull;
    final goals = goalsAsync.valueOrNull ?? [];
    final totalSaved = goals.fold(0.0, (s, g) => s + g.currentAmount);
    final globalStreak = settings?.globalStreak ?? 0;

    return Scaffold(
      backgroundColor: cs.surface,
      floatingActionButton: _QuickDepositFab(goals: goals),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: cs.surface,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${DateFormatter.greeting()}, ${settings?.userName.isNotEmpty == true ? settings!.userName : "Amigo"} 👋',
                  style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  DateFormatter.formatDayMonth(DateTime.now()),
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Summary Cards ─────────────────────────────
                _SummaryCards(
                  totalSaved: totalSaved,
                  activeGoals: goals.length,
                  globalStreak: globalStreak,
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),

                const SizedBox(height: 24),

                // ── 30-Day Chart ──────────────────────────────
                _ThirtyDayChart(goals: goals)
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1),

                const SizedBox(height: 24),

                // ── Motivational Quote ────────────────────────
                _QuoteCard()
                    .animate(delay: 300.ms)
                    .fadeIn(duration: 500.ms),

                const SizedBox(height: 24),

                // ── Active Goals ──────────────────────────────
                if (goals.isNotEmpty) ...[
                  Text(
                    'Tus metas activas',
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ).animate(delay: 400.ms).fadeIn(),
                  const SizedBox(height: 12),
                  ...goals.asMap().entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GoalProgressCard(goal: e.value)
                              .animate(delay: (450 + e.key * 60).ms)
                              .fadeIn(duration: 400.ms)
                              .slideX(begin: 0.05),
                        ),
                      ),
                ] else
                  _EmptyGoalsCard()
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 500.ms),

                const SizedBox(height: 80), // FAB padding
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Summary cards row
// ─────────────────────────────────────────────
class _SummaryCards extends StatelessWidget {
  final double totalSaved;
  final int activeGoals;
  final int globalStreak;

  const _SummaryCards({
    required this.totalSaved,
    required this.activeGoals,
    required this.globalStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _SummaryCard(
            title: 'Total Ahorrado',
            value: CurrencyFormatter.formatCompact(totalSaved),
            subtitle: 'en todas las metas',
            icon: Icons.account_balance_wallet_rounded,
            gradient: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'Metas',
            value: '$activeGoals',
            subtitle: 'activas',
            icon: Icons.flag_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'Racha',
            value: '$globalStreak',
            subtitle: globalStreak == 1 ? 'día' : 'días',
            icon: globalStreak >= 7
                ? Icons.local_fire_department_rounded
                : Icons.trending_up_rounded,
            streakMode: globalStreak >= 7,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final bool gradient;
  final bool streakMode;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.gradient = false,
    this.streakMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cs.primary, cs.tertiary],
              )
            : null,
        color: gradient ? null : cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        boxShadow: gradient
            ? [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: gradient
                    ? cs.onPrimary.withValues(alpha: 0.8)
                    : streakMode
                        ? Colors.orange
                        : cs.primary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: tt.labelSmall?.copyWith(
                    color: gradient
                        ? cs.onPrimary.withValues(alpha: 0.8)
                        : cs.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: gradient ? cs.onPrimary : cs.onSurface,
            ),
          ),
          Text(
            subtitle,
            style: tt.bodySmall?.copyWith(
              color: gradient
                  ? cs.onPrimary.withValues(alpha: 0.7)
                  : cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 30-day line chart
// ─────────────────────────────────────────────
class _ThirtyDayChart extends ConsumerWidget {
  final List<GoalEntity> goals;
  const _ThirtyDayChart({required this.goals});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Build 30-day cumulative savings data
    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 29));
    // Watch goals to trigger rebuild when amounts change
    ref.watch(activeGoalsProvider);

    // Generate spot data from goals progress over time
    // (Approximate with current amounts spread linearly)
    final spots = _buildSpots(goals, from, now);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progreso — 30 días',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  CurrencyFormatter.formatCompact(
                      goals.fold(0.0, (s, g) => s + g.currentAmount)),
                  style: tt.labelMedium?.copyWith(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: spots.isEmpty
                ? Center(
                    child: Text('Registra tu primer ahorro para ver el gráfico',
                        style: tt.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant)),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: null,
                        getDrawingHorizontalLine: (v) => FlLine(
                          color: cs.outlineVariant.withValues(alpha: 0.3),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (v, meta) => Text(
                              CurrencyFormatter.formatCompact(v),
                              style: tt.labelSmall
                                  ?.copyWith(color: cs.onSurfaceVariant),
                            ),
                          ),
                        ),
                        bottomTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: cs.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                cs.primary.withValues(alpha: 0.25),
                                cs.primary.withValues(alpha: 0.01),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _buildSpots(
      List<GoalEntity> goals, DateTime from, DateTime to) {
    if (goals.isEmpty) return [];
    final total = goals.fold(0.0, (s, g) => s + g.currentAmount);
    if (total <= 0) return [];

    // Simple approximation: linear growth from 0 to current
    final days = to.difference(from).inDays;
    return List.generate(days + 1, (i) {
      final ratio = i / days;
      return FlSpot(i.toDouble(), total * ratio);
    });
  }
}

// ─────────────────────────────────────────────
// Motivational quote card
// ─────────────────────────────────────────────
class _QuoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final quote = MotivationalQuotes.todayQuote;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.secondaryContainer,
            cs.tertiaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('✨', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Frase del día',
                  style: tt.labelSmall?.copyWith(
                      color: cs.onSecondaryContainer.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 4),
                Text(
                  quote,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty goals state
// ─────────────────────────────────────────────
class _EmptyGoalsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.5),
            style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Text('🎯', style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text('¡Crea tu primera meta!',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Ve a la sección Metas para empezar a ahorrar.',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Quick deposit FAB
// ─────────────────────────────────────────────
class _QuickDepositFab extends StatelessWidget {
  final List<GoalEntity> goals;
  const _QuickDepositFab({required this.goals});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: goals.isEmpty
          ? null
          : () => showDialog(
                context: context,
                builder: (_) => QuickDepositDialog(goals: goals),
              ),
      icon: const Icon(Icons.add_rounded),
      label: const Text('Registrar ahorro'),
      elevation: 6,
    ).animate().scale(
          begin: const Offset(0.8, 0.8),
          delay: 800.ms,
          duration: 400.ms,
          curve: Curves.elasticOut,
        );
  }
}
