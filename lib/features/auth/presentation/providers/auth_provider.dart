import 'package:expense/core/service_locator.dart';
import 'package:expense/features/auth/domain/auth_repository.dart';
import 'package:expense/features/auth/domain/models/auth_user.dart';
import 'package:expense/shared/utils/display_error.dart';
import 'package:expense/shared/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global provider for [AuthNotifier] exposing [AuthState].
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);

// State

/// Base class for all possible auth states.
sealed class AuthState {}

/// Initial state before any auth action has been taken.
class AuthInitial extends AuthState {}

/// Emitted while an async auth operation is in progress.
class AuthLoading extends AuthState {}

/// Emitted when an OTP has been successfully sent to [email].
class AuthOtpSent extends AuthState {
  final String email;

  AuthOtpSent(this.email);
}

/// Emitted when the user has been successfully authenticated.
class AuthAuthenticated extends AuthState {
  final AuthUser user;

  AuthAuthenticated(this.user);
}

/// Emitted when an auth operation fails, with a human-readable [message].
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

// Notifier

/// Manages authentication state and orchestrates OTP login flow.
class AuthNotifier extends Notifier<AuthState> {
  // Logger instance
  final _logger = Logger('Auth');

  late final AuthRepository _repo;

  /// Initializes the repository from GetIt and sets the initial state.
  @override
  AuthState build() {
    _repo = getIt<AuthRepository>();
    return AuthInitial();
  }

  /// Create a new account and request OTP.
  Future<void> register({required String name, required String email}) async {
    state = AuthLoading();
    try {
      await _repo.register(email: email, name: name);
      state = AuthOtpSent(email);
    } catch (e) {
      state = AuthError(displayError(e));
    }
  }

  /// Requests an OTP for [email] and transitions to [AuthOtpSent] on success.
  Future<void> requestOtp(String email) async {
    state = AuthLoading();
    try {
      await _repo.requestOtp(email);
      state = AuthOtpSent(email);
    } catch (e) {
      state = AuthError(displayError(e));
    }
  }

  /// Verifies the OTP [code] for [email] and transitions to
  /// [AuthAuthenticated] on success.
  Future<void> verifyOtp(String email, String code) async {
    state = AuthLoading();
    try {
      final user = await _repo.verifyOtp(email: email, code: code);
      state = AuthAuthenticated(user);
      _logger.log(['Authenticated:', user.name]);
    } catch (e) {
      state = AuthError(displayError(e));
    }
  }

  /// Restores a previous session from secure storage if one exists.
  Future<void> restoreSession() async {
    final user = await _repo.getStoredUser();
    if (user == null) {
      state = AuthInitial();
    } else {
      state = AuthAuthenticated(user);
      _logger.log(['Session restored', user.name]);
    }
  }

  /// Clears all stored auth data and resets state to [AuthInitial].
  Future<void> logout() async {
    await _repo.logout();
    state = AuthInitial();
  }
}
