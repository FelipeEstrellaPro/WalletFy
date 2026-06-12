import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:walletfy/main.dart';

void main() {
  testWidgets('App launches without crash', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: WalletFYApp()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
