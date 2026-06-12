import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/goal_entity.dart';
import '../../pages/goals/goal_detail_page.dart';

/// Compact goal card for dashboard and goals list.
class GoalProgressCard extends StatelessWidget {
  final GoalEntity goal;
  final bool compact;

  const GoalProgressCard({
    super.key,
    required this.goal,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final goalColor = AppTheme.hexToColor(goal.colorHex);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GoalDetailPage(goalId: goal.id),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: goalColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Emoji badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: goalColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(goal.emoji,
                        style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 12),
                // Name & deadline
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: tt.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (goal.deadline != null)
                        Text(
                          goal.daysRemaining != null
                              ? '${goal.daysRemaining! > 0 ? "En" : "Venció hace"} '
                                  '${goal.daysRemaining!.abs()} días'
                              : '',
                          style: tt.bodySmall?.copyWith(
                            color: goal.daysRemaining != null &&
                                    goal.daysRemaining! < 7
                                ? Colors.orange
                                : cs.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                // Streak badge
                if (goal.streak > 0)
                  _StreakBadge(streak: goal.streak, frozen: goal.frozenStreak > 0),
              ],
            ),

            const SizedBox(height: 16),

            // Progress bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: goal.progressRatio),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) =>
                          LinearProgressIndicator(
                        value: value,
                        minHeight: 8,
                        backgroundColor: goalColor.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation(goalColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  CurrencyFormatter.formatPercent(goal.progressRatio),
                  style: tt.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: goalColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Amounts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyFormatter.format(goal.currentAmount),
                  style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600, color: cs.onSurface),
                ),
                Text(
                  'de ${CurrencyFormatter.format(goal.targetAmount)}',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),

            if (goal.frozenStreak > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.ac_unit_rounded,
                        size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      'Racha congelada — ahorra hoy para no perderla',
                      style: tt.labelSmall
                          ?.copyWith(color: Colors.amber.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int streak;
  final bool frozen;
  const _StreakBadge({required this.streak, required this.frozen});

  @override
  Widget build(BuildContext context) {
    final color = frozen ? Colors.blue : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            frozen
                ? Icons.ac_unit_rounded
                : Icons.local_fire_department_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            '$streak',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color),
          ),
        ],
      ),
    );
  }
}
