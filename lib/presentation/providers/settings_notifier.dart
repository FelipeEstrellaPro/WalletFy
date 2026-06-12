import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import 'database_provider.dart';
import 'settings_provider.dart';

part 'settings_notifier.g.dart';

/// Full settings management notifier.
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  AsyncValue<UserSettingsEntity> build() {
    final settingsAsync = ref.watch(settingsStreamProvider);
    return settingsAsync.when(
      data: (s) => AsyncData(s ?? UserSettingsEntity.defaults),
      loading: () => const AsyncLoading(),
      error: (e, st) => AsyncError(e, st),
    );
  }

  SettingsRepository get _repo => ref.read(settingsRepositoryProvider);

  UserSettingsEntity get _current =>
      state.valueOrNull ?? UserSettingsEntity.defaults;

  // ── User Profile ───────────────────────────────────────────────

  Future<void> saveUserName(String name) async {
    await _repo.saveUserName(name.trim());
  }

  Future<void> saveAvatar(String? path) async {
    await _repo.saveAvatar(path);
  }

  // ── Theme ──────────────────────────────────────────────────────

  Future<void> saveTheme(String colorHex, AppThemeMode mode) async {
    await _repo.saveTheme(colorHex, mode);
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _repo.saveTheme(_current.themeSeedColor, mode);
  }

  Future<void> setSeedColor(String colorHex) async {
    await _repo.saveTheme(colorHex, _current.themeMode);
  }

  // ── Reminders ─────────────────────────────────────────────────

  Future<void> setReminderEnabled(bool enabled) async {
    await _repo.saveReminder(enabled, _current.reminderTime);
  }

  Future<void> setReminderTime(String hhmm) async {
    await _repo.saveReminder(_current.reminderEnabled, hhmm);
  }

  // ── Ollama ─────────────────────────────────────────────────────

  Future<void> saveOllamaConfig({
    required String url,
    required String model,
  }) async {
    await _repo.saveOllamaConfig(url, model);
  }

  // ── Onboarding ─────────────────────────────────────────────────

  Future<void> completeOnboarding({required String userName}) async {
    await _repo.saveUserName(userName);
    await _repo.completeOnboarding();
  }
}

// ── Reminder scheduler helper ──────────────────────────────────
// Called from profile page after saving reminder settings.
Future<void> scheduleReminderNotification({
  required bool enabled,
  required String time, // HH:mm
}) async {
  // local_notifier doesn't support scheduled notifications natively.
  // We use a daily check pattern instead — the notification is shown
  // when the app opens and the time matches. Full scheduling via
  // platform-specific APIs is implemented in FASE 6.
}
