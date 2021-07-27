import 'package:fiscal/core/utils/routing/navigation_service.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/core/category.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/screens/home/update_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../widgets/home/transaction_form_test.mocks.dart';

void main() {
  late MockTransactionProvider mockTransactionProvider;

  setUp(() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
    mockTransactionProvider = MockTransactionProvider();
  });

  testWidgets('render update transaction screen with form.', (WidgetTester tester) async {
    DateTime createdAt = DateTime(2021, 05, 12);
    Category category = Category(categoryID: 1, name: 'category', icon: 'category', color: 'color', createdAt: createdAt);

    DateTime transactionDate = DateTime(2021, 06, 26);
    Transaction transaction = Transaction(
      transactionID: '1',
      title: 'title',
      amount: 100.983223,
      transactionType: TransactionType.INCOME,
      categoryID: 1,
      accountID: 1,
      date: transactionDate,
      description: 'desc',
    );

    final categories = [category];

    when(mockTransactionProvider.status).thenReturn(TransactionStatus.INITIAL);
    when(mockTransactionProvider.getCategories(TransactionType.INCOME)).thenAnswer((_) async => categories);

    await tester.pumpWidget(
      MaterialApp(
          home: MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionProvider>(create: (_) => mockTransactionProvider),
        ],
        child: UpdateTransaction(transaction: transaction),
      )),
    );

    //find title
    final title = find.byKey(ValueKey('update_title'));
    expect(title, findsOneWidget);

    //find form
    final form = find.byKey(ValueKey('update_form'));
    expect(form, findsOneWidget);
  });
}
