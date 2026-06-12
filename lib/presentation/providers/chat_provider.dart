import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/errors/failures.dart';
import '../../data/repositories/ollama_service.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import 'database_provider.dart';
import 'settings_provider.dart';

part 'chat_provider.g.dart';

// ── OllamaService singleton ────────────────────────────────────
@Riverpod(keepAlive: true)
OllamaService ollamaService(OllamaServiceRef ref) {
  final settings = ref.watch(settingsStreamProvider).valueOrNull;
  return OllamaService(
    baseUrl: settings?.ollamaUrl ?? 'http://localhost:11434',
    model: settings?.ollamaModel ?? 'llama3',
  );
}

// ── Chat messages stream ───────────────────────────────────────
@riverpod
Stream<List<ChatMessageEntity>> chatMessages(ChatMessagesRef ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchMessages();
}

// ── Chat state ─────────────────────────────────────────────────
class ChatState {
  final bool isLoading;
  final bool isTyping; // AI writing indicator
  final String? error;
  final bool ollamaAvailable;

  const ChatState({
    this.isLoading = false,
    this.isTyping = false,
    this.error,
    this.ollamaAvailable = true,
  });

  ChatState copyWith({
    bool? isLoading,
    bool? isTyping,
    String? error,
    bool? ollamaAvailable,
  }) =>
      ChatState(
        isLoading: isLoading ?? this.isLoading,
        isTyping: isTyping ?? this.isTyping,
        error: error,
        ollamaAvailable: ollamaAvailable ?? this.ollamaAvailable,
      );
}

// ── Chat notifier ──────────────────────────────────────────────
@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  ChatState build() => const ChatState();

  ChatRepository get _chatRepo => ref.read(chatRepositoryProvider);
  OllamaService get _ollama => ref.read(ollamaServiceProvider);
  SettingsRepository get _settingsRepo =>
      ref.read(settingsRepositoryProvider);

  /// Build the system prompt with user context.
  Future<String> _buildSystemPrompt() async {
    final settings = await _settingsRepo.getSettings();
    final goals = await ref.read(goalRepositoryProvider).getAllActiveGoals();

    final userName = settings?.userName.isNotEmpty == true
        ? settings!.userName
        : 'usuario';

    final goalsSummary = goals.map((g) {
      final pct = (g.progressPercent).toStringAsFixed(1);
      final days = g.daysRemaining != null ? '${g.daysRemaining} días restantes' : 'sin fecha límite';
      return '- ${g.emoji} ${g.title}: $pct% completada, racha: ${g.streak} días, $days';
    }).join('\n');

    final totalSaved = goals.fold(0.0, (s, g) => s + g.currentAmount);

    return '''Eres WalletFY AI, un asesor financiero personal amigable y motivador que habla en español.
El usuario se llama $userName.

DATOS ACTUALES DEL USUARIO:
- Total ahorrado: \$${totalSaved.toStringAsFixed(2)}
- Metas activas: ${goals.length}
${goalsSummary.isNotEmpty ? '\nMETAS:\n$goalsSummary' : ''}

INSTRUCCIONES:
1. Usa los datos del usuario para dar recomendaciones ESPECÍFICAS y alcanzables
2. Sé motivador, empático y usa emojis ocasionalmente
3. Si te preguntan sobre metas específicas, usa los datos reales
4. Da consejos prácticos de ahorro adaptados a su situación
5. Mantén respuestas concisas (máximo 3 párrafos) a menos que se pida más detalle
6. NUNCA inventes datos que no tienes sobre el usuario''';
  }

  /// Send a user message and get AI response.
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 1. Save user message
      final userMsg = ChatMessageEntity(
        id: 0,
        role: 'user',
        content: content.trim(),
        timestamp: DateTime.now(),
        sessionId: 1,
      );
      await _chatRepo.addMessage(userMsg);

      // 2. Show typing indicator
      state = state.copyWith(isLoading: false, isTyping: true);

      // 3. Build context from recent messages
      final recentMsgs = await _chatRepo.getRecentMessages(limit: 10);
      final systemPrompt = await _buildSystemPrompt();

      final ollamaMessages = [
        OllamaMessage(role: OllamaRole.system, content: systemPrompt),
        ...recentMsgs.map((m) => OllamaMessage(
              role: m.isUser ? OllamaRole.user : OllamaRole.assistant,
              content: m.content,
            )),
      ];

      // 4. Get AI response
      final response = await _ollama.chat(messages: ollamaMessages);

      // 5. Save assistant message
      final assistantMsg = ChatMessageEntity(
        id: 0,
        role: 'assistant',
        content: response,
        timestamp: DateTime.now(),
        sessionId: 1,
      );
      await _chatRepo.addMessage(assistantMsg);

      state = state.copyWith(
        isTyping: false,
        ollamaAvailable: true,
      );
    } on OllamaFailure catch (e) {
      state = state.copyWith(
        isTyping: false,
        isLoading: false,
        error: e.message,
        ollamaAvailable: false,
      );
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        isLoading: false,
        error: 'Error inesperado: $e',
      );
    }
  }

  /// Check if Ollama is available.
  Future<void> checkAvailability() async {
    final available = await _ollama.isAvailable();
    state = state.copyWith(ollamaAvailable: available);
  }

  /// Clear conversation (keep system messages).
  Future<void> clearHistory() async {
    await _chatRepo.clearSession();
    state = state.copyWith(error: null);
  }

  /// Send a quick suggestion chip.
  Future<void> sendSuggestion(String suggestion) => sendMessage(suggestion);

  void clearError() => state = state.copyWith(error: null);
}
