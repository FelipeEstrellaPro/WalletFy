import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/goals_provider.dart';
import '../../widgets/goals/goal_progress_card.dart';
import '../../widgets/common/premium_glass_widgets.dart';
import 'add_goal_page.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(activeGoalsProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Premium Soft Background ──
          const SoftAnimatedBackground(),

          // ── Main Content ──
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Glass App Bar ──
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: cs.surface.withValues(alpha: 0.7),
                surfaceTintColor: Colors.transparent,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(color: Colors.transparent),
                  ),
                ),
                elevation: 0,
                expandedHeight: 80,
                toolbarHeight: 70,
                title: Text(
                  'Tus Metas',
                  style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0, top: 8, bottom: 8),
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddGoalPage()),
                      ),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Nueva meta', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),

              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: goalsAsync.when(
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => SliverFillRemaining(
                    child: Center(child: Text('Error: $e')),
                  ),
                  data: (goals) {
                    if (goals.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
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
                                  child: const Text('🎯', style: TextStyle(fontSize: 64)),
                                ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: -5, end: 5, duration: 2.seconds),
                                const SizedBox(height: 24),
                                Text(
                                  'Aún no tienes metas',
                                  style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Crea tu primera meta de ahorro y comienza tu viaje financiero.',
                                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  height: 52,
                                  child: FilledButton.icon(
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const AddGoalPage()),
                                    ),
                                    style: FilledButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    icon: const Icon(Icons.add_rounded),
                                    label: const Text('Crear mi primera meta', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 800.ms).scaleXY(begin: 0.95),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GoalProgressCard(goal: goals[i])
                                .animate(delay: (100 + i * 80).ms)
                                .fadeIn(duration: 500.ms)
                                .slideX(begin: 0.05, curve: Curves.easeOutQuad),
                          );
                        },
                        childCount: goals.length,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
