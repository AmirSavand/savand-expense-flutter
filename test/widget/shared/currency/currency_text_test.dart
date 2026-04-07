import 'package:expense/shared/enums/expense_kind.dart';
import 'package:expense/shared/widgets/currency/currency_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('CurrencyText', () {
    testWidgets('renders formatted amount', (tester) async {
      await pumpApp(tester, CurrencyText(amount: 100, currency: 'USD'));
      expect(find.text('\$100.00'), findsOneWidget);
    });

    testWidgets('applies primary color for income', (tester) async {
      await pumpApp(
        tester,
        CurrencyText(amount: 100, currency: 'USD', kind: ExpenseKind.income),
      );
      final finder = find.text('\$100.00');
      final text = tester.widget<Text>(finder);
      final theme = Theme.of(tester.element(finder));
      expect(text.style?.color, theme.colorScheme.primary);
    });

    testWidgets('applies error color for expense', (tester) async {
      await pumpApp(
        tester,
        CurrencyText(amount: 100, currency: 'USD', kind: ExpenseKind.expense),
      );
      final finder = find.text('\$100.00');
      final text = tester.widget<Text>(finder);
      final theme = Theme.of(tester.element(finder));
      expect(text.style?.color, theme.colorScheme.error);
    });

    testWidgets('applies no color for transfer', (tester) async {
      await pumpApp(
        tester,
        CurrencyText(amount: 100, currency: 'USD', kind: ExpenseKind.transfer),
      );
      final text = tester.widget<Text>(find.text('\$100.00'));
      expect(text.style?.color, isNull);
    });

    testWidgets('applies no color when kind is null', (tester) async {
      await pumpApp(tester, CurrencyText(amount: 0, currency: 'USD'));
      final text = tester.widget<Text>(find.text('\$0.00'));
      expect(text.style?.color, isNull);
    });
  });
}
