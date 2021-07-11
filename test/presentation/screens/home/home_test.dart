import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../widgets/home/transaction_form_test.mocks.dart';

void main() {
  late MockTransactionProvider mockTransactionProvider;

  setUp(() {
    mockTransactionProvider = MockTransactionProvider();
    when(mockTransactionProvider.hasListeners).thenReturn(false);
  });

  testWidgets('show summary and recent transactions when app is loaded.', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionProvider>(create: (_) => mockTransactionProvider),
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
