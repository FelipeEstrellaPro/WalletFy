import 'package:csv/csv.dart';
import '../entities/goal_entity.dart';
import '../entities/transaction_entity.dart';

/// Builds CSV export content from goals and transactions.
class ExportCsvUseCase {
  const ExportCsvUseCase();

  /// Returns CSV string with all transactions.
  String call({
    required List<GoalEntity> goals,
    required List<TransactionEntity> transactions,
  }) {
    final goalMap = {for (final g in goals) g.id: g};

    final rows = <List<dynamic>>[
      // Header
      ['Fecha', 'Meta', 'Emoji', 'Tipo', 'Monto', 'Nota'],
    ];

    final sorted = List<TransactionEntity>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    for (final t in sorted) {
      final goal = goalMap[t.goalId];
      rows.add([
        '${t.date.day.toString().padLeft(2, '0')}/${t.date.month.toString().padLeft(2, '0')}/${t.date.year}',
        goal?.title ?? 'Meta eliminada',
        goal?.emoji ?? '❓',
        _categoryLabel(t.category),
        t.amount.toStringAsFixed(2),
        t.note ?? '',
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  String _categoryLabel(TransactionCategory cat) => switch (cat) {
        TransactionCategory.deposit => 'Depósito',
        TransactionCategory.withdrawal => 'Retiro',
        TransactionCategory.scheduled => 'Programado',
      };

  /// Returns summary CSV for all goals.
  String goalsSummary({required List<GoalEntity> goals}) {
    final rows = <List<dynamic>>[
      ['Meta', 'Emoji', 'Meta (\$)', 'Ahorrado (\$)', 'Progreso (%)', 'Racha', 'Fecha Límite'],
    ];
    for (final g in goals) {
      rows.add([
        g.title,
        g.emoji,
        g.targetAmount.toStringAsFixed(2),
        g.currentAmount.toStringAsFixed(2),
        g.progressPercent.toStringAsFixed(1),
        g.streak,
        g.deadline != null
            ? '${g.deadline!.day}/${g.deadline!.month}/${g.deadline!.year}'
            : 'Sin fecha',
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }
}
