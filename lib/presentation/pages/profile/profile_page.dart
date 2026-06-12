import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/user_settings_entity.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_provider.dart';
import '../onboarding/onboarding_page.dart';

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
      // Very basic reset for demo
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
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) {
          if (settings == null) return const Center(child: Text('Sin datos'));

          // Sync controllers if not editing
          if (!_isEditingOllama) {
            _urlCtrl.text = settings.ollamaUrl;
            _modelCtrl.text = settings.ollamaModel;
          }

          final repo = ref.read(settingsRepositoryProvider);

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            children: [
              // ── Header (Avatar & Name) ───────────────────────
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: cs.primaryContainer,
                      child: Text(
                        settings.userName.isNotEmpty
                            ? settings.userName[0].toUpperCase()
                            : 'W',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimaryContainer),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      settings.userName.isNotEmpty
                          ? settings.userName
                          : 'Usuario',
                      style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // ── Theme Settings ────────────────────────────────
              Text('Apariencia',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _SectionCard(
                children: [
                  ListTile(
                    leading: const Icon(Icons.dark_mode_rounded),
                    title: const Text('Modo de tema'),
                    trailing: DropdownButton<AppThemeMode>(
                      value: settings.themeMode,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                            value: AppThemeMode.system, child: Text('Sistema')),
                        DropdownMenuItem(
                            value: AppThemeMode.light, child: Text('Claro')),
                        DropdownMenuItem(
                            value: AppThemeMode.dark, child: Text('Oscuro')),
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
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Color principal', style: tt.bodyMedium),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            '#6366F1', // Indigo
                            '#3B82F6', // Blue
                            '#10B981', // Emerald
                            '#F59E0B', // Amber
                            '#EF4444', // Red
                            '#8B5CF6', // Violet
                            '#EC4899', // Pink
                            '#14B8A6', // Teal
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
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(color: cs.onSurface, width: 2)
                                      : null,
                                ),
                                child: isSelected
                                    ? Icon(Icons.check_rounded,
                                        size: 20,
                                        color: color.computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white)
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
              const SizedBox(height: 24),

              // ── Notifications ─────────────────────────────────
              Text('Recordatorios',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _SectionCard(
                children: [
                  SwitchListTile(
                    value: settings.reminderEnabled,
                    title: const Text('Notificaciones diarias'),
                    subtitle: const Text('Recordatorio para abonar a tus metas'),
                    secondary: const Icon(Icons.notifications_active_rounded),
                    onChanged: (v) => repo.saveReminder(v, settings.reminderTime),
                  ),
                  if (settings.reminderEnabled) ...[
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.access_time_rounded),
                      title: const Text('Hora del recordatorio'),
                      trailing: TextButton(
                        onPressed: () async {
                          final current = DateFormatter.parseTime(settings.reminderTime);
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                                hour: current.hour, minute: current.minute),
                          );
                          if (time != null) {
                            final str =
                                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                            repo.saveReminder(
                                settings.reminderEnabled, str);
                          }
                        },
                        child: Text(
                          settings.reminderTime,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
              const SizedBox(height: 24),

              // ── IA Ollama Settings ────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('IA Integrada (Ollama)',
                      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  IconButton(
                    icon: Icon(_isEditingOllama ? Icons.close_rounded : Icons.edit_rounded),
                    onPressed: () {
                      if (_isEditingOllama) {
                        // Cancel edit
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
              ),
              const SizedBox(height: 8),
              _SectionCard(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _urlCtrl,
                          enabled: _isEditingOllama,
                          decoration: const InputDecoration(
                            labelText: 'URL de Ollama',
                            prefixIcon: Icon(Icons.link_rounded),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _modelCtrl,
                          enabled: _isEditingOllama,
                          decoration: const InputDecoration(
                            labelText: 'Modelo (Ej. llama3, mistral)',
                            prefixIcon: Icon(Icons.smart_toy_rounded),
                            isDense: true,
                          ),
                        ),
                        if (_isEditingOllama) ...[
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () => _saveOllamaConfig(settings),
                              child: const Text('Guardar configuración de IA'),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ── Danger Zone ───────────────────────────────────
              OutlinedButton.icon(
                onPressed: _resetApp,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.delete_forever_rounded),
                label: const Text('Borrar todos mis datos'),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
