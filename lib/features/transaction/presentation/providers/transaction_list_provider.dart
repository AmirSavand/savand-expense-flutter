import 'package:expense/core/service_locator.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/transaction/domain/models/transaction.dart';
import 'package:expense/features/transaction/domain/transaction_repository.dart';
import 'package:expense/shared/models/filters.dart';
import 'package:expense/shared/models/paginated.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a paginated list of transactions for the current profile.
final transactionListProvider = FutureProvider.autoDispose
    .family<Paginated<Transaction>, Filters?>((ref, filters) {
      final profileId = ref.read(currentProfileProvider)!.id;
      return getIt<TransactionRepository>().list(profileId, filters: filters);
    }, retry: (_, _) => null);
