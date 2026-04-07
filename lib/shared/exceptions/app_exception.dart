/// A user-facing application exception with a human-readable [message].
/// Use this for expected errors that should be shown directly to the user.
class AppException implements Exception {
  final String message;

  const AppException(this.message);
}
