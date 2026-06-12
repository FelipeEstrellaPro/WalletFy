import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/analytics_state.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import 'database_provider.dart';
import 'goals_provider.dart';

part 'analytics_provider.g.dart';

// ── Period notifier ────────────────────────────────────────────
@riverpod
class AnalyticsPeriodNotifier extends _$AnalyticsPeriodNotifier {
  @override
  AnalyticsPeriod build() => AnalyticsPeriod.month;

  void setPeriod(AnalyticsPeriod period) => state = period;
}

// ── Analytics data ─────────────────────────────────────────────
@riverpod
Future<AnalyticsState> analyticsData(AnalyticsDataRef ref) async {
  final period = ref.watch(analyticsPeriodNotifierProvider);
  final repo = ref.watch(goalRepositoryProvider);
  final goalsAsync = ref.watch(activeGoalsProvider);

  final goals = goalsAsync.valueOrNull ?? [];
  final transactions = await repo.getAllTransactionsInRange(
    period.from,
    DateTime.now(),
  );

  return buildAnalyticsState(
    period: period,
    transactions: transactions,
    goals: goals,
  );
}

// ── Export helpers ─────────────────────────────────────────────

/// Get all transactions for CSV/PDF export (all time, all goals).
@riverpod
Future<List<TransactionEntity>> allTransactionsForExport(
    AllTransactionsForExportRef ref) async {
  final repo = ref.watch(goalRepositoryProvider);
  return repo.getAllTransactionsInRange(DateTime(2000), DateTime.now());
}

/// Provider for the GoalRepository (convenience re-export).
GoalRepository goalRepoOf(dynamic ref) => ref.watch(goalRepositoryProvider);
