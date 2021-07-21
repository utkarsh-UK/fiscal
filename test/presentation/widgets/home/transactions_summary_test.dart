import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/home/transactions_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../provider/provider.mocks.dart';
import 'transaction_form_test.mocks.dart';

void main() {
  late MockTransactionProvider mockTransactionProvider;
  late ProviderMock providerMock;

  setUp(() {
    mockTransactionProvider = MockTransactionProvider();
    providerMock = ProviderMock();
  });

  testWidgets('render transaction summary widget with correct values.', (WidgetTester tester) async {
    when(mockTransactionProvider.status).thenReturn(TransactionStatus.SUMMARY_LOADED);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionProvider>(create: (_) => providerMock),
        ],
        child: MaterialApp(
          home: TransactionsSummary(),
        ),
      ),
    );

    //find total_balance
    final totalBalance = find.byKey(ValueKey("total_balance"));
    expect(totalBalance, findsOneWidget);

    //find income value
    final income = find.byKey(ValueKey('income'));
    expect(income, findsOneWidget);
    expect(find.text('3300.00'), findsOneWidget);

    //find expense value
    final expense = find.byKey(ValueKey('expense'));
    expect(expense, findsOneWidget);
    expect(find.text('1500.00'), findsOneWidget);
  });
}
