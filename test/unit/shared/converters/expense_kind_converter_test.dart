import 'package:expense/shared/converters/expense_kind_converter.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpenseKindConverter', () {
    const converter = ExpenseKindConverter();

    group('fromJson', () {
      test('maps int to correct ExpenseKind', () {
        expect(converter.fromJson(0), ExpenseKind.income);
        expect(converter.fromJson(1), ExpenseKind.expense);
        expect(converter.fromJson(2), ExpenseKind.transfer);
      });
    });

    group('toJson', () {
      test('maps ExpenseKind to correct int', () {
        expect(converter.toJson(ExpenseKind.income), 0);
        expect(converter.toJson(ExpenseKind.expense), 1);
        expect(converter.toJson(ExpenseKind.transfer), 2);
      });
    });

    test('fromJson and toJson are inverse of each other', () {
      for (final kind in ExpenseKind.values) {
        expect(converter.fromJson(converter.toJson(kind)), kind);
      }
    });
  });
}
