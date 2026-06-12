import '../../domain/entities/chat_message_entity.dart';

/// Abstract repository for chat messages.
abstract class ChatRepository {
  Stream<List<ChatMessageEntity>> watchMessages({int sessionId = 1});
  Future<List<ChatMessageEntity>> getMessages({int sessionId = 1});
  Future<List<ChatMessageEntity>> getRecentMessages(
      {int limit = 20, int sessionId = 1});
  Future<int> addMessage(ChatMessageEntity message);
  Future<void> clearSession({int sessionId = 1});
  Future<void> clearAll();
}
