import 'package:fiscal/core/utils/routing/navigation_service.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/core/category.dart';
import 'package:fiscal/domain/enitities/entities.dart';
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
    DateTime createdAt = DateTime(2021, 05, 12);
    Category category = Category(categoryID: 1, name: 'category', icon: 'category', color: 'color', createdAt: createdAt);
    Account account = Account(
      accountID: 1,
      accountNumber: 12345,
      bankName: 'bank',
      logo: 'logo',
      balance: 10000,
      createdAt: createdAt,
    );

    final categories = [category];
    final accounts = [account];

    when(mockTransactionProvider.status).thenReturn(TransactionStatus.INITIAL);
    when(mockTransactionProvider.getCategories(TransactionType.EXPENSE)).thenAnswer((_) async => categories);
    when(mockTransactionProvider.getAccounts()).thenAnswer((_) async => accounts);

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
