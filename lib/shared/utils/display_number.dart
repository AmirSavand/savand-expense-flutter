import 'package:intl/intl.dart';

/// Formats [number] with thousands separators, preserving any decimal places.
/// Examples: 1234 → '1,234', 1234.2 → '1,234.2', 1234.56 → '1,234.56'
String displayNumber(num number) {
  return NumberFormat('#,##0.##', 'en_US').format(number);
}
