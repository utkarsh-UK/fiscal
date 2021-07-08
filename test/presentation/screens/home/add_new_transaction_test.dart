import 'package:fiscal/core/utils/routing/navigation_service.dart';
import 'package:fiscal/presentation/screens/home/add_new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUp(() {
    GetIt.instance.registerSingleton<NavigationService>(NavigationService());
  });

  testWidgets('render add new transaction screen with form.', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: AddNewTransaction()),
    );

    //find title
    final title = find.byKey(ValueKey('title'));
    expect(title, findsOneWidget);

    //find form
    final form = find.byKey(ValueKey('form'));
    expect(form, findsOneWidget);
  });
}
