import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/goal_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/goal_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/chat_repository.dart';

part 'database_provider.g.dart';

// ── Singleton DB instance ──────────────────────────────────────
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

// ── Repository providers ───────────────────────────────────────
@Riverpod(keepAlive: true)
GoalRepository goalRepository(GoalRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return GoalRepositoryImpl(db);
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return SettingsRepositoryImpl(db);
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return ChatRepositoryImpl(db);
}
