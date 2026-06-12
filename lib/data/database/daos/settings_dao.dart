import 'package:drift/drift.dart';
import '../app_database.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [UserSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  // ── Queries ────────────────────────────────────────────────────

  /// Watch the single settings row.
  Stream<UserSetting?> watchSettings() =>
      (select(userSettings)..limit(1)).watchSingleOrNull();

  Future<UserSetting?> getSettings() =>
      (select(userSettings)..limit(1)).getSingleOrNull();

  // ── Mutations ──────────────────────────────────────────────────

  /// Upsert settings. Creates if not exist, updates if does.
  Future<void> upsertSettings(UserSettingsCompanion entry) async {
    final existing = await getSettings();
    if (existing == null) {
      await into(userSettings).insert(entry);
    } else {
      await (update(userSettings)..where((s) => s.id.equals(existing.id)))
          .write(entry);
    }
  }

  Future<void> setUserName(String name) =>
      upsertSettings(UserSettingsCompanion(userName: Value(name)));

  Future<void> setAvatar(String? path) =>
      upsertSettings(UserSettingsCompanion(avatarPath: Value(path)));

  Future<void> setTheme(String colorHex, int mode) => upsertSettings(
        UserSettingsCompanion(
          themeSeedColor: Value(colorHex),
          themeMode: Value(mode),
        ),
      );

  Future<void> setReminder(bool enabled, String time) => upsertSettings(
        UserSettingsCompanion(
          reminderEnabled: Value(enabled),
          reminderTime: Value(time),
        ),
      );

  Future<void> setOllamaConfig(String url, String model) => upsertSettings(
        UserSettingsCompanion(
          ollamaUrl: Value(url),
          ollamaModel: Value(model),
        ),
      );

  Future<void> setGlobalStreak({
    required int streak,
    required int frozenStreak,
    required String? lastDate,
  }) =>
      upsertSettings(
        UserSettingsCompanion(
          globalStreak: Value(streak),
          globalFrozenStreak: Value(frozenStreak),
          streakLastDate: Value(lastDate),
        ),
      );

  Future<void> completeOnboarding() => upsertSettings(
        UserSettingsCompanion(
          onboardingCompletedAt: Value(DateTime.now().toIso8601String()),
        ),
      );
}
