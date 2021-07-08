import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/home/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';

import 'transaction_form_test.mocks.dart';

@GenerateMocks([TransactionProvider])
void main() {
  setUp(() {});

  testWidgets('render transaction form with correct fields.', (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: Scaffold(
            body: TransactionForm(onSubmit: () {}),
          ),
        ),
      ),
    );

    //find input labels
    final inputLabels = find.byType(InputTitle);
    expect(inputLabels, findsNWidgets(7));

    //find inputs
    final inputs = find.byType(TextField);
    expect(inputs, findsNWidgets(7));

    //find save btn
    final save = find.byKey(ValueKey('save'));
    expect(save, findsOneWidget);
  });
}
