import 'package:dio/dio.dart';
import 'package:expense/shared/exceptions/app_exception.dart';

/// Parses a DRF error response into a human-readable message.
///
/// DRF error responses follow this structure:
/// - `detail`: a single error string (auth, permission errors)
/// - `non_field_errors`: a list of non-field-specific errors
/// - field errors: lists of strings keyed by field name
///
/// Falls back to a generic message if the response is not a recognized
/// DRF error structure (e.g. HTML, empty body, unexpected JSON).
String displayError(Object error) {
  if (error is AppException) {
    return error.message;
  }
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      // detail
      if (data['detail'] is String) {
        return data['detail'] as String;
      }
      // non_field_errors
      if (data['non_field_errors'] is List) {
        final errors = data['non_field_errors'] as List;
        if (errors.isNotEmpty) {
          return errors.first.toString();
        }
      }
      // first field error
      for (final value in data.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }
        if (value is String) {
          return value;
        }
      }
    }
  }
  return 'Something went wrong. Please try again.';
}
