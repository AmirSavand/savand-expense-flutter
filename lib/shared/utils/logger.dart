import 'package:flutter/foundation.dart';

/// A named logger for debug-mode logging.
///
/// Each logger instance is identified by a [name], which is included in every
/// log line to make it easy to trace which part of the app produced the output.
class Logger {
  const Logger(this._name);

  /// The name of this logger, shown as a prefix in every log line.
  final String _name;

  /// Logs [parts] joined by spaces, prefixed with [name], in debug mode only.
  ///
  /// Each part is converted to a string via [toString]. Numeric parts are
  /// handled explicitly for clarity.
  ///
  /// If [clean] is true (default), null and empty parts are silently filtered
  /// out of the output.
  ///
  /// If [clean] is false, null parts are shown as `NULL` and empty strings as
  /// `EMPTY`, useful when you explicitly want to see missing values.
  ///
  /// Does nothing in release mode.
  void log(Iterable<Object?> parts, {bool clean = true}) {
    if (!kDebugMode) {
      return;
    }
    final mapped = parts
        .map((part) {
      if (clean) {
        if (part == null) return null;
        final str = part.toString();
        return str.isEmpty ? null : str;
      } else {
        if (part == null) return 'NULL';
        final str = part.toString();
        return str.isEmpty ? 'EMPTY' : str;
      }
    })
        .where((part) => part != null);
    debugPrint('\x1B[36m[$_name]\x1B[0m ${mapped.join(' ')}');
  }
}
