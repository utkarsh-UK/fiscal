import 'package:fiscal/presentation/widgets/core/empty_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  testWidgets('render empty transactions error message and CTA for adding new transaction.', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EmptyTransactions(),
      ),
    );

    //find no transaction message
    final noTransactions = find.byKey(ValueKey('empty_state'));
    expect(noTransactions, findsOneWidget);
    expect(find.text('No Transactions yet.\nGet started by adding transaction.'), findsOneWidget);

    //find actions
    final addTranCTA = find.byKey(ValueKey('cta'));
    expect(addTranCTA, findsOneWidget);
  });
}
