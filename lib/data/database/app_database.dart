import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/goals_dao.dart';
import 'daos/transactions_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/chat_dao.dart';

part 'app_database.g.dart';

// ─────────────────────────────────────────────
// TABLE: Goals
// ─────────────────────────────────────────────
class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get emoji => text().withDefault(const Constant('🎯'))();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real().withDefault(const Constant(0.0))();
  TextColumn get deadline => text().nullable()(); // ISO-8601
  TextColumn get colorHex =>
      text().withDefault(const Constant('#6366F1'))();
  TextColumn get description => text().nullable()();
  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  IntColumn get frozenStreak => integer().withDefault(const Constant(0))();
  TextColumn get streakLastDate => text().nullable()(); // ISO-8601 date
  TextColumn get createdAt => text()();
}

// ─────────────────────────────────────────────
// TABLE: Transactions
// ─────────────────────────────────────────────
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer().references(Goals, #id)();
  RealColumn get amount => real()();
  TextColumn get date => text()(); // ISO-8601
  TextColumn get category => text()(); // deposit / withdrawal / scheduled
  TextColumn get note => text().nullable()();
}

// ─────────────────────────────────────────────
// TABLE: UserSettings (single-row config)
// ─────────────────────────────────────────────
class UserSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userName => text().withDefault(const Constant(''))();
  TextColumn get avatarPath => text().nullable()();
  TextColumn get themeSeedColor =>
      text().withDefault(const Constant('#6366F1'))(); // Indigo
  IntColumn get themeMode =>
      integer().withDefault(const Constant(0))(); // 0=system,1=light,2=dark
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get reminderTime =>
      text().withDefault(const Constant('08:00'))(); // HH:mm
  TextColumn get streakLastDate => text().nullable()();
  IntColumn get globalStreak => integer().withDefault(const Constant(0))();
  IntColumn get globalFrozenStreak =>
      integer().withDefault(const Constant(0))();
  TextColumn get ollamaUrl =>
      text().withDefault(const Constant('http://localhost:11434'))();
  TextColumn get ollamaModel =>
      text().withDefault(const Constant('llama3'))();
  TextColumn get onboardingCompletedAt => text().nullable()();
}

// ─────────────────────────────────────────────
// TABLE: ChatMessages
// ─────────────────────────────────────────────
class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get role => text()(); // user / assistant / system
  TextColumn get content => text()();
  TextColumn get timestamp => text()(); // ISO-8601 datetime
  IntColumn get sessionId => integer().withDefault(const Constant(1))();
}

// ─────────────────────────────────────────────
// APP DATABASE
// ─────────────────────────────────────────────
@DriftDatabase(
  tables: [Goals, Transactions, UserSettings, ChatMessages],
  daos: [GoalsDao, TransactionsDao, SettingsDao, ChatDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // Seed default settings row
          await into(userSettings).insert(
            UserSettingsCompanion.insert(
              userName: const Value(''),
              themeSeedColor: const Value('#6366F1'),
              themeMode: const Value(0),
              reminderEnabled: const Value(false),
              reminderTime: const Value('08:00'),
              ollamaUrl: const Value('http://localhost:11434'),
              ollamaModel: const Value('llama3'),
            ),
          );
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations go here
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement('PRAGMA journal_mode = WAL');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    return driftDatabase(name: 'walletfy');
  });
}
