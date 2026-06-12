import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/database_provider.dart';
import '../../providers/goals_provider.dart';
import '../../widgets/common/quick_deposit_dialog.dart';

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
          body: CustomScrollView(
            slivers: [
              // ── App Bar con menú ─────────────────────────────
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: cs.surface,
                iconTheme: IconThemeData(color: goalColor),
                actions: [
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded, color: goalColor),
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
                        child: Text(goal.frozenStreak > 0
                            ? 'Descongelar racha'
                            : 'Congelar racha (1 día)'),
                      ),
                      const PopupMenuItem(
                        value: 'archive',
                        child: Text('Archivar meta'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Eliminar meta',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _HeaderBackground(goal: goal, color: goalColor),
                ),
              ),

              // ── Goal Info & Progress ─────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      if (goal.frozenStreak > 0)
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.ac_unit_rounded, color: Colors.blue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tu racha está congelada. Haz un depósito hoy para no perderla.',
                                  style: tt.bodySmall?.copyWith(color: Colors.blue.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),

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
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              title: 'Faltan',
                              value: CurrencyFormatter.formatCompact(
                                  goal.targetAmount - goal.currentAmount),
                              icon: Icons.trending_up_rounded,
                              color: cs.primary,
                            ),
                          ),
                          if (goal.deadline != null) ...[
                            const SizedBox(width: 12),
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
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Historial',
                            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 16),
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long_rounded,
                                size: 64, color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            Text('Aún no hay depósitos',
                                style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final tx = txs[index];
                        final isDeposit = tx.isDeposit;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                          leading: CircleAvatar(
                            backgroundColor: (isDeposit ? Colors.green : Colors.red)
                                .withValues(alpha: 0.1),
                            child: Icon(
                              isDeposit ? Icons.add_rounded : Icons.remove_rounded,
                              color: isDeposit ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(tx.note ?? (isDeposit ? 'Depósito' : 'Retiro')),
                          subtitle: Text(DateFormatter.formatFull(tx.date)),
                          trailing: Text(
                            '${isDeposit ? '+' : '-'}${CurrencyFormatter.format(tx.amount)}',
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDeposit ? Colors.green : Colors.red,
                            ),
                          ),
                        );
                      },
                      childCount: txs.length,
                    ),
                  );
                },
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)), // FAB space
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => QuickDepositDialog(goals: [goal]),
            ),
            backgroundColor: goalColor,
            foregroundColor: goalColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Abonar'),
          ),
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
            color.withValues(alpha: 0.2),
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(goal.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              goal.title,
              style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Text(
              CurrencyFormatter.format(goal.currentAmount),
              style: tt.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              'de ${CurrencyFormatter.format(goal.targetAmount)}',
              style: tt.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(title, style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
