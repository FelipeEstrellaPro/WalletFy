import '../../domain/entities/goal_entity.dart';
import '../../domain/entities/transaction_entity.dart';

/// Analytics period selector.
enum AnalyticsPeriod { week, month, year, all }

extension AnalyticsPeriodExtension on AnalyticsPeriod {
  String get label => switch (this) {
        AnalyticsPeriod.week => 'Semana',
        AnalyticsPeriod.month => 'Mes',
        AnalyticsPeriod.year => 'Año',
        AnalyticsPeriod.all => 'Todo',
      };

  DateTime get from {
    final now = DateTime.now();
    return switch (this) {
      AnalyticsPeriod.week =>
        now.subtract(const Duration(days: 7)),
      AnalyticsPeriod.month =>
        DateTime(now.year, now.month - 1, now.day),
      AnalyticsPeriod.year =>
        DateTime(now.year - 1, now.month, now.day),
      AnalyticsPeriod.all => DateTime(2000),
    };
  }
}

/// Bar chart data point (date + amount).
class BarDataPoint {
  final DateTime date;
  final double amount;
  final String label;

  const BarDataPoint({
    required this.date,
    required this.amount,
    required this.label,
  });
}

/// Donut slice (goal + amount).
class DonutSlice {
  final GoalEntity goal;
  final double amount;
  final double percentage;

  const DonutSlice({
    required this.goal,
    required this.amount,
    required this.percentage,
  });
}

/// Full analytics state model.
class AnalyticsState {
  final AnalyticsPeriod period;
  final List<BarDataPoint> barData;
  final List<({DateTime date, double cumulative})> lineData;
  final List<DonutSlice> donutData;
  final double totalDeposited;
  final double averageDeposit;
  final int bestStreak;
  final GoalEntity? nearestGoal;
  final int transactionCount;
  final bool isLoading;
  final String? error;

  const AnalyticsState({
    this.period = AnalyticsPeriod.month,
    this.barData = const [],
    this.lineData = const [],
    this.donutData = const [],
    this.totalDeposited = 0,
    this.averageDeposit = 0,
    this.bestStreak = 0,
    this.nearestGoal,
    this.transactionCount = 0,
    this.isLoading = false,
    this.error,
  });

  AnalyticsState copyWith({
    AnalyticsPeriod? period,
    List<BarDataPoint>? barData,
    List<({DateTime date, double cumulative})>? lineData,
    List<DonutSlice>? donutData,
    double? totalDeposited,
    double? averageDeposit,
    int? bestStreak,
    GoalEntity? nearestGoal,
    int? transactionCount,
    bool? isLoading,
    String? error,
  }) {
    return AnalyticsState(
      period: period ?? this.period,
      barData: barData ?? this.barData,
      lineData: lineData ?? this.lineData,
      donutData: donutData ?? this.donutData,
      totalDeposited: totalDeposited ?? this.totalDeposited,
      averageDeposit: averageDeposit ?? this.averageDeposit,
      bestStreak: bestStreak ?? this.bestStreak,
      nearestGoal: nearestGoal ?? this.nearestGoal,
      transactionCount: transactionCount ?? this.transactionCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Build analytics data from transactions + goals.
AnalyticsState buildAnalyticsState({
  required AnalyticsPeriod period,
  required List<TransactionEntity> transactions,
  required List<GoalEntity> goals,
}) {
  final deposits = transactions
      .where((t) => t.category != TransactionCategory.withdrawal)
      .toList();

  // ── Bar data: group by day/week/month ─────────────────────────
  final Map<String, double> grouped = {};
  for (final t in deposits) {
    final key = switch (period) {
      AnalyticsPeriod.week || AnalyticsPeriod.month =>
        '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}',
      AnalyticsPeriod.year =>
        '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}',
      AnalyticsPeriod.all =>
        '${t.date.year}',
    };
    grouped[key] = (grouped[key] ?? 0) + t.amount;
  }

  final barData = grouped.entries
      .map((e) {
        String parsedKey = e.key;
        if (parsedKey.length == 4) parsedKey += '-01-01';
        else if (parsedKey.length == 7) parsedKey += '-01';
        return BarDataPoint(
          date: DateTime.parse(parsedKey),
          amount: e.value,
          label: e.key,
        );
      })
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  // ── Line data: cumulative ──────────────────────────────────────
  double cumulative = 0;
  final lineData = deposits
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  final linePoints = lineData.map((t) {
    cumulative += t.amount;
    return (date: t.date, cumulative: cumulative);
  }).toList();

  // ── Donut: distribution by goal ───────────────────────────────
  final Map<int, double> byGoal = {};
  for (final t in deposits) {
    byGoal[t.goalId] = (byGoal[t.goalId] ?? 0) + t.amount;
  }
  final totalForDonut =
      byGoal.values.fold(0.0, (sum, v) => sum + v);
  final donutSlices = byGoal.entries
      .map((e) {
        final goal = goals.where((g) => g.id == e.key).firstOrNull;
        if (goal == null) return null;
        return DonutSlice(
          goal: goal,
          amount: e.value,
          percentage: totalForDonut > 0 ? e.value / totalForDonut : 0,
        );
      })
      .whereType<DonutSlice>()
      .toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));

  // ── Stats ──────────────────────────────────────────────────────
  final totalDeposited =
      deposits.fold(0.0, (sum, t) => sum + t.amount);
  final avgDeposit =
      deposits.isEmpty ? 0.0 : totalDeposited / deposits.length;
  final bestStreak =
      goals.isEmpty ? 0 : goals.map((g) => g.streak).reduce((a, b) => a > b ? a : b);

  // Nearest goal = active, not completed, closest to 100%
  final nearestGoal = goals
      .where((g) => !g.isCompleted && !g.isArchived)
      .toList()
    ..sort((a, b) => b.progressRatio.compareTo(a.progressRatio));

  return AnalyticsState(
    period: period,
    barData: barData,
    lineData: linePoints,
    donutData: donutSlices,
    totalDeposited: totalDeposited,
    averageDeposit: avgDeposit,
    bestStreak: bestStreak,
    nearestGoal: nearestGoal.firstOrNull,
    transactionCount: deposits.length,
    isLoading: false,
  );
}
