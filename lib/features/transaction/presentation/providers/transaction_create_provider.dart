import 'package:expense/core/service_locator.dart';
import 'package:expense/features/transaction/domain/models/transaction.dart';
import 'package:expense/features/transaction/domain/models/transaction_form.dart';
import 'package:expense/features/transaction/domain/transaction_repository.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:expense/shared/exceptions/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionCreateProvider =
    AsyncNotifierProvider<TransactionCreateNotifier, Transaction?>(
      () => TransactionCreateNotifier(),
    );

/// Manages the create operation for a transaction.
/// State holds the created [Transaction] on success, null initially.
class TransactionCreateNotifier extends AsyncNotifier<Transaction?> {
  late final TransactionRepository _repo;

  @override
  Future<Transaction?> build() async {
    _repo = getIt<TransactionRepository>();
    return null;
  }

  /// Creates a new transaction from [data].
  /// On success, state becomes [AsyncData] holding the created [Transaction].
  /// On failure, state becomes [AsyncError].
  Future<Transaction?> create(TransactionForm data) async {
    // Clear previous state before starting
    reset();
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => _repo.create(data));
    state = result;
    // Invalidate list provider after successful update
    if (result.hasValue) {
      ref.invalidate(transactionListProvider);
    }
    // Return the created transaction if successful
    return result.value;
  }

  /// Resets state back to null so the notifier is ready for the next call.
  void reset() => state = const AsyncData(null);

  /// Change to custom error state with given text
  void setError(String message) {
    state = AsyncError(AppException(message), StackTrace.current);
  }
}
