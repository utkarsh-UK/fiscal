import 'package:fiscal/presentation/widgets/home/screen_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  testWidgets('render screen title and actions with proper formatting.', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ScreenTitle(
          title: 'title',
          actions: [Placeholder()],
        ),
      ),
    );

    //find title
    final title = find.byKey(ValueKey('screen_title'));
    expect(title, findsOneWidget);
    expect(find.text('Title'), findsOneWidget);

    //find actions
    final actions = find.byKey(ValueKey('actions'));
    expect(actions, findsOneWidget);
  });

  testWidgets('render only screen title when no actions are provided.', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ScreenTitle(title: 'title'),
      ),
    );

    //find title
    final title = find.byKey(ValueKey('screen_title'));
    expect(title, findsOneWidget);
    expect(find.text('Title'), findsOneWidget);

    //find actions
    final actions = find.byKey(ValueKey('actions'));
    expect(actions, findsNothing);
  });
}
