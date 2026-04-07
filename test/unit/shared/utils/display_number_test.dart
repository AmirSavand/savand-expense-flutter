import 'package:expense/shared/utils/display_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('displayNumber', () {
    test('formats whole numbers with thousands separators', () {
      expect(displayNumber(1234), '1,234');
      expect(displayNumber(1000000), '1,000,000');
      expect(displayNumber(0), '0');
    });

    test('preserves decimal places', () {
      expect(displayNumber(1234.2), '1,234.2');
      expect(displayNumber(1234.56), '1,234.56');
    });

    test('drops trailing zeros', () {
      expect(displayNumber(1234.0), '1,234');
      expect(displayNumber(1234.50), '1,234.5');
    });

    test('formats small numbers without separators', () {
      expect(displayNumber(999), '999');
      expect(displayNumber(1), '1');
    });
  });
}
