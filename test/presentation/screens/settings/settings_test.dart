import 'package:fiscal/core/utils/routing/navigation_service.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/screens/screens.dart';
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

  DateTime createdAt = DateTime(2021, 05, 12);
  Category category = Category(
    categoryID: 1,
    name: 'category',
    icon: 'category',
    color: 'color',
    createdAt: createdAt,
    transactionType: TransactionType.INCOME,
  );
  final categories = [category];

  testWidgets('should render all settings list.', (WidgetTester tester) async {
    when(mockTransactionProvider.status).thenReturn(TransactionStatus.COMPLETED);
    when(mockTransactionProvider.getCategories(TransactionType.INCOME)).thenAnswer((_) async => categories);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionProvider>(create: (_) => providerMock),
        ],
        child: MaterialApp(
          home: Settings(),
        ),
      ),
    );

    final screenTitle = find.byKey(ValueKey('settings_title'));
    expect(screenTitle, findsOneWidget);

    final allTransactions = find.byKey(ValueKey('settings_list'));
    expect(allTransactions, findsOneWidget);
  });
}