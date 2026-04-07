import 'package:dio/dio.dart';
import 'package:expense/core/service_locator.dart';
import 'package:expense/features/wallet/domain/models/wallet.dart';
import 'package:expense/features/wallet/domain/models/wallet_form.dart';
import 'package:expense/features/wallet/domain/wallet_repository.dart';

/// Concrete implementation of [WalletRepository] using Dio.
class WalletRepositoryImpl implements WalletRepository {
  Dio get _dio => getIt<Dio>();

  @override
  Future<List<Wallet>> list(int profileId) async {
    final response = await _dio.get(
      'expense/api/wallet/',
      queryParameters: {'profile': profileId},
    );
    final data = response.data as List<dynamic>;
    return data.map((e) => Wallet.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Wallet> create(WalletForm payload) async {
    final response = await _dio.post(
      'expense/api/wallet/',
      data: payload.toJson(),
    );
    return Wallet.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Wallet> update(int id, WalletForm payload) async {
    final response = await _dio.patch(
      'expense/api/wallet/$id/',
      data: payload.toJson(),
    );
    return Wallet.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Wallet> retrieve(int id) async {
    final response = await _dio.patch('expense/api/wallet/$id/');
    return Wallet.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> destroy(int id) async {
    await _dio.delete('expense/api/wallet/$id/');
  }
}
