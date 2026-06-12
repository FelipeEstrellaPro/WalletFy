import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import 'database_provider.dart';

part 'goals_provider.g.dart';

// ── Goals streams ──────────────────────────────────────────────

@riverpod
Stream<List<GoalEntity>> activeGoals(ActiveGoalsRef ref) {
  final repo = ref.watch(goalRepositoryProvider);
  return repo.watchActiveGoals();
}

@riverpod
Stream<List<GoalEntity>> archivedGoals(ArchivedGoalsRef ref) {
  final repo = ref.watch(goalRepositoryProvider);
  return repo.watchArchivedGoals();
}

@riverpod
Stream<GoalEntity> goalDetail(GoalDetailRef ref, int goalId) {
  final repo = ref.watch(goalRepositoryProvider);
  return repo.watchGoalById(goalId);
}

@riverpod
Stream<List<TransactionEntity>> goalTransactions(
    GoalTransactionsRef ref, int goalId) {
  final repo = ref.watch(goalRepositoryProvider);
  return repo.watchTransactionsForGoal(goalId);
}

// ── Total saved (future) ───────────────────────────────────────
@riverpod
Future<double> totalSaved(TotalSavedRef ref) {
  final repo = ref.watch(goalRepositoryProvider);
  return repo.getTotalSaved();
}

// ── Goals CRUD notifier ────────────────────────────────────────
@riverpod
class GoalsNotifier extends _$GoalsNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  GoalRepository get _repo => ref.read(goalRepositoryProvider);

  Future<int> createGoal(GoalEntity goal) async {
    state = const AsyncLoading();
    try {
      final id = await _repo.createGoal(goal);
      state = const AsyncData(null);
      return id;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateGoal(GoalEntity goal) async {
    state = const AsyncLoading();
    try {
      await _repo.updateGoal(goal);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> archiveGoal(int id) async {
    state = const AsyncLoading();
    try {
      await _repo.archiveGoal(id);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> deleteGoal(int id) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteGoal(id);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> deposit({
    required int goalId,
    required double amount,
    required TransactionCategory category,
    String? note,
  }) async {
    state = const AsyncLoading();
    try {
      await _repo.deposit(
          goalId: goalId, amount: amount, category: category, note: note);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> withdraw({
    required int goalId,
    required double amount,
    String? note,
  }) async {
    state = const AsyncLoading();
    try {
      await _repo.withdraw(goalId: goalId, amount: amount, note: note);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> deleteTransaction(int transactionId) async {
    try {
      await _repo.deleteTransaction(transactionId);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
