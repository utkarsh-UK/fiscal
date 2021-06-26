import 'package:fiscal/presentation/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  testWidgets('show summary and recent transactions when app is loaded.', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));

    final summaryWidget = find.byKey(ValueKey('summary'));
    expect(summaryWidget, findsOneWidget);

    final seeAllBtn = find.byKey(ValueKey('see_all'));
    expect(seeAllBtn, findsOneWidget);

    final recentTransactions = find.byKey(ValueKey('recent_transactions'));
    expect(recentTransactions, findsOneWidget);
  });
}
