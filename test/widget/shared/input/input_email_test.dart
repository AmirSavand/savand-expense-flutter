import 'package:expense/shared/widgets/input/input_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('InputEmail', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders with label', (tester) async {
      await pumpApp(tester, InputEmail(controller: controller));

      expect(find.text('Email'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('shows error for invalid email', (tester) async {
      await pumpApp(tester, InputEmail(controller: controller));

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'not-an-email');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Trigger validation by finding the form (InputEmail doesn't have its
      // own Form, so we need to wrap it or use the form field's validator
      // directly). Alternative approach: Use Form with autoValidate or call
      // validate manually.

      // Let's wrap in a Form with a key to trigger validation
      final formKey = GlobalKey<FormState>();
      await pumpApp(
        tester,
        Form(
          key: formKey,
          child: InputEmail(controller: controller),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'invalid');
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Please enter a valid email.'), findsOneWidget);
    });

    testWidgets('shows error for empty email', (tester) async {
      final formKey = GlobalKey<FormState>();

      await pumpApp(
        tester,
        Form(
          key: formKey,
          child: InputEmail(controller: controller),
        ),
      );

      // Leave empty and validate
      await tester.enterText(find.byType(TextFormField), '');
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Please enter your email.'), findsOneWidget);
    });

    testWidgets('accepts valid email', (tester) async {
      final formKey = GlobalKey<FormState>();

      await pumpApp(
        tester,
        Form(
          key: formKey,
          child: InputEmail(controller: controller),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'user@example.com');
      final isValid = formKey.currentState!.validate();
      await tester.pump();

      expect(isValid, isTrue);
      expect(find.text('Please enter a valid email.'), findsNothing);
    });

    testWidgets('calls onFieldSubmitted when provided', (tester) async {
      String? submittedValue;

      await pumpApp(
        tester,
        InputEmail(
          controller: controller,
          onFieldSubmitted: (value) => submittedValue = value,
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submittedValue, 'test@example.com');
    });
  });
}
