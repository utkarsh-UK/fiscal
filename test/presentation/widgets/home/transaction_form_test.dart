import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/home/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'transaction_form_test.mocks.dart';

@GenerateMocks([TransactionProvider, TransactionProviderData])
void main() {
  late MockTransactionProvider mockTransactionProvider;

  setUp(() {
    mockTransactionProvider = MockTransactionProvider();
    when(mockTransactionProvider.hasListeners).thenReturn(false);
  });

  testWidgets('render transaction form with correct fields.', (WidgetTester tester) async {
    when(mockTransactionProvider.status).thenReturn(TransactionStatus.INITIAL);

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<TransactionProvider>(create: (_) => mockTransactionProvider),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TransactionForm(
                  onSubmit: (String title, TransactionType type, double amount, String category, int account, DateTime date,
                      String description) {}),
            ),
          ),
        ),
      ),
    );

    //find input labels
    final inputLabels = find.byType(InputTitle);
    expect(inputLabels, findsNWidgets(7));

    //find inputs
    final inputs = find.byType(TextField);
    expect(inputs, findsNWidgets(6));

    //find save btn
    final save = find.byKey(ValueKey('save'));
    expect(save, findsOneWidget);
  });

  testWidgets('render progress indicator when adding transaction is not completed.', (WidgetTester tester) async {
    when(mockTransactionProvider.status).thenReturn(TransactionStatus.LOADING);

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<TransactionProvider>(create: (_) => mockTransactionProvider),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TransactionForm(
                onSubmit: (String title, TransactionType type, double amount, String category, int account, DateTime date,
                    String description) {},
              ),
            ),
          ),
        ),
      ),
    );

    //find input labels
    final inputLabels = find.byType(InputTitle);
    expect(inputLabels, findsNWidgets(7));

    //find inputs
    final inputs = find.byType(TextField);
    expect(inputs, findsNWidgets(6));

    //find progress indicator
    final progress = find.byKey(ValueKey('progress'));
    expect(progress, findsOneWidget);

    //find save btn
    final save = find.byKey(ValueKey('save'));
    expect(save, findsNothing);
  });
}
