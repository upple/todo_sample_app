import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_sample_app/main.dart';

// TODO(upple): Implements database mock class.
void main() {
  group('Todo App Widget Tests', () {
    testWidgets('Test Todo List Screen', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: TodoApp()));

      expect(find.text('Todo List'), findsOneWidget);

      expect(find.byType(ListTile), findsNothing);

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('New Todo'), findsOneWidget);
    });

    testWidgets('Test Todo List Screen with Todo Item', (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('New Todo'), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(find.byType(Checkbox), findsOneWidget);
      expect((find.byType(Checkbox).evaluate().first.widget as Checkbox).value, true);
    });
  });
}
