import 'package:expense/features/auth/domain/models/auth_user.dart';

/// Abstract interface for authentication operations.
/// Implemented by [AuthRepositoryImpl] in the data layer.
abstract class AuthRepository {
  /// Sign up with the given name and email and requests OTP.
  Future<void> register({required String email, required String name});

  /// Requests an OTP code to be sent to the given [email].
  Future<void> requestOtp(String email);

  /// Verifies the OTP [code] for the given [email].
  /// Returns the authenticated [AuthUser] on success.
  Future<AuthUser> verifyOtp({required String email, required String code});

  /// Returns the currently stored [AuthUser], or null if not authenticated.
  Future<AuthUser?> getStoredUser();

  /// Clears all stored auth data and ends the current session.
  Future<void> logout();
}
