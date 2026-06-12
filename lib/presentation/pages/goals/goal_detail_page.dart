import 'package:flutter/material.dart';

/// Placeholder — implemented fully in FASE 4.
class GoalDetailPage extends StatelessWidget {
  final int goalId;
  const GoalDetailPage({super.key, required this.goalId});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Detalle de Meta')),
        body: const Center(child: Text('FASE 4 — Detalle de Meta')),
      );
}
