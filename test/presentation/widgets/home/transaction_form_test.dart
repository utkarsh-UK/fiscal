import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/core/category.dart';
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

  DateTime createdAt = DateTime(2021, 05, 12);
  Category category = Category(categoryID: 1, name: 'category', icon: 'category', color: 'color', createdAt: createdAt);

  final categories = [category];

  testWidgets('render transaction form with correct fields.', (WidgetTester tester) async {
    when(mockTransactionProvider.status).thenReturn(TransactionStatus.INITIAL);
    when(mockTransactionProvider.getCategories(TransactionType.EXPENSE)).thenAnswer((_) async => categories);

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
    final inputLabels = find.byType(InputTitle, skipOffstage: false);
    expect(inputLabels, findsNWidgets(7));

    //find inputs
    final inputFields = find.byType(TextField, skipOffstage: false);
    expect(inputFields, findsNWidgets(5));

    //find type dropdown
    final typeDropdown = find.byKey(ValueKey('type_dropdown'));
    expect(typeDropdown, findsOneWidget);

    //find category dropdown
    final categoryDropdown = find.byKey(ValueKey('categories_dropdown'));
    expect(categoryDropdown, findsOneWidget);

    //find save btn
    final save = find.byKey(ValueKey('save'));
    expect(save, findsOneWidget);
  });

  testWidgets('should render progress indicator when state is LOADING.', (WidgetTester tester) async {
    when(mockTransactionProvider.status).thenReturn(TransactionStatus.LOADING);
    when(mockTransactionProvider.getCategories(TransactionType.EXPENSE)).thenAnswer((_) async => categories);

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
    final inputLabels = find.byType(InputTitle, skipOffstage: false);
    expect(inputLabels, findsNWidgets(7));

    //find inputs
    final inputFields = find.byType(TextField, skipOffstage: false);
    expect(inputFields, findsNWidgets(5));

    //find progress indicator
    final progress = find.byKey(ValueKey('progress'));
    final save = find.byKey(ValueKey('save'));
    expect(progress, findsOneWidget);
    expect(save, findsNothing);
  });

  // testWidgets('should scroll input fields on smaller screens.', (WidgetTester tester) async {
  //   //change screen size
  //   tester.binding.window.physicalSizeTestValue = Size(320, 420);
  //
  //   when(mockTransactionProvider.status).thenReturn(TransactionStatus.INITIAL);
  //
  //   await tester.pumpWidget(
  //     MediaQuery(
  //       data: MediaQueryData(),
  //       child: MultiProvider(
  //         providers: [
  //           ChangeNotifierProvider<TransactionProvider>(create: (_) => mockTransactionProvider),
  //         ],
  //         child: MaterialApp(
  //           home: Scaffold(
  //             body: TransactionForm(
  //               onSubmit: (String title, TransactionType type, double amount, String category, int account, DateTime date,
  //                   String description) {},
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   final descField = find.byKey(ValueKey('description'));
  //   final save = find.byKey(ValueKey('save'));
  //   await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
  //   await tester.pump();
  //
  //   expect(descField, findsOneWidget);
  //   expect(save, findsOneWidget);
  // });
}
