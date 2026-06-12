import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/user_settings_entity.dart';
import '../../domain/entities/chat_message_entity.dart';

// ── Goal Mapper ─────────────────────────────────────────────────

extension GoalMapper on Goal {
  GoalEntity toEntity() => GoalEntity(
        id: id,
        title: title,
        emoji: emoji,
        targetAmount: targetAmount,
        currentAmount: currentAmount,
        deadline: deadline != null ? DateTime.tryParse(deadline!) : null,
        colorHex: colorHex,
        description: description,
        isArchived: isArchived,
        streak: streak,
        frozenStreak: frozenStreak,
        streakLastDate: streakLastDate != null
            ? DateTime.tryParse(streakLastDate!)
            : null,
        createdAt: DateTime.parse(createdAt),
      );
}

extension GoalEntityMapper on GoalEntity {
  GoalsCompanion toCompanion() => GoalsCompanion(
        id: id == 0 ? const Value.absent() : Value(id),
        title: Value(title),
        emoji: Value(emoji),
        targetAmount: Value(targetAmount),
        currentAmount: Value(currentAmount),
        deadline: Value(deadline?.toIso8601String().substring(0, 10)),
        colorHex: Value(colorHex),
        description: Value(description),
        isArchived: Value(isArchived),
        streak: Value(streak),
        frozenStreak: Value(frozenStreak),
        streakLastDate:
            Value(streakLastDate?.toIso8601String().substring(0, 10)),
        createdAt: Value(createdAt.toIso8601String()),
      );
}

// ── Transaction Mapper ──────────────────────────────────────────

extension TransactionMapper on Transaction {
  TransactionEntity toEntity() => TransactionEntity(
        id: id,
        goalId: goalId,
        amount: amount,
        date: DateTime.parse(date),
        category: TransactionCategory.fromString(category),
        note: note,
      );
}

extension TransactionEntityMapper on TransactionEntity {
  TransactionsCompanion toCompanion() => TransactionsCompanion(
        id: id == 0 ? const Value.absent() : Value(id),
        goalId: Value(goalId),
        amount: Value(amount),
        date: Value(date.toIso8601String().substring(0, 10)),
        category: Value(category.name),
        note: Value(note),
      );
}

// ── UserSettings Mapper ─────────────────────────────────────────

extension UserSettingsMapper on UserSetting {
  UserSettingsEntity toEntity() => UserSettingsEntity(
        id: id,
        userName: userName,
        avatarPath: avatarPath,
        themeSeedColor: themeSeedColor,
        themeMode: AppThemeMode.values[themeMode.clamp(0, 2)],
        reminderEnabled: reminderEnabled,
        reminderTime: reminderTime,
        streakLastDate:
            streakLastDate != null ? DateTime.tryParse(streakLastDate!) : null,
        globalStreak: globalStreak,
        globalFrozenStreak: globalFrozenStreak,
        ollamaUrl: ollamaUrl,
        ollamaModel: ollamaModel,
        onboardingCompletedAt: onboardingCompletedAt != null
            ? DateTime.tryParse(onboardingCompletedAt!)
            : null,
      );
}

// ── ChatMessage Mapper ──────────────────────────────────────────

extension ChatMessageMapper on ChatMessage {
  ChatMessageEntity toEntity() => ChatMessageEntity(
        id: id,
        role: role,
        content: content,
        timestamp: DateTime.parse(timestamp),
        sessionId: sessionId,
      );
}
