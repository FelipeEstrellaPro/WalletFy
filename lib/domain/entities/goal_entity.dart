import 'package:equatable/equatable.dart';

/// Transaction category enum.
enum TransactionCategory {
  deposit,
  withdrawal,
  scheduled;

  static TransactionCategory fromString(String value) {
    return TransactionCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TransactionCategory.deposit,
    );
  }
}

/// Goal domain entity.
class GoalEntity extends Equatable {
  final int id;
  final String title;
  final String emoji;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
  final String colorHex;
  final String? description;
  final bool isArchived;
  final int streak;
  final int frozenStreak;
  final DateTime? streakLastDate;
  final DateTime createdAt;

  const GoalEntity({
    required this.id,
    required this.title,
    required this.emoji,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    required this.colorHex,
    this.description,
    required this.isArchived,
    required this.streak,
    required this.frozenStreak,
    this.streakLastDate,
    required this.createdAt,
  });

  /// Percentage completed (0.0 to 1.0).
  double get progressRatio =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  double get progressPercent => progressRatio * 100;

  bool get isCompleted => currentAmount >= targetAmount;

  /// Remaining amount.
  double get remaining => (targetAmount - currentAmount).clamp(0.0, double.infinity);

  /// Days remaining until deadline.
  int? get daysRemaining {
    if (deadline == null) return null;
    final now = DateTime.now();
    return deadline!.difference(now).inDays;
  }

  /// Projected completion date based on average daily savings.
  DateTime? get projectedCompletion {
    if (isCompleted) return null;
    final daysSinceCreation =
        DateTime.now().difference(createdAt).inDays.clamp(1, 9999);
    final dailyRate = currentAmount / daysSinceCreation;
    if (dailyRate <= 0) return null;
    final daysNeeded = (remaining / dailyRate).ceil();
    return DateTime.now().add(Duration(days: daysNeeded));
  }

  GoalEntity copyWith({
    int? id,
    String? title,
    String? emoji,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    String? colorHex,
    String? description,
    bool? isArchived,
    int? streak,
    int? frozenStreak,
    DateTime? streakLastDate,
    DateTime? createdAt,
  }) {
    return GoalEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      colorHex: colorHex ?? this.colorHex,
      description: description ?? this.description,
      isArchived: isArchived ?? this.isArchived,
      streak: streak ?? this.streak,
      frozenStreak: frozenStreak ?? this.frozenStreak,
      streakLastDate: streakLastDate ?? this.streakLastDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id, title, emoji, targetAmount, currentAmount,
        deadline, colorHex, description, isArchived,
        streak, frozenStreak, streakLastDate, createdAt,
      ];
}
