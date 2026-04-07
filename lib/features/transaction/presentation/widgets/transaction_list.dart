import 'package:expense/features/profile/domain/models/profile.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/transaction/domain/models/transaction.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:expense/features/transaction/presentation/widgets/transaction_tile.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:expense/shared/models/filters.dart';
import 'package:expense/shared/utils/display_currency.dart';
import 'package:expense/shared/utils/display_error.dart';
import 'package:expense/shared/utils/display_number.dart';
import 'package:expense/shared/widgets/app_guard.dart';
import 'package:expense/shared/widgets/app_tile.dart';
import 'package:expense/shared/widgets/app_tile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionList extends ConsumerWidget {
  final Filters? filters;
  final bool showHeader;
  final bool useProvider;
  final List<Transaction>? transactions;

  const TransactionList({
    super.key,
    this.filters,
    this.showHeader = true,
    this.useProvider = true,
    this.transactions,
  });

  /// Returns a map of transactions grouped by their date.
  Map<String, List<Transaction>> groupByDate(List<Transaction> transactions) {
    final map = <String, List<Transaction>>{};
    for (final item in transactions) {
      final key = DateFormat('yyyy-MM-dd').format(item.time);
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }

  Widget _buildList(
    BuildContext context,
    List<Transaction> transactions,
    Profile profile,
  ) {
    // Handle no transactions
    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text('There are no transactions yet.'),
      );
    }
    // Map transactions by date
    final grouped = groupByDate(transactions);
    // Get list of keys (dates) from map
    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final dateParsed = DateTime.parse(date);
        final dateFormat = DateFormat('MMM yyyy').format(dateParsed);
        final dateFormatDay = DateFormat('d').format(dateParsed);
        final dateDay = DateFormat('EEEE').format(dateParsed);
        final transactionsForDate = grouped[date] ?? [];
        double dateTotal = 0;
        for (var transaction in transactionsForDate) {
          if (transaction.kind == ExpenseKind.expense) {
            dateTotal -= transaction.amount;
          } else if (transaction.kind == ExpenseKind.income) {
            dateTotal += transaction.amount;
          }
        }
        return Column(
          children: [
            if (showHeader)
              AppTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Text(dateFormatDay),
                ),
                subtitle: dateFormat,
                title: dateDay,
                trailing: [
                  displayCurrency(dateTotal, profile.currency),
                  '${displayNumber(transactionsForDate.length)} Transactions',
                ].join('\n'),
              ),
            if (showHeader)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Divider(height: 1),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactionsForDate.length,
              itemBuilder: (context, index) {
                return TransactionTile(transactionsForDate[index]);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current profile
    final profile = ref.watch(currentProfileProvider);
    if (profile == null) {
      return AppGuard();
    }
    // If not using provider, use the provided transactions list
    if (!useProvider) {
      // If transactions is null, show shimmer
      if (transactions == null) {
        return AppTileShimmer.list(25);
      }
      return _buildList(context, transactions!, profile);
    }
    // Use provider
    final state = ref.watch(transactionListProvider(filters));
    return state.when(
      // Loading
      loading: () => AppTileShimmer.list(25),
      // Error
      error: (e, _) => Center(child: Text(displayError(e))),
      // Data
      data: (paginated) => _buildList(context, paginated.results, profile),
    );
  }
}
