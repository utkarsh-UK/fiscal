import 'package:fiscal/presentation/screens/home/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('load landing page with home page by default.',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Landing()));

    //find home screen as default screen
    final homeWidget = find.byKey(ValueKey('home'));
    expect(homeWidget, findsOneWidget);

    //find FAB
    final fabBtn = find.byKey(ValueKey('fab'));
    expect(fabBtn, findsOneWidget);

    //Find 5 menu buttons in bottom nav bar
    final bottomMenus = find.byType(IconButton);
    expect(bottomMenus, findsNWidgets(5));

    //click one of the menu
    await tester.tap(find.byKey(ValueKey('tran_menu')));
    await tester.pumpAndSettle();

    //test if respective screen renders
    final transWidget = find.byKey(ValueKey('trans'));
    expect(homeWidget, findsNothing);
    expect(transWidget, findsOneWidget);
  });
}
