import 'package:fiscal/presentation/widgets/home/transactions_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  testWidgets('render transaction summary widget with correct values.', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TransactionsSummary(),
      ),
    );

    //find total_balance
    final totalBalance = find.byKey(ValueKey("total_balance"));
    expect(totalBalance, findsOneWidget);

    //find income value
    final income = find.byKey(ValueKey('income'));
    expect(income, findsOneWidget);
    expect(find.text('3,300.00'), findsOneWidget);

    //find expense value
    final expense = find.byKey(ValueKey('expense'));
    expect(expense, findsOneWidget);
    expect(find.text('1,500.00'), findsOneWidget);
  });
}
