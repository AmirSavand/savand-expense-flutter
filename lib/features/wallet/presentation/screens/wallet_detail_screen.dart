import 'package:collection/collection.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:expense/features/transaction/presentation/widgets/transaction_list.dart';
import 'package:expense/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:expense/features/wallet/presentation/widgets/wallet_sheet.dart';
import 'package:expense/shared/constants/app_padding.dart';
import 'package:expense/shared/widgets/app_app_bar.dart';
import 'package:expense/shared/widgets/app_card_balance.dart';
import 'package:expense/shared/widgets/app_guard.dart';
import 'package:expense/shared/widgets/app_not_found.dart';
import 'package:expense/shared/widgets/app_scrollable_refresh.dart';
import 'package:expense/shared/widgets/dialog/dialog_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Displays detail information for a single wallet identified by [id].
class WalletDetailScreen extends ConsumerWidget {
  final int id;

  const WalletDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final state = ref.watch(walletProvider);
    // Make sure state is loaded
    if (state is! WalletLoaded || profile == null) {
      return AppGuard();
    }
    final item = state.wallets.firstWhereOrNull((e) => e.id == id);
    // Make sure item is found
    if (item == null) {
      return AppNotFound();
    }
    final transactionsFilter = {'wallet': id};
    return Scaffold(
      appBar: AppAppBar(
        title: item.name,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: const Text('Edit')),
              PopupMenuItem(value: 'delete', child: const Text('Delete')),
            ],
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  WalletSheet.show(context, wallet: item);
                  break;
                case 'delete':
                  showDialogConfirm(
                    context: context,
                    title: 'Delete Wallet',
                    content: [
                      'Are you sure you want to delete "${item.name}"?',
                      'All transactions from and to this wallet will be lost.',
                    ],
                    onConfirm: () {
                      ref.read(walletProvider.notifier).destroy(id);
                      context.pop();
                    },
                  );
                  break;
              }
            },
          ),
        ],
      ),
      body: AppScrollableRefresh(
        padding: appPadding.copyWith(top: 0),
        onRefresh: () {
          return ref.refresh(
            transactionListProvider(transactionsFilter).future,
          );
        },
        children: [
          AppCardBalance(balance: item.balance, currency: profile.currency),
          const SizedBox(height: 16),
          TransactionList(filters: transactionsFilter),
        ],
      ),
    );
  }
}
