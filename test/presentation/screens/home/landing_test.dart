import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/screens/home/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../widgets/home/transaction_form_test.mocks.dart';

void main() {
  late MockTransactionProvider mockTransactionProvider;
  late MockTransactionProviderData mockTransactionProviderData;

  setUp(() {
    mockTransactionProvider = MockTransactionProvider();
    mockTransactionProviderData = MockTransactionProviderData();
    when(mockTransactionProvider.hasListeners).thenReturn(false);
  });


  final _transactions = [
    Transaction(
        transactionID: '1',
        title: 'Invested in Stocks And Mutual Funds',
        amount: 1765.6,
        transactionType: TransactionType.INCOME,
        categoryID: '12',
        accountID: 2,
        date: DateTime.now(),
        description: 'Investment Description'),
    Transaction(
        transactionID: '2',
        title: 'React Course',
        amount: 2000.6,
        transactionType: TransactionType.EXPENSE,
        categoryID: '12',
        accountID: 2,
        date: DateTime.now(),
        description: 'Bought Udemy Course with long descriptin'),
  ];

  testWidgets('load landing page with home page by default.', (WidgetTester tester) async {
    when(mockTransactionProvider.status).thenReturn(TransactionStatus.COMPLETED);
    mockTransactionProviderData.recentTransactions = _transactions;
    when(mockTransactionProviderData.recentTransactions).thenReturn(_transactions);
    when(mockTransactionProvider.data).thenReturn(mockTransactionProviderData);
    when(mockTransactionProvider.data.recentTransactions).thenReturn(_transactions);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionProvider>(create: (_) => mockTransactionProvider),
        ],
        child: MaterialApp(home: Landing()),
      ),
    );

    //find home screen as default screen
    final homeWidget = find.byKey(ValueKey('home'));
    expect(homeWidget, findsOneWidget);

    //find FAB
    final fabBtn = find.byKey(ValueKey('fab'));
    expect(fabBtn, findsOneWidget);

    //Find 5 menu buttons in bottom nav bar
    final bottomMenus = find.byType(IconButton);
    expect(bottomMenus, findsNWidgets(5));

    //click one of the menu
    await tester.tap(find.byKey(ValueKey('tran_menu')));
    await tester.pumpAndSettle();

    //test if respective screen renders
    final transWidget = find.byKey(ValueKey('trans'));
    expect(homeWidget, findsNothing);
    expect(transWidget, findsOneWidget);
  });
}
