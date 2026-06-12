import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────
// Soft Animated Background
// ─────────────────────────────────────────────
class SoftAnimatedBackground extends StatelessWidget {
  const SoftAnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(color: Theme.of(context).scaffoldBackgroundColor),
        Positioned(
          top: -100,
          left: -50,
          child: _GlowingOrb(color: cs.primary, size: 400, alpha: 0.15)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .move(duration: 15.seconds, begin: Offset.zero, end: const Offset(100, 50)),
        ),
        Positioned(
          bottom: 100,
          right: -100,
          child: _GlowingOrb(color: cs.tertiary, size: 500, alpha: 0.1)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .move(duration: 20.seconds, begin: Offset.zero, end: const Offset(-50, 100)),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
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
  final double alpha;
  const _GlowingOrb({required this.color, required this.size, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: alpha),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Glass Wrapper
// ─────────────────────────────────────────────
class GlassWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Gradient? customGradient;

  const GlassWrapper({super.key, required this.child, this.padding, this.customGradient});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: customGradient,
            color: customGradient == null
                ? (isDark
                    ? cs.surface.withValues(alpha: 0.4)
                    : cs.surface.withValues(alpha: 0.7))
                : null,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
