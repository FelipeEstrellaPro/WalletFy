import '../../domain/entities/user_settings_entity.dart';

/// Abstract repository for user settings.
abstract class SettingsRepository {
  Stream<UserSettingsEntity?> watchSettings();
  Future<UserSettingsEntity?> getSettings();
  Future<void> saveUserName(String name);
  Future<void> saveAvatar(String? path);
  Future<void> saveTheme(String colorHex, AppThemeMode mode);
  Future<void> saveReminder(bool enabled, String time);
  Future<void> saveOllamaConfig(String url, String model);
  Future<void> completeOnboarding();
  Future<void> updateGlobalStreak({
    required int streak,
    required int frozenStreak,
    required String? lastDate,
  });
}
