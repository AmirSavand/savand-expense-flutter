import 'package:expense/features/category/domain/models/category.dart';
import 'package:expense/features/category/presentation/providers/category_provider.dart';
import 'package:expense/features/category/presentation/widgets/category_chart_pie.dart';
import 'package:expense/features/category/presentation/widgets/category_tile.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/profile/presentation/providers/profile_provider.dart';
import 'package:expense/features/profile/presentation/widgets/profile_karma.dart';
import 'package:expense/features/transaction/domain/models/transaction.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:expense/features/transaction/presentation/widgets/transaction_list.dart';
import 'package:expense/features/transaction/presentation/widgets/transaction_sheet.dart';
import 'package:expense/features/wallet/domain/models/wallet.dart';
import 'package:expense/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:expense/features/wallet/presentation/widgets/wallet_sheet.dart';
import 'package:expense/features/wallet/presentation/widgets/wallet_tile.dart';
import 'package:expense/shared/constants/app_padding.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:expense/shared/models/filters.dart';
import 'package:expense/shared/widgets/app_app_bar.dart';
import 'package:expense/shared/widgets/app_card.dart';
import 'package:expense/shared/widgets/app_card_balance.dart';
import 'package:expense/shared/widgets/app_card_header.dart';
import 'package:expense/shared/widgets/app_guard.dart';
import 'package:expense/shared/widgets/app_scrollable_refresh.dart';
import 'package:expense/shared/widgets/balance/balance_chart_pie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashScreen extends ConsumerWidget {
  const DashScreen({super.key});

  final Filters _transactionsFilter = const {'page_size': 8};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We need these provider states to use for widgets
    final profile = ref.watch(currentProfileProvider);
    final walletState = ref.watch(walletProvider);
    final categoryState = ref.watch(categoryProvider);
    final transactionListState = ref.watch(
      transactionListProvider(_transactionsFilter),
    );
    // Safety guard for profile
    if (profile == null) {
      return AppGuard();
    }
    // Top 3 wallets by total balance
    List<Wallet> wallets = [];
    if (walletState is WalletLoaded) {
      // Sort wallets by total balance
      wallets = walletState.wallets
        ..sort((a, b) => b.balance.total.toInt() - a.balance.total.toInt());
      // Include a portion only
      wallets = wallets.take(5).toList();
    }
    // Top 5 categories by total balance
    List<Category> categories = [];
    if (categoryState is CategoryLoaded) {
      // Filter by expense kind only
      categories = categoryState.categories
          .where((c) => c.kind == ExpenseKind.expense)
          .toList();
      // Sort by transactions total
      categories = categories
        ..sort((a, b) {
          return b.transactionsTotal.toInt() - a.transactionsTotal.toInt();
        });
      // Include a portion only
      categories = categories.take(5).toList();
      // Remove categories below 5% of total
      final total = categories.fold(0.0, (sum, c) => sum + c.transactionsTotal);
      categories = categories.where((c) {
        return total == 0 ? false : (c.transactionsTotal / total) >= 0.02;
      }).toList();
    }
    // Recent transactions
    final List<Transaction>? transactions = transactionListState.value?.results;
    // Flag for whether profile balance is empty
    final isBalanceZero =
        profile.balance.income == 0 && profile.balance.expense == 0;
    return Scaffold(
      appBar: AppAppBar(title: profile.name),
      body: AppScrollableRefresh(
        onRefresh: () async {
          ref.invalidate(transactionListProvider);
          await Future.wait([
            ref.read(profileProvider.notifier).initiate(),
            ref.read(walletProvider.notifier).initiate(profile.id),
            ref.read(categoryProvider.notifier).initiate(profile.id),
          ]);
        },
        spacing: 16,
        children: [
          // Available balance
          AppCardBalance(
            balance: profile.balance,
            currency: profile.currency,
            margin: appPaddingH,
          ),
          // Top wallets (header)
          AppCardHeader(
            label: 'Top Wallets',
            buttonLabel: 'View All',
            onTap: () => context.pushNamed('wallet-list'),
          ),
          // Top wallets (loading)
          if (walletState is! WalletLoaded)
            Padding(
              padding: appPaddingH,
              child: WalletTile(null, isMinimal: true, isColored: true),
            )
          // Top wallets (loaded)
          else if (wallets.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: appPaddingH,
              child: Row(
                spacing: 8,
                children: wallets.map((w) {
                  return SizedBox(
                    width: 260,
                    child: WalletTile(w, isMinimal: true, isColored: true),
                  );
                }).toList(),
              ),
            )
          else
            AppCard(
              margin: appPaddingH,
              childrenSpacing: 8,
              children: [
                Text('Create your first wallet to view its balance.'),
                FilledButton.tonal(
                  onPressed: () => WalletSheet.show(context),
                  child: Text('Create Wallet'),
                ),
              ],
            ),
          // Charts (header)
          AppCardHeader(label: 'Balance & Categories'),
          // Charts
          if (isBalanceZero && categories.isEmpty)
            AppCard(
              margin: appPaddingH,
              childrenSpacing: 8,
              children: [
                Text('Create transactions to view balance & category charts.'),
                FilledButton.tonal(
                  onPressed: () => TransactionSheet.show(context),
                  child: Text('Create Transaction'),
                ),
              ],
            )
          else
            AppCard(
              margin: appPaddingH,
              padding: EdgeInsets.all(16),
              child: Row(
                spacing: 16,
                children: [
                  // Balance chart
                  Expanded(child: BalanceChartPie(balance: profile.balance)),
                  // Categories chart
                  Expanded(child: CategoryChartPie(categories: categories)),
                ],
              ),
            ),
          // Category spending (header)
          AppCardHeader(
            label: 'Category Spending',
            buttonLabel: 'View All',
            onTap: () => context.pushNamed('category-list'),
          ),
          // Top categories
          if (categoryState is! CategoryLoaded)
            Padding(
              padding: appPaddingH,
              child: WalletTile(null, isMinimal: true, isColored: true),
            )
          else if (categories.isEmpty)
            AppCard(
              margin: appPaddingH,
              childrenSpacing: 8,
              children: [
                Text(
                  'When you have expenses, '
                  'their categories will show up here.',
                ),
                FilledButton.tonal(
                  onPressed: () => TransactionSheet.show(context),
                  child: Text('Create Transaction'),
                ),
              ],
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: appPaddingH,
              child: Row(
                spacing: 8,
                children: categories.map((c) {
                  return SizedBox(
                    width: 260,
                    child: CategoryTile(c, isMinimal: true, isColored: true),
                  );
                }).toList(),
              ),
            ),
          // History (header)
          AppCardHeader(
            label: 'History',
            buttonLabel: 'View All',
            onTap: () => context.pushNamed('transaction-list'),
          ),
          // History
          AppCard(
            padding: EdgeInsetsGeometry.all(0),
            margin: appPaddingH,
            child: TransactionList(
              useProvider: false,
              transactions: transactions,
              showHeader: false,
            ),
          ),
          // Profile karma (header)
          AppCardHeader(
            label: 'Profile Karma',
            buttonLabel: 'View Profile',
            onTap: () => context.pushNamed(
              'profile-detail',
              pathParameters: {'id': profile.id.toString()},
            ),
          ),
          // Profile karma
          ProfileKaram(profile: profile, margin: appPaddingH),
          // End of page spacing
          SizedBox(height: 6),
        ],
      ),
    );
  }
}
