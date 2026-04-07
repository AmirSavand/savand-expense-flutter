import 'package:expense/shared/widgets/dialog/dialog_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('showDialogConfirm', () {
    testWidgets('shows title and content', (tester) async {
      await pumpApp(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialogConfirm(
              context: context,
              title: 'Delete Item',
              content: ['Are you sure?', 'This cannot be undone.'],
            ),
            child: const Text('Open'),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Item'), findsOneWidget);
      expect(
        find.text('Are you sure?\nThis cannot be undone.'),
        findsOneWidget,
      );
    });

    testWidgets('calls onConfirm and returns true when Yes is tapped', (
      tester,
    ) async {
      bool confirmed = false;

      await pumpApp(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialogConfirm(
              context: context,
              title: 'Delete Item',
              content: ['Are you sure?'],
              onConfirm: () => confirmed = true,
            ),
            child: const Text('Open'),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
    });

    testWidgets('does not call onConfirm when No is tapped', (tester) async {
      bool confirmed = false;

      await pumpApp(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showDialogConfirm(
              context: context,
              title: 'Delete Item',
              content: ['Are you sure?'],
              onConfirm: () => confirmed = true,
            ),
            child: const Text('Open'),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(confirmed, isFalse);
    });
  });
}
