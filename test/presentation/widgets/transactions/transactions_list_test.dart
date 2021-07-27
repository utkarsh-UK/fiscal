import 'package:fiscal/core/utils/routing/navigation_service.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/home/transaction_item.dart';
import 'package:fiscal/presentation/widgets/transactions/transactions_list.dart';
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

  testWidgets('should render transactions list.', (WidgetTester tester) async {
    when(providerMock.getDailySummary()).thenAnswer((_) => Future.value());
    when(providerMock.status).thenReturn(TransactionStatus.COMPLETED);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionProvider>(create: (_) => providerMock),
        ],
        child: MaterialApp(
          home: Scaffold(body: TransactionsList()),
        ),
      ),
    );

    final items = find.byType(TransactionItem);
    expect(items, findsNWidgets(2));
  });
}
