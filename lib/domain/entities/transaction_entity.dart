import 'package:equatable/equatable.dart';
import 'goal_entity.dart';

/// Transaction domain entity.
class TransactionEntity extends Equatable {
  final int id;
  final int goalId;
  final double amount;
  final DateTime date;
  final TransactionCategory category;
  final String? note;

  const TransactionEntity({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.date,
    required this.category,
    this.note,
  });

  bool get isDeposit => category != TransactionCategory.withdrawal;

  TransactionEntity copyWith({
    int? id,
    int? goalId,
    double? amount,
    DateTime? date,
    TransactionCategory? category,
    String? note,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id, goalId, amount, date, category, note];
}
