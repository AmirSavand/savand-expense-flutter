import 'package:flutter/services.dart';

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty or valid number pattern
    if (newValue.text.isEmpty) {
      return newValue;
    }
    // Check if the new text matches the pattern
    final isValid = RegExp(r'^\d*\.?\d*$').hasMatch(newValue.text);
    if (isValid) {
      return newValue;
    }
    // Otherwise, keep the old value (prevents invalid input)
    return oldValue;
  }
}
