import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:expense/core/service_locator.dart';
import 'package:expense/core/storage_service.dart';
import 'package:expense/features/auth/domain/auth_repository.dart';
import 'package:expense/features/auth/domain/models/auth_user.dart';

/// App name required for the API.
const _appId = 'expense';

/// Concrete implementation of [AuthRepository] using Dio and secure storage.
class AuthRepositoryImpl implements AuthRepository {
  /// Getter for Dio singleton
  Dio get _dio => getIt<Dio>();

  /// Getter for StorageService singleton
  StorageService get _storage => getIt<StorageService>();

  @override
  Future<void> register({required String email, required String name}) async {
    await _dio.post('core/user/', data: {'email': email, 'name': name});
    await requestOtp(email);
  }

  @override
  Future<void> requestOtp(String email) async {
    await _dio.post(
      'core/auth/otp-request/',
      data: {'email': email, 'app': _appId},
    );
  }

  @override
  Future<AuthUser> verifyOtp({
    required String email,
    required String code,
  }) async {
    final response = await _dio.post(
      'core/auth/otp-verify/',
      data: {'email': email, 'code': code},
    );

    final data = response.data as Map<String, dynamic>;
    final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);

    await _storage.access.write(data['access']);
    await _storage.refresh.write(data['refresh']);
    await _storage.user.write(jsonEncode(user.toJson()));

    return user;
  }

  @override
  Future<AuthUser?> getStoredUser() async {
    final raw = await _storage.user.read();
    if (raw == null) {
      return null;
    }
    return AuthUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await _storage.flush();
  }
}
