import 'dart:ui';
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
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuint,
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

    await ref
        .read(settingsNotifierProvider.notifier)
        .completeOnboarding(userName: name.isNotEmpty ? name : 'Amigo');

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
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Immersive Animated Background ──
          const _AnimatedBackground(),

          // ── Centered Glass Card ──
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _GlassCard(
                width: isDesktop ? 600 : size.width * 0.95,
                height: isDesktop ? 700 : size.height * 0.85,
                child: Column(
                  children: [
                    // Top Progress Indicator
                    Padding(
                      padding: const EdgeInsets.only(top: 32, bottom: 16),
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
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Premium Animated Background
// ─────────────────────────────────────────────
class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
        // Orb 1 (Primary)
        Positioned(
          top: -150,
          left: -150,
          child: _GlowingOrb(color: cs.primary, size: 500)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .move(duration: 10.seconds, begin: Offset.zero, end: const Offset(150, 100)),
        ),
        // Orb 2 (Tertiary)
        Positioned(
          bottom: -200,
          right: -100,
          child: _GlowingOrb(color: cs.tertiary, size: 600)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .move(duration: 12.seconds, begin: Offset.zero, end: const Offset(-200, -150)),
        ),
        // Orb 3 (Secondary)
        Positioned(
          top: 300,
          right: -200,
          child: _GlowingOrb(color: cs.secondary, size: 450)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .move(duration: 15.seconds, begin: Offset.zero, end: const Offset(-100, 200)),
        ),
        // Extreme Blur Layer
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}

class _GlowingOrb extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowingOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.4),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Glassmorphic Card
// ─────────────────────────────────────────────
class _GlassCard extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  const _GlassCard({required this.child, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isDark
                ? cs.surface.withValues(alpha: 0.4)
                : cs.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: child,
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic);
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
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuart,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: active ? 32 : 12,
          height: 8,
          decoration: BoxDecoration(
            color: active ? cs.primary : cs.onSurface.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: active
                ? [BoxShadow(color: cs.primary.withValues(alpha: 0.4), blurRadius: 8)]
                : null,
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
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primaryContainer.withValues(alpha: 0.5),
            ),
            child: Image.asset('assets/images/logo.png', width: 140)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: -5, end: 5, duration: 2.seconds, curve: Curves.easeInOut),
          ).animate().fadeIn(duration: 600.ms).scaleXY(begin: 0.8),
          const SizedBox(height: 48),
          Text(
            'Bienvenido a WalletFY',
            textAlign: TextAlign.center,
            style: tt.displaySmall?.copyWith(fontWeight: FontWeight.w900, color: cs.onSurface),
          ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 16),
          Text(
            'Ahorro que Inspira. Crecimiento Claro.\nTu asesor financiero inteligente personal.',
            textAlign: TextAlign.center,
            style: tt.titleMedium?.copyWith(color: cs.onSurfaceVariant, height: 1.5),
          ).animate(delay: 500.ms).fadeIn(),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text('Comenzar →', style: tt.titleMedium?.copyWith(color: cs.onPrimary, fontWeight: FontWeight.bold)),
            ),
          ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cs.primaryContainer, shape: BoxShape.circle),
            child: Icon(Icons.waving_hand_rounded, size: 40, color: cs.primary),
          ).animate().fadeIn().scaleXY(),
          const SizedBox(height: 32),
          Text('¿Cómo te llamas?', style: tt.displaySmall?.copyWith(fontWeight: FontWeight.w800))
              .animate(delay: 200.ms).fadeIn().slideX(begin: -0.1),
          const SizedBox(height: 12),
          Text('Personalizaremos la experiencia de la IA para ti.',
              style: tt.titleMedium?.copyWith(color: cs.onSurfaceVariant))
              .animate(delay: 300.ms).fadeIn(),
          const SizedBox(height: 48),
          TextField(
            controller: controller,
            focusNode: focus,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: 'Tu nombre...',
              hintStyle: tt.headlineMedium?.copyWith(color: cs.onSurface.withValues(alpha: 0.2)),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 16, left: 8),
                child: Icon(Icons.person_outline_rounded, size: 32, color: cs.primary),
              ),
              border: UnderlineInputBorder(borderSide: BorderSide(color: cs.primary.withValues(alpha: 0.3), width: 2)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: cs.primary.withValues(alpha: 0.3), width: 2)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: cs.primary, width: 3)),
            ),
            onSubmitted: (_) => onNext(),
          ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text('Siguiente →', style: tt.titleMedium?.copyWith(color: cs.onPrimary, fontWeight: FontWeight.bold)),
            ),
          ).animate(delay: 600.ms).fadeIn(),
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
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: cs.tertiaryContainer, shape: BoxShape.circle),
                child: Icon(Icons.rocket_launch_rounded, size: 32, color: cs.tertiary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text('Tu primera meta', style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
              ),
            ],
          ).animate().fadeIn().slideX(begin: -0.1),
          const SizedBox(height: 12),
          Text('Define un objetivo que te inspire a ahorrar todos los días.',
              style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant))
              .animate(delay: 100.ms).fadeIn(),
          const SizedBox(height: 32),

          // Goal name
          TextField(
            controller: titleController,
            textCapitalization: TextCapitalization.sentences,
            style: tt.titleLarge,
            decoration: InputDecoration(
              labelText: '¿Qué quieres lograr?',
              hintText: 'Ej: Viaje a Japón...',
              prefixText: '$selectedEmoji  ',
              filled: true,
              fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 20),
          // Amount
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: tt.titleLarge?.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: '¿Cuánto necesitas?',
              prefixText: '\$  ',
              hintText: '10,000',
              filled: true,
              fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 24),
          // Emoji picker
          Text('Personaliza el Emoji', style: tt.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: AppConstants.goalEmojis.take(15).map((e) {
                final selected = e == selectedEmoji;
                return GestureDetector(
                  onTap: () => onEmojiChanged(e),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: selected ? cs.primaryContainer : cs.surfaceContainerLowest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: selected ? Border.all(color: cs.primary, width: 2) : null,
                    ),
                    child: Center(child: Text(e, style: const TextStyle(fontSize: 26))),
                  ),
                );
              }).toList(),
            ),
          ).animate(delay: 400.ms).fadeIn(),

          const SizedBox(height: 24),
          // Color picker
          Text('Color del Progreso', style: tt.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: AppConstants.seedColors.take(7).map((c) {
              final selected = c.hex == selectedColor;
              return GestureDetector(
                onTap: () => onColorChanged(c.hex),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: selected ? 44 : 36,
                  height: selected ? 44 : 36,
                  decoration: BoxDecoration(
                    color: AppTheme.hexToColor(c.hex),
                    shape: BoxShape.circle,
                    border: selected ? Border.all(color: cs.surface, width: 3) : null,
                    boxShadow: selected ? [BoxShadow(color: AppTheme.hexToColor(c.hex).withValues(alpha: 0.5), blurRadius: 12)] : null,
                  ),
                ),
              );
            }).toList(),
          ).animate(delay: 500.ms).fadeIn(),

          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: isCreating ? null : onSkip,
                  style: TextButton.styleFrom(minimumSize: const Size(0, 60)),
                  child: const Text('Saltar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: isCreating ? null : onFinish,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: isCreating
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                        )
                      : Text('Empezar a Ahorrar 🚀', style: tt.titleMedium?.copyWith(color: cs.onPrimary, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),
        ],
      ),
    );
  }
}
