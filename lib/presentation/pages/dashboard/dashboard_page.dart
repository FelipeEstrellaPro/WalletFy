import 'dart:ui';
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
import '../../widgets/common/premium_glass_widgets.dart';
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
      extendBodyBehindAppBar: true,
      floatingActionButton: _QuickDepositFab(goals: goals),
      body: Stack(
        children: [
          // ── Immersive Soft Background ──
          const SoftAnimatedBackground(),

          // ── Content ──
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
                expandedHeight: 90,
                toolbarHeight: 80,
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${DateFormatter.greeting()}, ${settings?.userName.isNotEmpty == true ? settings!.userName : "Amigo"} 👋',
                        style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormatter.formatDayMonth(DateTime.now()),
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Summary Cards ─────────────────────────────
                    _SummaryCards(
                      totalSaved: totalSaved,
                      activeGoals: goals.length,
                      globalStreak: globalStreak,
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic),

                    const SizedBox(height: 28),

                    // ── 30-Day Chart ──────────────────────────────
                    _ThirtyDayChart(goals: goals)
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.1, curve: Curves.easeOutCubic),

                    const SizedBox(height: 28),

                    // ── Motivational Quote ────────────────────────
                    _QuoteCard()
                        .animate(delay: 300.ms)
                        .fadeIn(duration: 600.ms)
                        .slideX(begin: 0.05),

                    const SizedBox(height: 32),

                    // ── Active Goals ──────────────────────────────
                    if (goals.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.track_changes_rounded, color: cs.primary, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'Tus metas activas',
                            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ).animate(delay: 400.ms).fadeIn(),
                      const SizedBox(height: 16),
                      ...goals.asMap().entries.map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: GoalProgressCard(goal: e.value)
                                  .animate(delay: (450 + e.key * 80).ms)
                                  .fadeIn(duration: 500.ms)
                                  .slideX(begin: 0.05, curve: Curves.easeOutQuad),
                            ),
                          ),
                    ] else
                      _EmptyGoalsCard()
                          .animate(delay: 400.ms)
                          .fadeIn(duration: 600.ms)
                          .scaleXY(begin: 0.95),

                    const SizedBox(height: 100), // FAB padding
                  ]),
                ),
              ),
            ],
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
    final cs = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: GlassWrapper(
            padding: const EdgeInsets.all(24),
            customGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cs.primary.withValues(alpha: 0.8),
                cs.tertiary.withValues(alpha: 0.6),
              ],
            ),
            child: _HeroCardContent(
              title: 'Total Ahorrado',
              value: CurrencyFormatter.formatCompact(totalSaved),
              subtitle: 'en todas las metas',
              icon: Icons.account_balance_wallet_rounded,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              GlassWrapper(
                padding: const EdgeInsets.all(16),
                child: _MiniCardContent(
                  title: 'Metas',
                  value: '$activeGoals',
                  icon: Icons.flag_rounded,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 16),
              GlassWrapper(
                padding: const EdgeInsets.all(16),
                child: _MiniCardContent(
                  title: 'Racha',
                  value: '$globalStreak',
                  icon: globalStreak >= 7 ? Icons.local_fire_department_rounded : Icons.trending_up_rounded,
                  color: globalStreak >= 7 ? Colors.orange : cs.tertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroCardContent extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _HeroCardContent({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: tt.titleSmall?.copyWith(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          value,
          style: tt.displaySmall?.copyWith(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: tt.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}

class _MiniCardContent extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniCardContent({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 22, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: tt.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Text(value, style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
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

    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 29));
    ref.watch(activeGoalsProvider);

    final spots = _buildSpots(goals, from, now);

    return GlassWrapper(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progresión de 30 días', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  Text('Crecimiento estimado', style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up_rounded, size: 16, color: cs.primary),
                    const SizedBox(width: 4),
                    Text(
                      CurrencyFormatter.formatCompact(goals.fold(0.0, (s, g) => s + g.currentAmount)),
                      style: tt.labelLarge?.copyWith(color: cs.primary, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: spots.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.show_chart_rounded, size: 48, color: cs.onSurfaceVariant.withValues(alpha: 0.2)),
                        const SizedBox(height: 8),
                        Text('Registra ahorros para visualizar el gráfico',
                            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: null,
                        getDrawingHorizontalLine: (v) => FlLine(
                          color: cs.outlineVariant.withValues(alpha: 0.2),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (v, meta) => Text(
                              CurrencyFormatter.formatCompact(v),
                              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                            ),
                          ),
                        ),
                        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.4,
                          color: cs.primary,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          shadow: Shadow(color: cs.primary.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, 4)),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                cs.primary.withValues(alpha: 0.3),
                                cs.primary.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 800.ms),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _buildSpots(List<GoalEntity> goals, DateTime from, DateTime to) {
    if (goals.isEmpty) return [];
    final total = goals.fold(0.0, (s, g) => s + g.currentAmount);
    if (total <= 0) return [];

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

    return GlassWrapper(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.secondaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Text('✨', style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inspiración del día',
                  style: tt.labelMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"$quote"',
                  style: tt.bodyLarge?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
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
    
    return GlassWrapper(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Text('🎯', style: TextStyle(fontSize: 48)),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: -5, end: 5, duration: 2.seconds),
          const SizedBox(height: 24),
          Text('¡Crea tu primera meta!', style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('Ve a la sección Metas para empezar a ahorrar y construir tus sueños.',
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
    final cs = Theme.of(context).colorScheme;
    return FloatingActionButton.extended(
      onPressed: goals.isEmpty
          ? null
          : () => showDialog(
                context: context,
                builder: (_) => QuickDepositDialog(goals: goals),
              ),
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      icon: const Icon(Icons.add_rounded),
      label: const Text('Registrar ahorro', style: TextStyle(fontWeight: FontWeight.bold)),
      elevation: 8,
    ).animate().scale(
          begin: const Offset(0.8, 0.8),
          delay: 800.ms,
          duration: 400.ms,
          curve: Curves.elasticOut,
        );
  }
}
