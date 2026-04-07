import 'package:expense/core/service_locator.dart';
import 'package:expense/features/transaction/domain/models/transaction.dart';
import 'package:expense/features/transaction/domain/transaction_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a single transaction by [id].
/// Re-fetches fresh data every time it is watched.
final transactionRetrieveProvider = FutureProvider.autoDispose
    .family<Transaction, int>(retry: (_, _) => null, (ref, id) {
      return getIt<TransactionRepository>().retrieve(id);
    });
