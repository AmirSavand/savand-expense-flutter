import 'package:expense/shared/widgets/input/input_bool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('InputBool', () {
    testWidgets('renders label and switch', (tester) async {
      await pumpApp(
        tester,
        InputBool(label: 'Archived', selected: false, onSelect: (_) {}),
      );

      expect(find.text('Archived'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('renders with correct initial value', (tester) async {
      await pumpApp(
        tester,
        InputBool(label: 'Archived', selected: true, onSelect: (_) {}),
      );

      final switcher = tester.widget<Switch>(find.byType(Switch));
      expect(switcher.value, isTrue);
    });

    testWidgets('calls onSelect with new value when toggled', (tester) async {
      bool? selected;

      await pumpApp(
        tester,
        InputBool(
          label: 'Archived',
          selected: false,
          onSelect: (value) => selected = value,
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(selected, isTrue);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(selected, isFalse);
    });
  });
}
