import '../../data/database/app_database.dart';
import '../../data/models/mappers.dart';
import '../../domain/entities/user_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final AppDatabase _db;

  SettingsRepositoryImpl(this._db);

  @override
  Stream<UserSettingsEntity?> watchSettings() =>
      _db.settingsDao.watchSettings().map((row) => row?.toEntity());

  @override
  Future<UserSettingsEntity?> getSettings() async {
    final row = await _db.settingsDao.getSettings();
    return row?.toEntity();
  }

  @override
  Future<void> saveUserName(String name) =>
      _db.settingsDao.setUserName(name);

  @override
  Future<void> saveAvatar(String? path) => _db.settingsDao.setAvatar(path);

  @override
  Future<void> saveTheme(String colorHex, AppThemeMode mode) =>
      _db.settingsDao.setTheme(colorHex, mode.index);

  @override
  Future<void> saveReminder(bool enabled, String time) =>
      _db.settingsDao.setReminder(enabled, time);

  @override
  Future<void> saveOllamaConfig(String url, String model) =>
      _db.settingsDao.setOllamaConfig(url, model);

  @override
  Future<void> completeOnboarding() => _db.settingsDao.completeOnboarding();

  @override
  Future<void> updateGlobalStreak({
    required int streak,
    required int frozenStreak,
    required String? lastDate,
  }) =>
      _db.settingsDao.setGlobalStreak(
        streak: streak,
        frozenStreak: frozenStreak,
        lastDate: lastDate,
      );
}
