import 'package:expense/shared/widgets/input/input_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('InputColor', () {
    testWidgets('renders color buttons and handles selection', (tester) async {
      String? selectedColor;

      await pumpApp(
        tester,
        InputColor(
          selected: '#4caf50',
          onSelect: (color) => selectedColor = color,
        ),
      );

      // Find all color buttons using the ValueKey pattern
      final colorButtons = find.byType(IconButton);
      expect(colorButtons, findsWidgets);
      expect(colorButtons.evaluate().length, greaterThan(5));

      // Verify the selected color button has isSelected = true
      final greenButton = find.byKey(const ValueKey('#4caf50'));
      final greenButtonWidget = tester.widget<IconButton>(greenButton);
      expect(greenButtonWidget.isSelected, isTrue);

      // Tap a different color (red - first in the default list)
      await tester.tap(find.byKey(const ValueKey('#f44336')));
      await tester.pump();

      // Verify onSelect was called with the tapped color
      expect(selectedColor, '#f44336');

      // Verify selection changed
      final redButtonWidget = tester.widget<IconButton>(
        find.byKey(const ValueKey('#f44336')),
      );
      expect(redButtonWidget.isSelected, isTrue);

      // Green should no longer be selected
      final greenButtonAfter = tester.widget<IconButton>(
        find.byKey(const ValueKey('#4caf50')),
      );
      expect(greenButtonAfter.isSelected, isFalse);
    });
  });
}
