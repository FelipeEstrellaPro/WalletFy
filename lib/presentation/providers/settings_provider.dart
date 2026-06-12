import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import 'database_provider.dart';

part 'settings_provider.g.dart';

// ── Stream provider — watches DB settings row ──────────────────
@Riverpod(keepAlive: true)
Stream<UserSettingsEntity?> settingsStream(SettingsStreamRef ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchSettings();
}

// ── Theme notifier ─────────────────────────────────────────────
@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ({String seedColor, ThemeMode mode}) build() {
    // Listen to settings changes and update theme accordingly
    final settings = ref.watch(settingsStreamProvider).valueOrNull;
    return (
      seedColor: settings?.themeSeedColor ?? '#6366F1',
      mode: _mapThemeMode(settings?.themeMode ?? AppThemeMode.system),
    );
  }

  ThemeMode _mapThemeMode(AppThemeMode mode) => switch (mode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      };

  Future<void> changeTheme(String colorHex, AppThemeMode mode) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.saveTheme(colorHex, mode);
  }
}

// ── Onboarding check provider ──────────────────────────────────
@Riverpod(keepAlive: true)
bool isOnboardingDone(IsOnboardingDoneRef ref) {
  final settings = ref.watch(settingsStreamProvider).valueOrNull;
  return settings?.isOnboardingDone ?? false;
}
