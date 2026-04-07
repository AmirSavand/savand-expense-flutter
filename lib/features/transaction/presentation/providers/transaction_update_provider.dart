// transaction_update_provider.dart
import 'package:expense/core/service_locator.dart';
import 'package:expense/features/transaction/domain/models/transaction.dart';
import 'package:expense/features/transaction/domain/models/transaction_form.dart';
import 'package:expense/features/transaction/domain/transaction_repository.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_retrieve_provider.dart';
import 'package:expense/shared/exceptions/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionUpdateProvider =
    AsyncNotifierProvider<TransactionUpdateNotifier, Transaction?>(
      () => TransactionUpdateNotifier(),
    );

class TransactionUpdateNotifier extends AsyncNotifier<Transaction?> {
  late final TransactionRepository _repo;

  @override
  Future<Transaction?> build() async {
    _repo = getIt<TransactionRepository>();
    return null;
  }

  /// Updates an existing transaction
  Future<Transaction?> updateTransaction(int id, TransactionForm data) async {
    reset();
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => _repo.update(id, data));
    state = result;
    if (result.hasValue) {
      ref.invalidate(transactionListProvider);
      ref.invalidate(transactionRetrieveProvider(id));
    }
    return result.value;
  }

  /// Resets state back to null
  void reset() => state = const AsyncData(null);

  /// Change to custom error state with given text
  void setError(String message) {
    state = AsyncError(AppException(message), StackTrace.current);
  }
}
