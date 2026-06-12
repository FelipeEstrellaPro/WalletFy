import 'package:drift/drift.dart';
import '../app_database.dart';

part 'chat_dao.g.dart';

@DriftAccessor(tables: [ChatMessages])
class ChatDao extends DatabaseAccessor<AppDatabase> with _$ChatDaoMixin {
  ChatDao(super.db);

  // ── Queries ────────────────────────────────────────────────────

  /// Watch all messages in a session, chronological order.
  Stream<List<ChatMessage>> watchMessages({int sessionId = 1}) =>
      (select(chatMessages)
            ..where((m) => m.sessionId.equals(sessionId))
            ..orderBy([(m) => OrderingTerm.desc(m.timestamp)]))
          .watch();

  Future<List<ChatMessage>> getMessages({int sessionId = 1}) =>
      (select(chatMessages)
            ..where((m) => m.sessionId.equals(sessionId))
            ..orderBy([(m) => OrderingTerm.desc(m.timestamp)]))
          .get();

  /// Get last N messages for context window.
  Future<List<ChatMessage>> getRecentMessages(
      {int limit = 20, int sessionId = 1}) =>
      (select(chatMessages)
            ..where((m) =>
                m.sessionId.equals(sessionId) &
                m.role.isNotValue('system'))
            ..orderBy([(m) => OrderingTerm.desc(m.timestamp)])
            ..limit(limit))
          .get();

  // ── Mutations ──────────────────────────────────────────────────

  Future<int> addMessage(ChatMessagesCompanion entry) =>
      into(chatMessages).insert(entry);

  Future<void> clearSession({int sessionId = 1}) =>
      (delete(chatMessages)
            ..where((m) =>
                m.sessionId.equals(sessionId) &
                m.role.isNotValue('system')))
          .go();

  Future<void> clearAll() => delete(chatMessages).go();
}
