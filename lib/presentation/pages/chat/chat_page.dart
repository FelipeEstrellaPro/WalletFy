import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/chat_message_entity.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/common/premium_glass_widgets.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatNotifierProvider.notifier).checkAvailability();
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgCtrl.text;
    if (text.trim().isEmpty) return;

    _msgCtrl.clear();
    ref.read(chatNotifierProvider.notifier).sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);
    final messagesAsync = ref.watch(chatMessagesProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'WalletFY AI',
          style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        backgroundColor: cs.surface.withValues(alpha: 0.7),
        surfaceTintColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.transparent),
          ),
        ),
        elevation: 0,
        actions: [
          // Availability Indicator
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: chatState.ollamaAvailable
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: chatState.ollamaAvailable
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: chatState.ollamaAvailable ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: chatState.ollamaAvailable ? Colors.green : Colors.red,
                          blurRadius: 6,
                        )
                      ],
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(begin: 0.5, end: 1.0, duration: 1.seconds),
                  const SizedBox(width: 8),
                  Text(
                    chatState.ollamaAvailable ? 'Conectado' : 'Sin conexión',
                    style: tt.labelSmall?.copyWith(
                      color: chatState.ollamaAvailable ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (value) {
              if (value == 'clear') {
                ref.read(chatNotifierProvider.notifier).clearHistory();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.cleaning_services_rounded, size: 20),
                    SizedBox(width: 12),
                    Text('Limpiar conversación'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Premium Soft Background ──
          const SoftAnimatedBackground(),

          // ── Main Content ──
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Error Banner
                if (chatState.error != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded, color: Colors.red.shade400),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            chatState.error!,
                            style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.red.shade400,
                          onPressed: () => ref.read(chatNotifierProvider.notifier).clearError(),
                        )
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: -0.1),

                // Messages List
                Expanded(
                  child: messagesAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                    data: (messages) {
                      if (messages.isEmpty) {
                        return _buildEmptyState(context);
                      }

                      return ListView.builder(
                        controller: _scrollCtrl,
                        reverse: true, // Scroll from bottom
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          return _ChatBubble(message: msg);
                        },
                      );
                    },
                  ),
                ),

                // Typing Indicator
                if (chatState.isTyping)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GlassWrapper(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 12),
                            Text('WalletFY AI está escribiendo...',
                                style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ).animate().fadeIn().slideX(begin: -0.05),
                    ),
                  ),

                // Quick Suggestions
                messagesAsync.maybeWhen(
                  data: (messages) {
                    if (messages.isNotEmpty) return const SizedBox.shrink();
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Row(
                        children: [
                          '¿Cómo voy con mi meta principal?',
                          'Dame un consejo para ahorrar más.',
                          '¿Qué meta debería priorizar?',
                        ].map((s) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ActionChip(
                                label: Text(s, style: const TextStyle(fontWeight: FontWeight.w600)),
                                backgroundColor: cs.primaryContainer.withValues(alpha: 0.5),
                                side: BorderSide(color: cs.primary.withValues(alpha: 0.2)),
                                onPressed: () => ref.read(chatNotifierProvider.notifier).sendSuggestion(s),
                              ),
                            )).toList(),
                      ),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),

                // Input Bar
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: cs.surface.withValues(alpha: 0.7),
                        border: Border(top: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.2))),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _msgCtrl,
                                decoration: InputDecoration(
                                  hintText: 'Escribe un mensaje...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.2)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.2)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide(color: cs.primary, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                ),
                                textCapitalization: TextCapitalization.sentences,
                                onSubmitted: (_) => _sendMessage(),
                                enabled: !chatState.isLoading,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: cs.primary.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: FloatingActionButton(
                                onPressed: chatState.isLoading || chatState.isTyping ? null : _sendMessage,
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                                elevation: 0,
                                shape: const CircleBorder(),
                                child: const Icon(Icons.send_rounded),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: GlassWrapper(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.auto_awesome_rounded, size: 64, color: cs.primary),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: -5, end: 5, duration: 3.seconds),
            const SizedBox(height: 32),
            Text('¡Hola! Soy WalletFY AI',
                style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Text(
              'Tu asesor financiero personal.\nPregúntame sobre tus metas, ahorros\no pide consejos personalizados.',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant, height: 1.5),
            ),
          ],
        ),
      ).animate().fadeIn().scaleXY(begin: 0.9),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.secondaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(color: cs.secondary.withValues(alpha: 0.2)),
              ),
              child: Icon(Icons.smart_toy_rounded, size: 20, color: cs.secondary),
            ),
            const SizedBox(width: 16),
          ],
          Flexible(
            child: isUser
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [cs.primary, cs.tertiary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message.content, style: TextStyle(color: cs.onPrimary, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text(
                          DateFormatter.formatTime(message.timestamp),
                          style: tt.labelSmall?.copyWith(fontSize: 10, color: cs.onPrimary.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: 0.1)
                : GlassWrapper(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MarkdownBody(
                          data: message.content,
                          styleSheet: MarkdownStyleSheet(
                            p: tt.bodyLarge?.copyWith(height: 1.5),
                            listBullet: tt.bodyLarge,
                            code: TextStyle(backgroundColor: cs.surfaceContainerHighest),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          DateFormatter.formatTime(message.timestamp),
                          style: tt.labelSmall?.copyWith(fontSize: 10, color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: 0.1),
          ),
          if (isUser) const SizedBox(width: 24),
          if (!isUser) const SizedBox(width: 64),
        ],
      ),
    );
  }
}
