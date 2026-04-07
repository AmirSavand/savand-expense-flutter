import 'package:expense/shared/enums/expense_kind.dart';
import 'package:expense/shared/utils/display_currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('displayCurrency', () {
    test('formats positive amount with currency', () {
      expect(displayCurrency(100, 'USD'), '\$100.00');
      expect(displayCurrency(1234.56, 'USD'), '\$1,234.56');
      expect(displayCurrency(0, 'USD'), '\$0.00');
    });

    test('formats with different currencies', () {
      expect(displayCurrency(100, 'EUR'), '€100.00');
      expect(displayCurrency(100, 'GBP'), '£100.00');
    });

    test('negates amount when kind is expense', () {
      expect(
        displayCurrency(100, 'USD', kind: ExpenseKind.expense),
        '-\$100.00',
      );
    });

    test('does not negate amount when kind is income', () {
      expect(displayCurrency(100, 'USD', kind: ExpenseKind.income), '\$100.00');
    });

    test('does not negate amount when kind is transfer', () {
      expect(
        displayCurrency(100, 'USD', kind: ExpenseKind.transfer),
        '\$100.00',
      );
    });

    test('does not negate amount when kind is null', () {
      expect(displayCurrency(100, 'USD'), '\$100.00');
    });
  });
}
