import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:expense/features/transaction/presentation/widgets/transaction_list.dart';
import 'package:expense/features/transaction/presentation/widgets/transaction_sheet.dart';
import 'package:expense/shared/constants/app_padding.dart';
import 'package:expense/shared/widgets/app_app_bar.dart';
import 'package:expense/shared/widgets/app_guard.dart';
import 'package:expense/shared/widgets/app_scrollable_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen that lists all transactions for the current profile.
/// Supports optional filtering passed to [transactionListProvider].
class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current profile
    final profile = ref.watch(currentProfileProvider);
    if (profile == null) {
      return AppGuard();
    }
    return Scaffold(
      appBar: AppAppBar(
        title: 'Transactions',
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(value: 'create', child: const Text('Create')),
            ],
            onSelected: (value) {
              switch (value) {
                case 'create':
                  TransactionSheet.show(context);
                  break;
              }
            },
          ),
        ],
      ),
      body: AppScrollableRefresh(
        padding: appPadding.copyWith(top: 0),
        onRefresh: () => ref.refresh(transactionListProvider(null).future),
        children: [TransactionList()],
      ),
    );
  }
}
