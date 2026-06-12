import '../../domain/entities/goal_entity.dart';
import '../../domain/entities/transaction_entity.dart';

/// Abstract repository for goals and transactions.
abstract class GoalRepository {
  // Goals
  Stream<List<GoalEntity>> watchActiveGoals();
  Stream<List<GoalEntity>> watchArchivedGoals();
  Stream<GoalEntity> watchGoalById(int id);
  Future<GoalEntity?> getGoalById(int id);
  Future<List<GoalEntity>> getAllActiveGoals();

  Future<int> createGoal(GoalEntity goal);
  Future<void> updateGoal(GoalEntity goal);
  Future<void> archiveGoal(int id);
  Future<void> deleteGoal(int id);

  Future<double> getTotalSaved();

  // Transactions
  Stream<List<TransactionEntity>> watchTransactionsForGoal(int goalId);
  Future<List<TransactionEntity>> getTransactionsForGoal(int goalId);
  Future<List<TransactionEntity>> getTransactionsInRange(
      DateTime from, DateTime to);
  Future<List<TransactionEntity>> getAllTransactionsInRange(
      DateTime from, DateTime to);

  Future<int> addTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(int id);
  Future<void> deleteAllTransactionsForGoal(int goalId);

  /// Record a deposit and update goal progress + streak logic.
  Future<void> deposit({
    required int goalId,
    required double amount,
    required TransactionCategory category,
    String? note,
  });

  /// Record a withdrawal and update goal balance.
  Future<void> withdraw({
    required int goalId,
    required double amount,
    String? note,
  });
}
