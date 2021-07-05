import 'package:fiscal/presentation/widgets/home/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  testWidgets('render transaction form with correct fields.', (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: TransactionForm(onSubmit: () {}),
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
