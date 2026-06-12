import 'package:drift/drift.dart';
import '../app_database.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  // ── Queries ────────────────────────────────────────────────────

  /// All transactions for a goal, newest first.
  Stream<List<Transaction>> watchTransactionsForGoal(int goalId) =>
      (select(transactions)
            ..where((t) => t.goalId.equals(goalId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  Future<List<Transaction>> getTransactionsForGoal(int goalId) =>
      (select(transactions)
            ..where((t) => t.goalId.equals(goalId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Transactions in a date range (all goals).
  Future<List<Transaction>> getTransactionsInRange(
      DateTime from, DateTime to) async {
    final fromStr = from.toIso8601String().substring(0, 10);
    final toStr = to.toIso8601String().substring(0, 10);
    return (select(transactions)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(fromStr) &
              t.date.isSmallerOrEqualValue(toStr))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  /// Sum of deposits for a goal.
  Future<double> getTotalDepositedForGoal(int goalId) async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.amount])
      ..where(transactions.goalId.equals(goalId) &
          transactions.category.equals('deposit'));
    final rows = await query.get();
    double sum = 0.0;
    for (final row in rows) {
      sum += row.read(transactions.amount) ?? 0.0;
    }
    return sum;
  }

  /// All transactions across all goals in date range for analytics.
  Future<List<Transaction>> getAllTransactionsInRange(
      DateTime from, DateTime to) {
    final fromStr = from.toIso8601String().substring(0, 10);
    final toStr = to.toIso8601String().substring(0, 10);
    return (select(transactions)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(fromStr) &
              t.date.isSmallerOrEqualValue(toStr))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  /// Last transaction date for a goal (for streak calculation).
  Future<Transaction?> getLastTransactionForGoal(int goalId) =>
      (select(transactions)
            ..where((t) =>
                t.goalId.equals(goalId) & t.category.isNotValue('withdrawal'))
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(1))
          .getSingleOrNull();

  // ── Mutations ──────────────────────────────────────────────────

  Future<int> addTransaction(TransactionsCompanion entry) =>
      into(transactions).insert(entry);

  Future<void> deleteTransaction(int id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  Future<void> deleteAllForGoal(int goalId) =>
      (delete(transactions)..where((t) => t.goalId.equals(goalId))).go();
}
