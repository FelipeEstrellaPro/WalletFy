import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import '../../data/models/mappers.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final AppDatabase _db;

  ChatRepositoryImpl(this._db);

  @override
  Stream<List<ChatMessageEntity>> watchMessages({int sessionId = 1}) =>
      _db.chatDao.watchMessages(sessionId: sessionId).map(
            (rows) => rows.map((r) => r.toEntity()).toList(),
          );

  @override
  Future<List<ChatMessageEntity>> getMessages({int sessionId = 1}) async {
    final rows = await _db.chatDao.getMessages(sessionId: sessionId);
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<List<ChatMessageEntity>> getRecentMessages(
      {int limit = 20, int sessionId = 1}) async {
    final rows = await _db.chatDao
        .getRecentMessages(limit: limit, sessionId: sessionId);
    return rows.reversed.map((r) => r.toEntity()).toList();
  }

  @override
  Future<int> addMessage(ChatMessageEntity message) =>
      _db.chatDao.addMessage(
        ChatMessagesCompanion.insert(
          role: message.role,
          content: message.content,
          timestamp: message.timestamp.toIso8601String(),
          sessionId: Value(message.sessionId),
        ),
      );

  @override
  Future<void> clearSession({int sessionId = 1}) =>
      _db.chatDao.clearSession(sessionId: sessionId);

  @override
  Future<void> clearAll() => _db.chatDao.clearAll();
}
