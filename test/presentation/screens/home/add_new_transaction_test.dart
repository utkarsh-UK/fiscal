import 'package:fiscal/core/utils/routing/navigation_service.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/screens/home/add_new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import '../../widgets/home/transaction_form_test.mocks.dart';

void main() {
  late MockTransactionProvider mockTransactionProvider;

  setUp(() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    mockTransactionProvider = MockTransactionProvider();
  });

  testWidgets('render add new transaction screen with form.', (WidgetTester tester) async {
    when(mockTransactionProvider.status).thenReturn(TransactionStatus.INITIAL);

    await tester.pumpWidget(
      MaterialApp(
          home: MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionProvider>(create: (_) => mockTransactionProvider),
        ],
        child: AddNewTransaction(),
      )),
    );

    //find title
    final title = find.byKey(ValueKey('title'));
    expect(title, findsOneWidget);

    //find form
    final form = find.byKey(ValueKey('form'));
    expect(form, findsOneWidget);
  });
}
