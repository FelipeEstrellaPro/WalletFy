import 'package:equatable/equatable.dart';

/// Chat message domain entity.
class ChatMessageEntity extends Equatable {
  final int id;
  final String role; // user / assistant / system
  final String content;
  final DateTime timestamp;
  final int sessionId;

  const ChatMessageEntity({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    required this.sessionId,
  });

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
  bool get isSystem => role == 'system';

  @override
  List<Object?> get props => [id, role, content, timestamp, sessionId];
}
