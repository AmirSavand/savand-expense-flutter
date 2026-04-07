import 'package:expense/shared/formatters/number_text_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumberTextInputFormatter', () {
    final formatter = NumberTextInputFormatter();

    TextEditingValue format(String oldText, String newText) {
      return formatter.formatEditUpdate(
        TextEditingValue(text: oldText),
        TextEditingValue(text: newText),
      );
    }

    test('allows valid numeric input', () {
      expect(format('', '123').text, '123');
      expect(format('123', '123.45').text, '123.45');
      expect(format('', '0.5').text, '0.5');
    });

    test('allows empty input', () {
      expect(format('123', '').text, '');
    });

    test('rejects non-numeric input', () {
      expect(format('123', '123a').text, '123');
      expect(format('', 'abc').text, '');
    });

    test('rejects multiple decimal points', () {
      expect(format('1.2', '1.2.3').text, '1.2');
    });
  });
}
