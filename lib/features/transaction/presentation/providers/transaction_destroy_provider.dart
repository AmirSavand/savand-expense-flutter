import 'package:expense/core/service_locator.dart';
import 'package:expense/features/transaction/domain/transaction_repository.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_retrieve_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionDestroyProvider =
    AsyncNotifierProvider<TransactionDestroyNotifier, bool?>(
      () => TransactionDestroyNotifier(),
    );

/// Manages the destroy operation for a transaction.
/// State holds true on success, null initially.
class TransactionDestroyNotifier extends AsyncNotifier<bool?> {
  late final TransactionRepository _repo;

  @override
  Future<bool?> build() async {
    _repo = getIt<TransactionRepository>();
    return null;
  }

  /// Deletes the transaction identified by [id].
  /// On success, state becomes [AsyncData] with true.
  /// On failure, state becomes [AsyncError].
  Future<void> destroy(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.destroy(id);
      return true;
    });
    if (state is AsyncData) {
      ref.invalidate(transactionListProvider);
      ref.invalidate(transactionRetrieveProvider(id));
    }
  }

  /// Resets state back to null so the notifier is ready for the next call.
  void reset() => state = const AsyncData(null);
}
