import 'package:fiscal/presentation/screens/home/recent_transactions.dart';
import 'package:fiscal/presentation/widgets/home/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  testWidgets('fetch recent transactions and show them in list.',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RecentTransactions()));

    final items = find.byType(TransactionItem);
    expect(items, findsNWidgets(5));
  });
}
