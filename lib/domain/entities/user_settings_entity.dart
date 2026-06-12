import 'package:equatable/equatable.dart';

/// Theme mode enum mapped to int.
enum AppThemeMode { system, light, dark }

/// User settings domain entity.
class UserSettingsEntity extends Equatable {
  final int id;
  final String userName;
  final String? avatarPath;
  final String themeSeedColor;
  final AppThemeMode themeMode;
  final bool reminderEnabled;
  final String reminderTime; // HH:mm
  final DateTime? streakLastDate;
  final int globalStreak;
  final int globalFrozenStreak;
  final String ollamaUrl;
  final String ollamaModel;
  final DateTime? onboardingCompletedAt;

  const UserSettingsEntity({
    required this.id,
    required this.userName,
    this.avatarPath,
    required this.themeSeedColor,
    required this.themeMode,
    required this.reminderEnabled,
    required this.reminderTime,
    this.streakLastDate,
    required this.globalStreak,
    required this.globalFrozenStreak,
    required this.ollamaUrl,
    required this.ollamaModel,
    this.onboardingCompletedAt,
  });

  bool get isOnboardingDone => onboardingCompletedAt != null;

  bool get hasName => userName.trim().isNotEmpty;

  UserSettingsEntity copyWith({
    int? id,
    String? userName,
    String? avatarPath,
    String? themeSeedColor,
    AppThemeMode? themeMode,
    bool? reminderEnabled,
    String? reminderTime,
    DateTime? streakLastDate,
    int? globalStreak,
    int? globalFrozenStreak,
    String? ollamaUrl,
    String? ollamaModel,
    DateTime? onboardingCompletedAt,
  }) {
    return UserSettingsEntity(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      avatarPath: avatarPath ?? this.avatarPath,
      themeSeedColor: themeSeedColor ?? this.themeSeedColor,
      themeMode: themeMode ?? this.themeMode,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      streakLastDate: streakLastDate ?? this.streakLastDate,
      globalStreak: globalStreak ?? this.globalStreak,
      globalFrozenStreak: globalFrozenStreak ?? this.globalFrozenStreak,
      ollamaUrl: ollamaUrl ?? this.ollamaUrl,
      ollamaModel: ollamaModel ?? this.ollamaModel,
      onboardingCompletedAt: onboardingCompletedAt ?? this.onboardingCompletedAt,
    );
  }

  static UserSettingsEntity get defaults => const UserSettingsEntity(
        id: 0,
        userName: '',
        themeSeedColor: '#6366F1',
        themeMode: AppThemeMode.system,
        reminderEnabled: false,
        reminderTime: '08:00',
        globalStreak: 0,
        globalFrozenStreak: 0,
        ollamaUrl: 'http://localhost:11434',
        ollamaModel: 'qwen2.5-coder:7b',
      );

  @override
  List<Object?> get props => [
        id, userName, avatarPath, themeSeedColor, themeMode,
        reminderEnabled, reminderTime, streakLastDate,
        globalStreak, globalFrozenStreak, ollamaUrl, ollamaModel,
        onboardingCompletedAt,
      ];
}
