import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:local_notifier/local_notifier.dart';

import 'core/theme/app_theme.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/pages/onboarding/onboarding_page.dart';
import 'presentation/pages/dashboard/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local notifications
  await localNotifier.setup(appName: 'WalletFY');

  // Configure flutter_animate defaults
  Animate.restartOnHotReload = true;

  runApp(
    const ProviderScope(
      child: WalletFYApp(),
    ),
  );
}

class WalletFYApp extends ConsumerWidget {
  const WalletFYApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeNotifierProvider);
    final settingsAsync = ref.watch(settingsStreamProvider);

    return MaterialApp(
      title: 'WalletFY',
      debugShowCheckedModeBanner: false,
      themeMode: themeState.mode,
      theme: AppTheme.light(themeState.seedColor),
      darkTheme: AppTheme.dark(themeState.seedColor),
      home: settingsAsync.when(
        loading: () => const _SplashScreen(),
        error: (_, __) => const _SplashScreen(),
        data: (settings) {
          if (settings == null || !settings.isOnboardingDone) {
            return const OnboardingPage();
          }
          return const MainShell();
        },
      ),
    );
  }
}

/// Animated splash screen shown while loading settings.
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              width: 180,
              filterQuality: FilterQuality.high,
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: cs.surfaceContainerHighest,
                color: cs.primary,
              ),
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
