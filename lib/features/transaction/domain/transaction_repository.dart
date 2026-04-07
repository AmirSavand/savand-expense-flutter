import 'package:expense/features/transaction/domain/models/transaction.dart';
import 'package:expense/features/transaction/domain/models/transaction_form.dart';
import 'package:expense/shared/models/filters.dart';
import 'package:expense/shared/models/paginated.dart';

/// Abstract interface for transaction operations.
/// Implemented by [TransactionRepositoryImpl] in the data layer.
abstract class TransactionRepository {
  /// Returns a paginated list of transactions filtered by [profileId].
  /// Additional [filters] are appended as query parameters (e.g. wallet, kind).
  Future<Paginated<Transaction>> list(int profileId, {Filters? filters});

  /// Returns a single transaction by [id].
  Future<Transaction> retrieve(int id);

  /// Creates a new transaction from [data].
  Future<Transaction> create(TransactionForm data);

  /// Partially updates the transaction identified by [id] with [data].
  Future<Transaction> update(int id, TransactionForm data);

  /// Deletes the transaction identified by [id].
  Future<void> destroy(int id);
}
