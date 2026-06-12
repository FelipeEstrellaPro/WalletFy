import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dashboard/dashboard_page.dart';
import '../goals/goals_page.dart';
import '../analytics/analytics_page.dart';
import '../chat/chat_page.dart';
import '../profile/profile_page.dart';

/// Desktop navigation shell using a custom Premium Glass Sidebar
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  final _pages = const [
    DashboardPage(),
    GoalsPage(),
    AnalyticsPage(),
    ChatPage(),
    ProfilePage(),
  ];

  final _menuItems = const [
    {'icon': Icons.dashboard_rounded, 'label': 'Inicio'},
    {'icon': Icons.savings_rounded, 'label': 'Metas'},
    {'icon': Icons.bar_chart_rounded, 'label': 'Analíticas'},
    {'icon': Icons.smart_toy_rounded, 'label': 'IA Chat'},
    {'icon': Icons.person_rounded, 'label': 'Perfil'},
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Row(
        children: [
          // ── Custom Premium Sidebar ───────────────────────────
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              border: Border(
                right: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Stack(
              children: [
                // Subtle sidebar background glow
                Positioned(
                  top: 0,
                  left: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(color: Colors.transparent),
                  ),
                ),

                // Sidebar content
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Brand / Logo ──
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: cs.primaryContainer.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 36,
                                filterQuality: FilterQuality.high,
                              ),
                            ).animate().scaleXY(duration: 400.ms, curve: Curves.easeOutBack),
                            const SizedBox(width: 16),
                            Text(
                              'WalletFY',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                            ).animate().fadeIn(delay: 200.ms),
                          ],
                        ),
                      ),

                      // ── Menu Items ──
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _menuItems.length,
                          itemBuilder: (context, i) {
                            final item = _menuItems[i];
                            final isSelected = _selectedIndex == i;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _SidebarItem(
                                icon: item['icon'] as IconData,
                                label: item['label'] as String,
                                isSelected: isSelected,
                                onTap: () => setState(() => _selectedIndex = i),
                              ),
                            ).animate(delay: (100 + i * 50).ms).fadeIn().slideX(begin: -0.1);
                          },
                        ),
                      ),
                      
                      // ── Footer ──
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Ahorro que Inspira\nv1.0.0',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                                height: 1.5,
                              ),
                        ),
                      ).animate().fadeIn(delay: 600.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Page Content ─────────────────────────────────────
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                bottomLeft: Radius.circular(32),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.02, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(_selectedIndex),
                  child: _pages[_selectedIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuart,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? cs.primary.withValues(alpha: 0.15)
                : _isHovered
                    ? cs.onSurface.withValues(alpha: 0.05)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? cs.primary.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: widget.isSelected
                    ? cs.primary
                    : cs.onSurfaceVariant.withValues(alpha: _isHovered ? 1.0 : 0.7),
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.isSelected
                          ? cs.primary
                          : cs.onSurfaceVariant.withValues(alpha: _isHovered ? 1.0 : 0.7),
                      fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
              ),
              const Spacer(),
              if (widget.isSelected)
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
