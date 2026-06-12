import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/user_settings_entity.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_provider.dart';
import '../onboarding/onboarding_page.dart';
import '../../widgets/common/premium_glass_widgets.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _urlCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();

  bool _isEditingOllama = false;

  @override
  void dispose() {
    _urlCtrl.dispose();
    _modelCtrl.dispose();
    super.dispose();
  }

  void _saveOllamaConfig(UserSettingsEntity settings) {
    if (_urlCtrl.text.trim().isEmpty || _modelCtrl.text.trim().isEmpty) return;
    
    final repo = ref.read(settingsRepositoryProvider);
    repo.saveOllamaConfig(
      _urlCtrl.text.trim(),
      _modelCtrl.text.trim(),
    );
    setState(() => _isEditingOllama = false);
  }

  void _resetApp() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Borrar todos los datos?'),
        content: const Text(
            'Esto eliminará todas tus metas, transacciones, rachas y configuraciones. Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Borrar Todo'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final db = ref.read(appDatabaseProvider);
      await db.delete(db.transactions).go();
      await db.delete(db.goals).go();
      await db.delete(db.userSettings).go();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
          (r) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsStreamProvider);
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
                  'Perfil',
                  style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                sliver: settingsAsync.when(
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => SliverFillRemaining(
                    child: Center(child: Text('Error: $e')),
                  ),
                  data: (settings) {
                    if (settings == null) return const SliverToBoxAdapter(child: Center(child: Text('Sin datos')));

                    if (!_isEditingOllama) {
                      _urlCtrl.text = settings.ollamaUrl;
                      _modelCtrl.text = settings.ollamaModel;
                    }

                    final repo = ref.read(settingsRepositoryProvider);

                    return SliverList(
                      delegate: SliverChildListDelegate([
                        // ── Header (Avatar & Name) ───────────────────────
                        Center(
                          child: Column(
                            children: [
                              GlassWrapper(
                                padding: const EdgeInsets.all(8),
                                child: CircleAvatar(
                                  radius: 56,
                                  backgroundColor: cs.primary.withValues(alpha: 0.2),
                                  child: Text(
                                    settings.userName.isNotEmpty ? settings.userName[0].toUpperCase() : 'W',
                                    style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w900,
                                        color: cs.primary),
                                  ),
                                ),
                              ).animate().scaleXY(curve: Curves.easeOutBack, duration: 600.ms),
                              const SizedBox(height: 24),
                              Text(
                                settings.userName.isNotEmpty ? settings.userName : 'Usuario',
                                style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                              ).animate(delay: 200.ms).fadeIn(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),

                        // ── Theme Settings ────────────────────────────────
                        Text('Apariencia', style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800))
                            .animate(delay: 300.ms).fadeIn(),
                        const SizedBox(height: 16),
                        GlassWrapper(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.dark_mode_rounded, color: cs.primary),
                                title: const Text('Modo de tema', style: TextStyle(fontWeight: FontWeight.w600)),
                                trailing: DropdownButton<AppThemeMode>(
                                  value: settings.themeMode,
                                  underline: const SizedBox(),
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                  borderRadius: BorderRadius.circular(16),
                                  items: const [
                                    DropdownMenuItem(value: AppThemeMode.system, child: Text('Sistema')),
                                    DropdownMenuItem(value: AppThemeMode.light, child: Text('Claro')),
                                    DropdownMenuItem(value: AppThemeMode.dark, child: Text('Oscuro')),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) {
                                      ref.read(themeNotifierProvider.notifier).changeTheme(
                                            settings.themeSeedColor,
                                            v,
                                          );
                                    }
                                  },
                                ),
                              ),
                              Divider(color: cs.outlineVariant.withValues(alpha: 0.2), height: 1),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Color principal', style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 16),
                                    Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      children: [
                                        '#6366F1', '#3B82F6', '#10B981', '#F59E0B', 
                                        '#EF4444', '#8B5CF6', '#EC4899', '#14B8A6',
                                      ].map((hex) {
                                        final color = AppTheme.hexToColor(hex);
                                        final isSelected = hex == settings.themeSeedColor;
                                        return GestureDetector(
                                          onTap: () {
                                            ref.read(themeNotifierProvider.notifier).changeTheme(
                                                  hex,
                                                  settings.themeMode,
                                                );
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 300),
                                            width: isSelected ? 44 : 40,
                                            height: isSelected ? 44 : 40,
                                            decoration: BoxDecoration(
                                              color: color,
                                              shape: BoxShape.circle,
                                              border: isSelected ? Border.all(color: cs.onSurface, width: 3) : null,
                                              boxShadow: isSelected
                                                  ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10)]
                                                  : null,
                                            ),
                                            child: isSelected
                                                ? Icon(Icons.check_rounded,
                                                    size: 24,
                                                    color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                                                : null,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.05),
                        const SizedBox(height: 32),

                        // ── Notifications ─────────────────────────────────
                        Text('Recordatorios', style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800))
                            .animate(delay: 500.ms).fadeIn(),
                        const SizedBox(height: 16),
                        GlassWrapper(
                          child: Column(
                            children: [
                              SwitchListTile(
                                value: settings.reminderEnabled,
                                title: const Text('Notificaciones diarias', style: TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: const Text('Recordatorio para abonar a tus metas'),
                                secondary: Icon(Icons.notifications_active_rounded, color: cs.secondary),
                                activeColor: cs.primary,
                                onChanged: (v) => repo.saveReminder(v, settings.reminderTime),
                              ),
                              if (settings.reminderEnabled) ...[
                                Divider(color: cs.outlineVariant.withValues(alpha: 0.2), height: 1),
                                ListTile(
                                  leading: Icon(Icons.access_time_rounded, color: cs.secondary),
                                  title: const Text('Hora del recordatorio'),
                                  trailing: FilledButton.tonal(
                                    onPressed: () async {
                                      final current = DateFormatter.parseTime(settings.reminderTime);
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(hour: current.hour, minute: current.minute),
                                      );
                                      if (time != null) {
                                        final str = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                                        repo.saveReminder(settings.reminderEnabled, str);
                                      }
                                    },
                                    child: Text(settings.reminderTime, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.05),
                        const SizedBox(height: 32),

                        // ── IA Ollama Settings ────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('IA Integrada (Ollama)', style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                            IconButton(
                              icon: Icon(_isEditingOllama ? Icons.close_rounded : Icons.edit_rounded, color: cs.tertiary),
                              onPressed: () {
                                if (_isEditingOllama) {
                                  setState(() {
                                    _isEditingOllama = false;
                                    _urlCtrl.text = settings.ollamaUrl;
                                    _modelCtrl.text = settings.ollamaModel;
                                  });
                                } else {
                                  setState(() => _isEditingOllama = true);
                                }
                              },
                            )
                          ],
                        ).animate(delay: 700.ms).fadeIn(),
                        const SizedBox(height: 8),
                        GlassWrapper(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _urlCtrl,
                                  enabled: _isEditingOllama,
                                  decoration: InputDecoration(
                                    labelText: 'URL de Ollama',
                                    prefixIcon: const Icon(Icons.link_rounded),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                    filled: true,
                                    fillColor: cs.surface.withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _modelCtrl,
                                  enabled: _isEditingOllama,
                                  decoration: InputDecoration(
                                    labelText: 'Modelo (Ej. llama3, mistral)',
                                    prefixIcon: const Icon(Icons.smart_toy_rounded),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                    filled: true,
                                    fillColor: cs.surface.withValues(alpha: 0.5),
                                  ),
                                ),
                                if (_isEditingOllama) ...[
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: FilledButton.icon(
                                      onPressed: () => _saveOllamaConfig(settings),
                                      icon: const Icon(Icons.save_rounded),
                                      label: const Text('Guardar configuración de IA', style: TextStyle(fontWeight: FontWeight.bold)),
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.05),
                        const SizedBox(height: 48),

                        // ── Danger Zone ───────────────────────────────────
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: _resetApp,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.delete_forever_rounded),
                            label: const Text('Borrar todos mis datos', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ).animate(delay: 900.ms).fadeIn(),
                        const SizedBox(height: 48),
                      ]),
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
