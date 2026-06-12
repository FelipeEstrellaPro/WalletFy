import '../entities/goal_entity.dart';
import '../entities/transaction_entity.dart';

/// Calculates the projected completion date for a goal
/// based on the average daily deposit rate.
class ProjectGoalCompletionUseCase {
  const ProjectGoalCompletionUseCase();

  /// Returns projected completion date or null if no data / already done.
  DateTime? call({
    required GoalEntity goal,
    required List<TransactionEntity> transactions,
  }) {
    if (goal.isCompleted) return null;

    final deposits = transactions
        .where((t) => t.category != TransactionCategory.withdrawal)
        .toList();

    if (deposits.isEmpty) return null;

    deposits.sort((a, b) => a.date.compareTo(b.date));
    final firstDate = deposits.first.date;
    final daysCovered =
        DateTime.now().difference(firstDate).inDays.clamp(1, 9999);
    final totalDeposited =
        deposits.fold(0.0, (sum, t) => sum + t.amount);
    final dailyRate = totalDeposited / daysCovered;

    if (dailyRate <= 0) return null;

    final daysNeeded = (goal.remaining / dailyRate).ceil();
    return DateTime.now().add(Duration(days: daysNeeded));
  }

  /// Human-readable projection string.
  String label({
    required GoalEntity goal,
    required List<TransactionEntity> transactions,
  }) {
    if (goal.isCompleted) return '¡Meta alcanzada! 🎉';
    final date = call(goal: goal, transactions: transactions);
    if (date == null) return 'Sin proyección aún';

    final days = date.difference(DateTime.now()).inDays;
    if (days <= 0) return '¡Muy pronto! 🚀';
    if (days == 1) return 'Mañana alcanzas tu meta 🎯';
    if (days < 30) return 'En $days días alcanzas tu meta';
    final months = (days / 30).round();
    return 'En ~$months ${months == 1 ? 'mes' : 'meses'} alcanzas tu meta';
  }
}
