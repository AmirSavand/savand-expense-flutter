import 'package:expense/features/auth/presentation/providers/auth_provider.dart';
import 'package:expense/features/category/presentation/widgets/category_sheet.dart';
import 'package:expense/features/profile/presentation/widgets/profile_sheet.dart';
import 'package:expense/features/transaction/presentation/widgets/transaction_sheet.dart';
import 'package:expense/features/wallet/presentation/widgets/wallet_sheet.dart';
import 'package:expense/shared/providers/package_info_provider.dart';
import 'package:expense/shared/widgets/app_tile.dart';
import 'package:expense/shared/widgets/dialog/dialog_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shared navigation drawer used across all authenticated screens.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read version from cached provider, loads once for the app lifetime.
    final packageInfo = ref.watch(packageInfoProvider).value;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Drawer(
      child: Column(
        children: [
          // Header
          ColoredBox(
            color: theme.colorScheme.surfaceContainerHigh,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AppTile(
                  // App icon
                  trailingWidget: const CircleAvatar(child: Icon(Icons.wallet)),
                  // App title
                  title: 'Savand Expense',
                  // App version
                  subtitle: 'v${packageInfo?.version ?? '1.0.0'}',
                  // Go to app info
                  onTap: () {
                    Navigator.of(context).pop();
                    context.goNamed('about');
                  },
                ),
              ),
            ),
          ),
          // Links
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(
                16,
              ).copyWith(left: mediaQuery.padding.left + 16),
              children: [
                // Dashboard
                AppTile(
                  leading: const Icon(Icons.dashboard),
                  title: 'Dashboard',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.goNamed('dash');
                  },
                ),
                // Transactions
                AppTile(
                  leading: const Icon(Icons.receipt),
                  title: 'Transactions',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.goNamed('transaction-list');
                  },
                  onLongPress: () {
                    Navigator.of(context).pop();
                    TransactionSheet.show(context);
                  },
                ),
                // Wallets
                AppTile(
                  leading: const Icon(Icons.wallet),
                  title: 'Wallets',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.goNamed('wallet-list');
                  },
                  onLongPress: () {
                    Navigator.of(context).pop();
                    WalletSheet.show(context);
                  },
                ),
                // Categories
                AppTile(
                  leading: const Icon(Icons.category),
                  title: 'Categories',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.goNamed('category-list');
                  },
                  onLongPress: () {
                    Navigator.of(context).pop();
                    CategorySheet.show(context);
                  },
                ),
                // Profiles
                AppTile(
                  leading: const Icon(Icons.person),
                  title: 'Profiles',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.goNamed('profile-list');
                  },
                  onLongPress: () {
                    Navigator.of(context).pop();
                    ProfileSheet.show(context);
                  },
                ),
                // Logout
                AppTile(
                  leading: const Icon(Icons.logout),
                  title: 'Logout',
                  onTap: () {
                    showDialogConfirm(
                      context: context,
                      title: 'Logout',
                      content: [
                        'Are you sure you want to logout?',
                        'Goodbye in case you do 🥹',
                      ],
                      onConfirm: () async {
                        Navigator.of(context).pop();
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          context.goNamed('login');
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
