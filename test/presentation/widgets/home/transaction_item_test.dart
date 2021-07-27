import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';
import 'package:fiscal/presentation/widgets/home/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  DateTime transactionDate =  DateTime(2021, 06, 26);
  Transaction transaction = Transaction(
    transactionID: '1',
    title: 'title',
    amount: 100.983223,
    transactionType: TransactionType.INCOME,
    categoryID: 1,
    accountID: 1,
    date: transactionDate,
    description: 'desc',
  );

  testWidgets('render single transaction item as a list tile.', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TransactionItem(
          transaction: transaction,
          ),
        ),
      ),
    );

    //find respective icon
    final icon = find.byKey(ValueKey("icon"));
    expect(icon, findsOneWidget);

    //find title
    final title = find.byKey(ValueKey('title'));
    expect(title, findsOneWidget);
    expect(find.text('title'), findsOneWidget);

    //find transaction type
    final type = find.byKey(ValueKey('type'));
    expect(type, findsOneWidget);
    expect(find.text('Income'), findsOneWidget);

    // find amount
    final amount = find.byKey(ValueKey('amount'));
    expect(amount, findsOneWidget);
    expect(find.text('₹100.98'), findsOneWidget);
  });
}
