import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/goal_entity.dart';
import '../../providers/goals_provider.dart';

/// Quick deposit dialog — accessible from dashboard FAB.
class QuickDepositDialog extends ConsumerStatefulWidget {
  final List<GoalEntity> goals;
  const QuickDepositDialog({super.key, required this.goals});

  @override
  ConsumerState<QuickDepositDialog> createState() =>
      _QuickDepositDialogState();
}

class _QuickDepositDialogState extends ConsumerState<QuickDepositDialog> {
  late GoalEntity _selectedGoal;
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  TransactionCategory _category = TransactionCategory.deposit;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.goals.first;
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount =
        double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
    if (amount <= 0) {
      setState(() => _error = 'Ingresa un monto válido');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (_category == TransactionCategory.withdrawal) {
        await ref.read(goalsNotifierProvider.notifier).withdraw(
              goalId: _selectedGoal.id,
              amount: amount,
              note: _noteCtrl.text.trim().isEmpty
                  ? null
                  : _noteCtrl.text.trim(),
            );
      } else {
        await ref.read(goalsNotifierProvider.notifier).deposit(
              goalId: _selectedGoal.id,
              amount: amount,
              category: _category,
              note: _noteCtrl.text.trim().isEmpty
                  ? null
                  : _noteCtrl.text.trim(),
            );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.add_circle_outline_rounded,
                        color: cs.onPrimaryContainer, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text('Registrar movimiento',
                      style: tt.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Category selector
              SegmentedButton<TransactionCategory>(
                segments: const [
                  ButtonSegment(
                    value: TransactionCategory.deposit,
                    label: Text('Depósito'),
                    icon: Icon(Icons.arrow_upward_rounded),
                  ),
                  ButtonSegment(
                    value: TransactionCategory.scheduled,
                    label: Text('Programado'),
                    icon: Icon(Icons.calendar_month_rounded),
                  ),
                  ButtonSegment(
                    value: TransactionCategory.withdrawal,
                    label: Text('Retiro'),
                    icon: Icon(Icons.arrow_downward_rounded),
                  ),
                ],
                selected: {_category},
                onSelectionChanged: (s) =>
                    setState(() => _category = s.first),
              ),

              const SizedBox(height: 20),

              // Goal selector
              DropdownButtonFormField<GoalEntity>(
                initialValue: _selectedGoal,
                decoration: const InputDecoration(
                  labelText: 'Meta',
                  prefixIcon: Icon(Icons.flag_rounded),
                ),
                items: widget.goals
                    .map((g) => DropdownMenuItem(
                          value: g,
                          child: Text('${g.emoji}  ${g.title}'),
                        ))
                    .toList(),
                onChanged: (g) {
                  if (g != null) setState(() => _selectedGoal = g);
                },
              ),

              const SizedBox(height: 16),

              // Amount
              TextField(
                controller: _amountCtrl,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Monto',
                  prefixText: '\$  ',
                  hintText: '500.00',
                  errorText: _error,
                ),
              ),

              const SizedBox(height: 16),

              // Note
              TextField(
                controller: _noteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nota (opcional)',
                  prefixIcon: Icon(Icons.notes_rounded),
                  hintText: 'Quincena, extra, etc.',
                ),
              ),

              const SizedBox(height: 28),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _category == TransactionCategory.withdrawal
                              ? 'Registrar retiro'
                              : 'Registrar depósito',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
