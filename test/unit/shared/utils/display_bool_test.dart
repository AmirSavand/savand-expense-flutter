import 'package:expense/shared/utils/display_bool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('displayBool', () {
    test('returns Yes when true', () {
      expect(displayBool(true), 'Yes');
    });
    test('returns No when false', () {
      expect(displayBool(false), 'No');
    });
  });
}
