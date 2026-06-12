import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/goal_entity.dart';
import '../../providers/database_provider.dart';

class AddGoalPage extends ConsumerStatefulWidget {
  const AddGoalPage({super.key});

  @override
  ConsumerState<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends ConsumerState<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  DateTime? _selectedDeadline;
  String _selectedEmoji = '🎯';
  String _selectedColor = '#6366F1'; // Indigo base

  final List<String> _emojis = ['🎯', '🚗', '✈️', '💻', '🏠', '💍', '📚', '🎉', '👗', '🎸', '📱', '🎮'];
  final List<String> _colors = [
    '#6366F1', // Indigo
    '#3B82F6', // Blue
    '#10B981', // Emerald
    '#F59E0B', // Amber
    '#EF4444', // Red
    '#8B5CF6', // Violet
    '#EC4899', // Pink
    '#14B8A6', // Teal
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _saveGoal() {
    if (!_formKey.currentState!.validate()) return;

    final targetAmount = CurrencyFormatter.tryParse(_amountCtrl.text);
    if (targetAmount == null || targetAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa una cantidad válida a ahorrar')),
      );
      return;
    }

    final newGoal = GoalEntity(
      id: 0,
      title: _titleCtrl.text.trim(),
      emoji: _selectedEmoji,
      targetAmount: targetAmount,
      currentAmount: 0,
      deadline: _selectedDeadline,
      colorHex: _selectedColor,
      isArchived: false,
      streak: 0,
      frozenStreak: 0,
      createdAt: DateTime.now(),
    );

    ref.read(goalRepositoryProvider).createGoal(newGoal).then((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Meta'),
        actions: [
          TextButton.icon(
            onPressed: _saveGoal,
            icon: const Icon(Icons.check_rounded),
            label: const Text('Guardar'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji Selector
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.hexToColor(_selectedColor).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedEmoji,
                        icon: const SizedBox.shrink(),
                        alignment: Alignment.center,
                        style: const TextStyle(fontSize: 48),
                        items: _emojis
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedEmoji = v!),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              TextFormField(
                controller: _titleCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la meta',
                  hintText: 'Ej. Viaje a Japón, Laptop nueva...',
                  prefixIcon: Icon(Icons.flag_rounded),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: 24),

              // Amount
              TextFormField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Cantidad objetivo',
                  hintText: '\$0.00',
                  prefixIcon: Icon(Icons.monetization_on_rounded),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa una cantidad';
                  if (CurrencyFormatter.tryParse(v) == null) return 'Formato inválido';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Deadline
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Fecha límite (Opcional)',
                    style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  _selectedDeadline == null
                      ? 'Sin límite de tiempo'
                      : DateFormatter.formatDayMonth(_selectedDeadline!),
                  style: tt.bodyMedium?.copyWith(
                    color: _selectedDeadline == null
                        ? cs.onSurfaceVariant
                        : cs.primary,
                  ),
                ),
                trailing: _selectedDeadline == null
                    ? Icon(Icons.calendar_month_rounded, color: cs.primary)
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() => _selectedDeadline = null),
                      ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (date != null) {
                    setState(() => _selectedDeadline = date);
                  }
                },
              ),
              const Divider(height: 32),

              // Color picker
              Text('Color de la meta',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colors.map((hex) {
                  final color = AppTheme.hexToColor(hex);
                  final isSelected = hex == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = hex),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: cs.onSurface, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? Icon(Icons.check_rounded,
                              color: color.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveGoal,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Crear Meta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
