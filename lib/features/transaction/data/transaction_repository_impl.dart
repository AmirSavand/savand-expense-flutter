import 'package:dio/dio.dart';
import 'package:expense/core/service_locator.dart';
import 'package:expense/features/transaction/domain/models/transaction.dart';
import 'package:expense/features/transaction/domain/models/transaction_form.dart';
import 'package:expense/features/transaction/domain/transaction_repository.dart';
import 'package:expense/shared/models/paginated.dart';

/// Concrete implementation of [TransactionRepository] using Dio.
class TransactionRepositoryImpl implements TransactionRepository {
  /// Resolves the shared [Dio] instance from the service locator.
  Dio get _dio => getIt<Dio>();

  /// Fetches a paginated list of transactions filtered by [profileId].
  /// Optional [filters] are merged into the query parameters.
  @override
  Future<Paginated<Transaction>> list(
    int profileId, {
    Map<String, dynamic>? filters,
  }) async {
    final response = await _dio.get(
      'expense/api/transaction/',
      queryParameters: {'wallet__profile': profileId, ...?filters},
    );
    return Paginated.fromJson(
      response.data as Map<String, dynamic>,
      (e) => Transaction.fromJson(e as Map<String, dynamic>),
    );
  }

  /// Fetches a single transaction by [id].
  @override
  Future<Transaction> retrieve(int id) async {
    final response = await _dio.get('expense/api/transaction/$id/');
    return Transaction.fromJson(response.data as Map<String, dynamic>);
  }

  /// Creates a new transaction from [data].
  @override
  Future<Transaction> create(TransactionForm data) async {
    final response = await _dio.post(
      'expense/api/transaction/',
      data: data.toJson(),
    );
    return Transaction.fromJson(response.data as Map<String, dynamic>);
  }

  /// Partially updates the transaction identified by [id] with [data].
  @override
  Future<Transaction> update(int id, TransactionForm data) async {
    final response = await _dio.patch(
      'expense/api/transaction/$id/',
      data: data.toJson(),
    );
    return Transaction.fromJson(response.data as Map<String, dynamic>);
  }

  /// Deletes the transaction identified by [id].
  @override
  Future<void> destroy(int id) async {
    await _dio.delete('expense/api/transaction/$id/');
  }
}
