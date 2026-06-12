import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/settings_notifier.dart';
import '../../providers/goals_provider.dart';
import '../../../domain/entities/goal_entity.dart';
import '../dashboard/main_shell.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Step 1 — Name
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();

  // Step 2 — First Goal
  final _goalTitleController = TextEditingController();
  final _goalAmountController = TextEditingController();
  String _selectedEmoji = '🎯';
  String _selectedColor = '#6366F1';
  bool _isCreating = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _nameFocus.dispose();
    _goalTitleController.dispose();
    _goalAmountController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
    setState(() => _currentPage++);
  }

  Future<void> _finish() async {
    setState(() => _isCreating = true);
    final name = _nameController.text.trim();
    final goalTitle = _goalTitleController.text.trim();
    final goalAmount = double.tryParse(
          _goalAmountController.text.replaceAll(',', ''),
        ) ??
        0;

    // Save settings & complete onboarding
    await ref
        .read(settingsNotifierProvider.notifier)
        .completeOnboarding(userName: name.isNotEmpty ? name : 'Amigo');

    // Create first goal if provided
    if (goalTitle.isNotEmpty && goalAmount > 0) {
      await ref.read(goalsNotifierProvider.notifier).createGoal(
            GoalEntity(
              id: 0,
              title: goalTitle,
              emoji: _selectedEmoji,
              targetAmount: goalAmount,
              currentAmount: 0,
              colorHex: _selectedColor,
              isArchived: false,
              streak: 0,
              frozenStreak: 0,
              createdAt: DateTime.now(),
            ),
          );
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainShell(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Row(
        children: [
          // ── Left decorative panel ───────────────────────────
          if (size.width > 900)
            Expanded(
              flex: 2,
              child: _LeftPanel(),
            ),
          // ── Right content panel ─────────────────────────────
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Progress dots
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 8),
                  child: _ProgressDots(current: _currentPage, total: 3),
                ),
                // Pages
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _WelcomePage(onNext: _nextPage),
                      _NamePage(
                        controller: _nameController,
                        focus: _nameFocus,
                        onNext: () {
                          if (_nameController.text.trim().isNotEmpty) {
                            _nextPage();
                          }
                        },
                      ),
                      _FirstGoalPage(
                        titleController: _goalTitleController,
                        amountController: _goalAmountController,
                        selectedEmoji: _selectedEmoji,
                        selectedColor: _selectedColor,
                        isCreating: _isCreating,
                        onEmojiChanged: (e) =>
                            setState(() => _selectedEmoji = e),
                        onColorChanged: (c) =>
                            setState(() => _selectedColor = c),
                        onFinish: _finish,
                        onSkip: _finish,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Left decorative panel
// ─────────────────────────────────────────────
class _LeftPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cs.primary, cs.tertiary],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 180,
                filterQuality: FilterQuality.high,
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: -0.2, duration: 800.ms),
              const SizedBox(height: 48),
              ...[
                '💰 Controla tu dinero',
                '🎯 Alcanza tus metas',
                '🔥 Mantén tu racha',
                '🤖 IA financiera personal',
                '📊 Analíticas detalladas',
              ]
                  .asMap()
                  .entries
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            e.value,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: cs.onPrimary,
                                    fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                          .animate(delay: (200 + e.key * 100).ms)
                          .fadeIn(duration: 500.ms)
                          .slideX(begin: -0.2),
                    ),
                  ),
              const Spacer(),
              Text(
                AppConstants.appTagline,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onPrimary.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
              ).animate(delay: 900.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Progress dots
// ─────────────────────────────────────────────
class _ProgressDots extends StatelessWidget {
  final int current;
  final int total;
  const _ProgressDots({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// Page 0 — Welcome
// ─────────────────────────────────────────────
class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png', width: 140)
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.7, 0.7)),
          const SizedBox(height: 40),
          Text('¡Bienvenido a WalletFY!',
              style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800))
              .animate(delay: 300.ms).fadeIn().slideY(begin: 0.2),
          const SizedBox(height: 16),
          Text(
            'Tu compañero inteligente para alcanzar\ntus metas de ahorro.',
            textAlign: TextAlign.center,
            style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
          ).animate(delay: 500.ms).fadeIn(),
          const SizedBox(height: 48),
          FilledButton(
            onPressed: onNext,
            style: FilledButton.styleFrom(
              minimumSize: const Size(200, 52),
            ),
            child: const Text('Comenzar →'),
          ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.3),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Page 1 — Name
// ─────────────────────────────────────────────
class _NamePage extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final VoidCallback onNext;
  const _NamePage(
      {required this.controller,
      required this.focus,
      required this.onNext});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('👋 ¿Cómo te llamas?', style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w700))
              .animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text('Personalizaremos tu experiencia con tu nombre.',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant))
              .animate(delay: 100.ms).fadeIn(),
          const SizedBox(height: 32),
          TextField(
            controller: controller,
            focusNode: focus,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            style: tt.headlineMedium,
            decoration: const InputDecoration(
              hintText: 'Tu nombre...',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            onSubmitted: (_) => onNext(),
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(minimumSize: const Size(160, 52)),
              child: const Text('Siguiente →'),
            ),
          ).animate(delay: 400.ms).fadeIn(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Page 2 — First Goal
// ─────────────────────────────────────────────
class _FirstGoalPage extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final String selectedEmoji;
  final String selectedColor;
  final bool isCreating;
  final ValueChanged<String> onEmojiChanged;
  final ValueChanged<String> onColorChanged;
  final VoidCallback onFinish;
  final VoidCallback onSkip;

  const _FirstGoalPage({
    required this.titleController,
    required this.amountController,
    required this.selectedEmoji,
    required this.selectedColor,
    required this.isCreating,
    required this.onEmojiChanged,
    required this.onColorChanged,
    required this.onFinish,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🎯 Tu primera meta', style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w700))
              .animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text('Crea tu primera meta de ahorro. ¡Puedes agregar más después!',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant))
              .animate(delay: 100.ms).fadeIn(),
          const SizedBox(height: 28),

          // Emoji picker
          Text('Elige un emoji', style: tt.labelLarge),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: AppConstants.goalEmojis.take(15).map((e) {
                final selected = e == selectedEmoji;
                return GestureDetector(
                  onTap: () => onEmojiChanged(e),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected
                          ? cs.primaryContainer
                          : cs.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: selected
                          ? Border.all(color: cs.primary, width: 2)
                          : null,
                    ),
                    child: Center(child: Text(e, style: const TextStyle(fontSize: 22))),
                  ),
                );
              }).toList(),
            ),
          ).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 20),
          // Goal name
          TextField(
            controller: titleController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: '¿Para qué quieres ahorrar?',
              hintText: 'Ej: Laptop nueva, Viaje a Cancún...',
              prefixText: '$selectedEmoji  ',
            ),
          ).animate(delay: 300.ms).fadeIn(),

          const SizedBox(height: 16),
          // Amount
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '¿Cuánto necesitas ahorrar?',
              prefixText: '\$  ',
              hintText: '10,000',
            ),
          ).animate(delay: 400.ms).fadeIn(),

          const SizedBox(height: 16),
          // Color picker
          Text('Color de la meta', style: tt.labelLarge),
          const SizedBox(height: 8),
          Row(
            children: AppConstants.seedColors.map((c) {
              final selected = c.hex == selectedColor;
              return GestureDetector(
                onTap: () => onColorChanged(c.hex),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  width: selected ? 36 : 28,
                  height: selected ? 36 : 28,
                  decoration: BoxDecoration(
                    color: AppTheme.hexToColor(c.hex),
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(color: cs.onSurface, width: 3)
                        : null,
                    boxShadow: selected
                        ? [BoxShadow(color: AppTheme.hexToColor(c.hex).withOpacity(0.5), blurRadius: 8)]
                        : null,
                  ),
                ),
              );
            }).toList(),
          ).animate(delay: 500.ms).fadeIn(),

          const SizedBox(height: 36),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isCreating ? null : onSkip,
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
                  child: const Text('Saltar por ahora'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: isCreating ? null : onFinish,
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
                  child: isCreating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('¡Empezar a ahorrar! 🚀'),
                ),
              ),
            ],
          ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),
        ],
      ),
    );
  }
}
