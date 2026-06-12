import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import '../../data/models/mappers.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  final AppDatabase _db;

  GoalRepositoryImpl(this._db);

  // ── Goals ──────────────────────────────────────────────────────

  @override
  Stream<List<GoalEntity>> watchActiveGoals() =>
      _db.goalsDao.watchActiveGoals().map(
            (rows) => rows.map((r) => r.toEntity()).toList(),
          );

  @override
  Stream<List<GoalEntity>> watchArchivedGoals() =>
      _db.goalsDao.watchArchivedGoals().map(
            (rows) => rows.map((r) => r.toEntity()).toList(),
          );

  @override
  Stream<GoalEntity> watchGoalById(int id) =>
      _db.goalsDao.watchGoalById(id).map((r) => r.toEntity());

  @override
  Future<GoalEntity?> getGoalById(int id) async {
    final row = await _db.goalsDao.getGoalById(id);
    return row?.toEntity();
  }

  @override
  Future<List<GoalEntity>> getAllActiveGoals() async {
    final rows = await _db.goalsDao.getAllActiveGoals();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<int> createGoal(GoalEntity goal) =>
      _db.goalsDao.createGoal(goal.toCompanion());

  @override
  Future<void> updateGoal(GoalEntity goal) async {
    await _db.goalsDao.updateGoal(goal.toCompanion());
  }

  @override
  Future<void> archiveGoal(int id) => _db.goalsDao.archiveGoal(id);

  @override
  Future<void> deleteGoal(int id) async {
    await _db.transactionsDao.deleteAllForGoal(id);
    await _db.goalsDao.deleteGoal(id);
  }

  @override
  Future<double> getTotalSaved() => _db.goalsDao.getTotalSaved();

  // ── Transactions ───────────────────────────────────────────────

  @override
  Stream<List<TransactionEntity>> watchTransactionsForGoal(int goalId) =>
      _db.transactionsDao.watchTransactionsForGoal(goalId).map(
            (rows) => rows.map((r) => r.toEntity()).toList(),
          );

  @override
  Future<List<TransactionEntity>> getTransactionsForGoal(int goalId) async {
    final rows = await _db.transactionsDao.getTransactionsForGoal(goalId);
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<List<TransactionEntity>> getTransactionsInRange(
      DateTime from, DateTime to) async {
    final rows = await _db.transactionsDao.getTransactionsInRange(from, to);
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<List<TransactionEntity>> getAllTransactionsInRange(
      DateTime from, DateTime to) async {
    final rows =
        await _db.transactionsDao.getAllTransactionsInRange(from, to);
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<int> addTransaction(TransactionEntity transaction) =>
      _db.transactionsDao.addTransaction(transaction.toCompanion());

  @override
  Future<void> deleteTransaction(int id) =>
      _db.transactionsDao.deleteTransaction(id);

  @override
  Future<void> deleteAllTransactionsForGoal(int goalId) =>
      _db.transactionsDao.deleteAllForGoal(goalId);

  // ── Deposit with streak logic ──────────────────────────────────

  @override
  Future<void> deposit({
    required int goalId,
    required double amount,
    required TransactionCategory category,
    String? note,
  }) async {
    final now = DateTime.now();
    final today = now.toIso8601String().substring(0, 10);

    // Insert transaction
    await _db.transactionsDao.addTransaction(
      TransactionsCompanion.insert(
        goalId: goalId,
        amount: amount,
        date: today,
        category: category.name,
        note: Value(note),
      ),
    );

    // Load current goal for streak update
    final goal = await _db.goalsDao.getGoalById(goalId);
    if (goal == null) return;

    int newStreak = goal.streak;
    int newFrozen = goal.frozenStreak;
    String? lastDate = goal.streakLastDate;

    if (lastDate == null) {
      // First deposit ever
      newStreak = 1;
      newFrozen = 0;
    } else {
      final last = DateTime.parse(lastDate);
      final diff = now.difference(last).inDays;

      if (diff == 0) {
        // Same day — no change
      } else if (diff == 1) {
        // Consecutive day
        newStreak = newFrozen > 0 ? newFrozen + 1 : newStreak + 1;
        newFrozen = 0;
      } else if (diff == 2 && newFrozen == 0) {
        // Missed 1 day — freeze (grace period)
        newFrozen = newStreak;
        newStreak = newFrozen + 1;
      } else {
        // Missed 2+ days — reset
        newStreak = 1;
        newFrozen = 0;
      }
    }

    // Update goal progress and streak
    final newAmount = (goal.currentAmount + amount)
        .clamp(0.0, goal.targetAmount * 10);

    await _db.goalsDao.updateGoalProgress(
      id: goalId,
      newAmount: newAmount,
      streak: newStreak,
      frozenStreak: newFrozen,
      streakLastDate: today,
    );
  }

  // ── Withdrawal ─────────────────────────────────────────────────

  @override
  Future<void> withdraw({
    required int goalId,
    required double amount,
    String? note,
  }) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);

    await _db.transactionsDao.addTransaction(
      TransactionsCompanion.insert(
        goalId: goalId,
        amount: amount,
        date: today,
        category: TransactionCategory.withdrawal.name,
        note: Value(note),
      ),
    );

    final goal = await _db.goalsDao.getGoalById(goalId);
    if (goal == null) return;

    final newAmount = (goal.currentAmount - amount).clamp(0.0, double.infinity);
    await _db.goalsDao.updateGoalProgress(
      id: goalId,
      newAmount: newAmount,
      streak: goal.streak,
      frozenStreak: goal.frozenStreak,
      streakLastDate: goal.streakLastDate,
    );
  }
}
