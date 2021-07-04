import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/presentation/widgets/home/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  testWidgets('render single transaction item as a list tile.',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TransactionItem(
          title: 'title',
          description: 'desc',
          transactionType: TransactionType.INCOME,
          amount: 100.983223,
          transactionDate: DateTime(2021, 06, 26),
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
