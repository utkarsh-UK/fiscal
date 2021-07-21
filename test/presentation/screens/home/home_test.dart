import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../provider/provider.mocks.dart';
import '../../widgets/home/transaction_form_test.mocks.dart';

void main() {
  late MockTransactionProvider mockTransactionProvider;
  late MockTransactionProviderData mockTransactionProviderData;
  late ProviderMock providerMock;

  setUp(() {
    mockTransactionProvider = MockTransactionProvider();
    mockTransactionProviderData = MockTransactionProviderData();
    providerMock = ProviderMock();
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

  testWidgets('show summary and recent transactions when app is loaded.', (WidgetTester tester) async {
    when(providerMock.status).thenReturn(TransactionStatus.COMPLETED);
    when(providerMock.getRecentTransactions()).thenAnswer((_) => Future.value());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionProvider>(create: (_) => providerMock),
        ],
        child: MaterialApp(
            home: Home(
          onSeeAllClicked: (int index) {},
        )),
      ),
    );

    final summaryWidget = find.byKey(ValueKey('summary'));
    expect(summaryWidget, findsOneWidget);

    final seeAllBtn = find.byKey(ValueKey('see_all'));
    expect(seeAllBtn, findsOneWidget);

    final recentTransactions = find.byKey(ValueKey('recent_transactions'));
    expect(recentTransactions, findsOneWidget);
  });
}
