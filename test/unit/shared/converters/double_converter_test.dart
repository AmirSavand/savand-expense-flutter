import 'package:expense/shared/converters/double_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoubleConverter', () {
    const converter = DoubleConverter();

    group('fromJson', () {
      test('parses valid numeric values', () {
        expect(converter.fromJson('123.45'), 123.45);
        expect(converter.fromJson('0'), 0.0);
        expect(converter.fromJson(123.45), 123.45);
      });

      test('returns 0 for null or invalid input', () {
        expect(converter.fromJson(null), 0.0);
        expect(converter.fromJson('abc'), 0.0);
        expect(converter.fromJson(''), 0.0);
      });
    });

    group('toJson', () {
      test('converts double to string', () {
        expect(converter.toJson(123.45), '123.45');
        expect(converter.toJson(0.0), '0.0');
      });
    });
  });
}
