import 'package:expense/shared/widgets/input/input_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('InputNumber', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('validates input and rejects invalid characters', (
      tester,
    ) async {
      await pumpApp(
        tester,
        InputNumber(label: 'Amount', controller: controller),
      );

      final textField = find.byType(TextFormField);

      // Helper to get current text value
      String getText() => controller.text;

      // Valid: numbers only
      await tester.enterText(textField, '123');
      expect(getText(), '123');

      // Valid: decimal point
      await tester.enterText(textField, '123.45');
      expect(getText(), '123.45');

      // Valid: starts with decimal
      await tester.enterText(textField, '.5');
      expect(getText(), '.5');

      // Valid: zero
      await tester.enterText(textField, '0');
      expect(getText(), '0');

      // Invalid: letters - should keep previous value
      await tester.enterText(textField, '123abc');
      expect(getText(), '0');

      // Invalid: multiple decimals
      await tester.enterText(textField, '1.2.3');
      expect(getText(), '0');

      // Invalid: special characters
      await tester.enterText(textField, '123\$#@');
      expect(getText(), '0');

      // Empty is allowed
      await tester.enterText(textField, '');
      expect(getText(), '');
    });

    testWidgets('shows custom validation error when provided', (tester) async {
      final formKey = GlobalKey<FormState>();

      await pumpApp(
        tester,
        Form(
          key: formKey,
          child: InputNumber(
            label: 'Amount',
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Amount is required';
              final number = double.tryParse(value);
              if (number == null) return 'Invalid number';
              if (number <= 0) return 'Amount must be greater than 0';
              return null;
            },
          ),
        ),
      );

      // Test: empty value
      await tester.enterText(find.byType(TextFormField), '');
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Amount is required'), findsOneWidget);

      // Test: zero value
      await tester.enterText(find.byType(TextFormField), '0');
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Amount must be greater than 0'), findsOneWidget);

      // Test: negative value
      await tester.enterText(find.byType(TextFormField), '-5');
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Amount must be greater than 0'), findsOneWidget);

      // Test: valid positive value - no error
      await tester.enterText(find.byType(TextFormField), '42.50');
      final isValid = formKey.currentState!.validate();
      await tester.pump();
      expect(isValid, isTrue);
      expect(find.text('Amount must be greater than 0'), findsNothing);
    });

    testWidgets('calls onFieldSubmitted and respects autofocus', (
      tester,
    ) async {
      String? submittedValue;

      await pumpApp(
        tester,
        InputNumber(
          label: 'Amount',
          controller: controller,
          onFieldSubmitted: (value) => submittedValue = value,
          autofocus: true,
        ),
      );

      // Verify autofocus (TextField should have focus)
      final focusNode = FocusScope.of(
        tester.element(find.byType(TextFormField)),
      );
      expect(focusNode.hasFocus, isTrue);

      // Enter text and submit
      await tester.enterText(find.byType(TextFormField), '99.99');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submittedValue, '99.99');
    });
  });
}
