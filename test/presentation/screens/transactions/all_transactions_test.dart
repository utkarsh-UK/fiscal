import 'package:fiscal/core/utils/routing/navigation_service.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/screens/transactions/all_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../provider/provider.mocks.dart';
import '../../widgets/home/transaction_form_test.mocks.dart';

void main() {
  late MockTransactionProvider mockTransactionProvider;
  // late MockTransactionProviderData mockTransactionProviderData;
  late ProviderMock providerMock;

  setUp(() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    mockTransactionProvider = MockTransactionProvider();
    // mockTransactionProviderData = MockTransactionProviderData();
    providerMock = ProviderMock();
    when(mockTransactionProvider.hasListeners).thenReturn(false);
  });

  testWidgets('should render all transactions list.', (WidgetTester tester) async {
    when(mockTransactionProvider.status).thenReturn(TransactionStatus.COMPLETED);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionProvider>(create: (_) => providerMock),
        ],
        child: MaterialApp(
          home: AllTransactions(),
        ),
      ),
    );

    final screenTitle = find.byKey(ValueKey('title_all_transactions'));
    expect(screenTitle, findsOneWidget);

    final allTransactions = find.byKey(ValueKey('transaction_list'));
    expect(allTransactions, findsOneWidget);
  });
}
