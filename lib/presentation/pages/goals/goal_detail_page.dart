import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/database_provider.dart';
import '../../providers/goals_provider.dart';
import '../../widgets/common/quick_deposit_dialog.dart';
import '../../widgets/common/premium_glass_widgets.dart';

class GoalDetailPage extends ConsumerWidget {
  final int goalId;

  const GoalDetailPage({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(goalDetailProvider(goalId));
    final txAsync = ref.watch(goalTransactionsProvider(goalId));

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return goalAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (goal) {
        final goalColor = AppTheme.hexToColor(goal.colorHex);

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
                  // ── App Bar con menú ─────────────────────────────
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: cs.surface.withValues(alpha: 0.7),
                    surfaceTintColor: Colors.transparent,
                    iconTheme: IconThemeData(color: goalColor),
                    flexibleSpace: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: FlexibleSpaceBar(
                          background: _HeaderBackground(goal: goal, color: goalColor),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: PopupMenuButton<String>(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.more_vert_rounded, color: goalColor),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          onSelected: (value) async {
                            final repo = ref.read(goalRepositoryProvider);
                            if (value == 'freeze') {
                              await repo.updateGoal(
                                goal.copyWith(frozenStreak: goal.frozenStreak > 0 ? 0 : 1),
                              );
                            } else if (value == 'archive') {
                              await repo.archiveGoal(goal.id);
                              if (context.mounted) Navigator.pop(context);
                            } else if (value == 'delete') {
                              await repo.deleteGoal(goal.id);
                              if (context.mounted) Navigator.pop(context);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'freeze',
                              child: Row(
                                children: [
                                  Icon(Icons.ac_unit_rounded, size: 20, color: goal.frozenStreak > 0 ? Colors.blue : cs.onSurface),
                                  const SizedBox(width: 12),
                                  Text(goal.frozenStreak > 0 ? 'Descongelar racha' : 'Congelar racha (1 día)'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'archive',
                              child: Row(
                                children: [
                                  Icon(Icons.archive_outlined, size: 20),
                                  SizedBox(width: 12),
                                  Text('Archivar meta'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red),
                                  SizedBox(width: 12),
                                  Text('Eliminar meta', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ── Goal Info & Progress ─────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          if (goal.frozenStreak > 0)
                            GlassWrapper(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.2), shape: BoxShape.circle),
                                    child: const Icon(Icons.ac_unit_rounded, color: Colors.blue, size: 20),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      'Tu racha está congelada. Haz un depósito hoy para no perderla.',
                                      style: tt.bodySmall?.copyWith(color: Colors.blue.shade300, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn().slideY(begin: 0.1),
                          if (goal.frozenStreak > 0) const SizedBox(height: 24),

                          // Stats Row
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Progreso',
                                  value: CurrencyFormatter.formatPercent(goal.progressRatio),
                                  icon: Icons.pie_chart_rounded,
                                  color: goalColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _StatCard(
                                  title: 'Faltan',
                                  value: CurrencyFormatter.formatCompact(goal.targetAmount - goal.currentAmount),
                                  icon: Icons.trending_up_rounded,
                                  color: cs.primary,
                                ),
                              ),
                              if (goal.deadline != null) ...[
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StatCard(
                                    title: 'Días',
                                    value: '${goal.daysRemaining ?? 0}',
                                    icon: Icons.calendar_today_rounded,
                                    color: Colors.orange,
                                  ),
                                ),
                              ]
                            ],
                          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                          const SizedBox(height: 48),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: cs.surfaceContainerHighest, shape: BoxShape.circle),
                                  child: const Icon(Icons.history_rounded, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Text('Historial de Depósitos', style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ).animate().fadeIn(delay: 300.ms),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // ── Transactions List ────────────────────────────
                  txAsync.when(
                    loading: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => SliverFillRemaining(
                      child: Center(child: Text('Error: $e')),
                    ),
                    data: (txs) {
                      if (txs.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: GlassWrapper(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.receipt_long_rounded, size: 56, color: cs.primary),
                                  ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: -5, end: 5, duration: 3.seconds),
                                  const SizedBox(height: 24),
                                  Text('Aún no hay depósitos', style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 8),
                                  Text('Registra tu primer ahorro y comienza la racha.',
                                      textAlign: TextAlign.center,
                                      style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                                ],
                              ),
                            ).animate().fadeIn().scaleXY(begin: 0.95),
                          ),
                        );
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final tx = txs[index];
                              final isDeposit = tx.isDeposit;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GlassWrapper(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: (isDeposit ? Colors.green : Colors.red).withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isDeposit ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                          color: isDeposit ? Colors.green : Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tx.note ?? (isDeposit ? 'Depósito' : 'Retiro'),
                                              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              DateFormatter.formatFull(tx.date),
                                              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '${isDeposit ? '+' : '-'}${CurrencyFormatter.format(tx.amount)}',
                                        style: tt.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: isDeposit ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate(delay: (400 + index * 50).ms).fadeIn().slideX(begin: 0.05),
                              );
                            },
                            childCount: txs.length,
                          ),
                        ),
                      );
                    },
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 120)), // FAB space
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => QuickDepositDialog(goals: [goal]),
            ),
            backgroundColor: goalColor,
            foregroundColor: goalColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            elevation: 8,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Abonar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ).animate(delay: 600.ms).scaleXY(begin: 0.8, curve: Curves.easeOutBack),
        );
      },
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  final dynamic goal;
  final Color color;

  const _HeaderBackground({required this.goal, required this.color});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.4),
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 20)
                ]
              ),
              child: Text(goal.emoji, style: const TextStyle(fontSize: 56)),
            ).animate().scaleXY(curve: Curves.easeOutBack, duration: 600.ms),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                goal.title,
                textAlign: TextAlign.center,
                style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ).animate(delay: 200.ms).fadeIn(),
            ),
            const SizedBox(height: 16),
            Text(
              CurrencyFormatter.format(goal.currentAmount),
              style: tt.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ).animate(delay: 300.ms).fadeIn(),
            Text(
              'de ${CurrencyFormatter.format(goal.targetAmount)}',
              style: tt.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600
              ),
            ).animate(delay: 400.ms).fadeIn(),
          ],
        ),
      ),
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
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: tt.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
