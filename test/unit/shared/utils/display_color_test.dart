import 'package:expense/shared/utils/display_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('displayColor', () {
    test('parses a standard hex color with hash prefix', () {
      expect(displayColor('#ff0000'), const Color(0xFFff0000));
      expect(displayColor('#000000'), const Color(0xFF000000));
      expect(displayColor('#ffffff'), const Color(0xFFffffff));
      expect(displayColor('#4caf50'), const Color(0xFF4caf50));
    });

    test('parses uppercase hex', () {
      expect(displayColor('#FF0000'), const Color(0xFFFF0000));
    });

    test('always returns full alpha regardless of input', () {
      expect(displayColor('#ff0000').a, 1);
      expect(displayColor('#000000').a, 1);
      expect(displayColor('#4caf50').a, 1);
    });
  });
}
