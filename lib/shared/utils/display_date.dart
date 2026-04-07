import 'package:intl/intl.dart';

/// Formats [date] as a human-readable date string.
/// Example: 21 Aug 2025
String displayDate(DateTime date) {
  return DateFormat('dd MMM yyyy').format(date);
}

/// Formats [date] as a human-readable time string.
/// Example: 02:34 AM
String displayTime(DateTime date) {
  return DateFormat('hh:mm a').format(date);
}

/// Formats [date] as a human-readable date and time string.
/// Example: 15 Mar 2025 at 07:25 AM
String displayDateTime(DateTime date) {
  return DateFormat("dd MMM yyyy 'at' hh:mm a").format(date);
}
