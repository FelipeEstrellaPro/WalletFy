import 'package:drift/drift.dart';
import '../app_database.dart';

part 'goals_dao.g.dart';

@DriftAccessor(tables: [Goals, Transactions])
class GoalsDao extends DatabaseAccessor<AppDatabase> with _$GoalsDaoMixin {
  GoalsDao(super.db);

  // ── Queries ────────────────────────────────────────────────────

  /// All active (non-archived) goals, newest first.
  Stream<List<Goal>> watchActiveGoals() => (select(goals)
        ..where((g) => g.isArchived.equals(false))
        ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]))
      .watch();

  /// All archived goals.
  Stream<List<Goal>> watchArchivedGoals() => (select(goals)
        ..where((g) => g.isArchived.equals(true))
        ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]))
      .watch();

  /// Single goal by id.
  Stream<Goal> watchGoalById(int id) =>
      (select(goals)..where((g) => g.id.equals(id))).watchSingle();

  Future<Goal?> getGoalById(int id) =>
      (select(goals)..where((g) => g.id.equals(id))).getSingleOrNull();

  Future<List<Goal>> getAllActiveGoals() =>
      (select(goals)..where((g) => g.isArchived.equals(false))).get();

  // ── Mutations ──────────────────────────────────────────────────

  Future<int> createGoal(GoalsCompanion entry) =>
      into(goals).insert(entry);

  Future<bool> updateGoal(GoalsCompanion entry) =>
      update(goals).replace(entry);

  Future<void> archiveGoal(int id) =>
      (update(goals)..where((g) => g.id.equals(id)))
          .write(const GoalsCompanion(isArchived: Value(true)));

  Future<void> deleteGoal(int id) =>
      (delete(goals)..where((g) => g.id.equals(id))).go();

  /// Update current amount and streak info.
  Future<void> updateGoalProgress({
    required int id,
    required double newAmount,
    required int streak,
    required int frozenStreak,
    required String? streakLastDate,
  }) async {
    await (update(goals)..where((g) => g.id.equals(id))).write(
      GoalsCompanion(
        currentAmount: Value(newAmount),
        streak: Value(streak),
        frozenStreak: Value(frozenStreak),
        streakLastDate: Value(streakLastDate),
      ),
    );
  }

  /// Total amount saved across all active goals.
  Future<double> getTotalSaved() async {
    final query = selectOnly(goals)
      ..addColumns([goals.currentAmount])
      ..where(goals.isArchived.equals(false));
    final rows = await query.get();
    double sum = 0.0;
    for (final row in rows) {
      sum += row.read(goals.currentAmount) ?? 0.0;
    }
    return sum;
  }
}
