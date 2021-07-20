import 'package:fiscal/core/utils/routing/navigation_service.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/transactions/transaction.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/home/transaction_item.dart';
import 'package:fiscal/presentation/widgets/transactions/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../widgets/home/transaction_form_test.mocks.dart';

void main() {
  late MockTransactionProvider mockTransactionProvider;
  late MockTransactionProviderData mockTransactionProviderData;

  setUp(() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
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

  testWidgets('should render transactions list.', (WidgetTester tester) async {
    when(mockTransactionProvider.status).thenReturn(TransactionStatus.COMPLETED);
    mockTransactionProviderData.allTransactions = _transactions;
    when(mockTransactionProviderData.allTransactions).thenReturn(_transactions);
    when(mockTransactionProvider.data).thenReturn(mockTransactionProviderData);
    when(mockTransactionProvider.data.allTransactions).thenReturn(_transactions);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionProvider>(create: (_) => mockTransactionProvider),
        ],
        child: MaterialApp(
          home: TransactionsList(),
        ),
      ),
    );

    final items = find.byType(TransactionItem);
    expect(items, findsNWidgets(2));
  });
}
