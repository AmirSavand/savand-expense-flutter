import 'package:expense/features/category/presentation/providers/category_by_id_provider.dart';
import 'package:expense/features/category/presentation/widgets/category_tile.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_destroy_provider.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_retrieve_provider.dart';
import 'package:expense/features/transaction/presentation/widgets/transaction_sheet.dart';
import 'package:expense/features/wallet/presentation/providers/wallet_by_id_provider.dart';
import 'package:expense/features/wallet/presentation/widgets/wallet_tile.dart';
import 'package:expense/shared/constants/app_padding.dart';
import 'package:expense/shared/utils/display_color.dart';
import 'package:expense/shared/utils/display_currency.dart';
import 'package:expense/shared/utils/display_date.dart';
import 'package:expense/shared/utils/display_icon.dart';
import 'package:expense/shared/utils/display_text.dart';
import 'package:expense/shared/widgets/app_app_bar.dart';
import 'package:expense/shared/widgets/app_glow_detail.dart';
import 'package:expense/shared/widgets/app_guard.dart';
import 'package:expense/shared/widgets/app_not_found.dart';
import 'package:expense/shared/widgets/app_scrollable_refresh.dart';
import 'package:expense/shared/widgets/app_tile.dart';
import 'package:expense/shared/widgets/app_tile_icon.dart';
import 'package:expense/shared/widgets/app_tile_shimmer.dart';
import 'package:expense/shared/widgets/dialog/dialog_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Displays detail information for a single transaction identified by [id].
class TransactionDetailScreen extends ConsumerWidget {
  final int id;

  const TransactionDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final state = ref.watch(transactionRetrieveProvider(id));
    if (profile == null) {
      return AppGuard();
    }
    if (state.hasError) {
      return AppNotFound();
    }
    if (state.isLoading) {
      return Scaffold(
        appBar: AppAppBar(title: 'Transaction'),
        body: AppScrollableRefresh(
          padding: appPaddingH,
          onRefresh: () => ref.refresh(transactionRetrieveProvider(id).future),
          children: [
            AppGlowDetail.loading(context),
            AppTileShimmer.list(3, padding: appPaddingH),
          ],
        ),
      );
    }
    final item = state.requireValue;
    final wallet = ref.watch(walletByIdProvider(item.wallet));
    final walletInto = item.into != null
        ? ref.watch(walletByIdProvider(item.into!))
        : null;
    final category = ref.watch(categoryByIdProvider(item.category));
    return Scaffold(
      appBar: AppAppBar(
        title: 'Transaction',
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: const Text('Edit')),
              PopupMenuItem(value: 'delete', child: const Text('Delete')),
            ],
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  TransactionSheet.show(context, transaction: item);
                  break;
                case 'delete':
                  showDialogConfirm(
                    context: context,
                    title: 'Delete Transaction',
                    content: [
                      'Are you sure you want to delete this transaction?',
                    ],
                    onConfirm: () {
                      ref.read(transactionDestroyProvider.notifier).destroy(id);
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
        onRefresh: () => ref.refresh(transactionRetrieveProvider(id).future),
        padding: appPaddingH,
        children: [
          category != null
              ? AppGlowDetail(
                  color: displayColor(category.color),
                  icon: displayIcon(category.icon),
                  topText: category.name,
                  mainText: displayCurrency(
                    item.amount,
                    profile.currency,
                    kind: category.kind,
                  ),
                  bottomText: displayDateTime(item.time),
                )
              : AppGlowDetail.loading(context),
          // Category
          CategoryTile(
            category,
            isMinimal: true,
            isColored: true,
            trailing: 'Category',
          ),
          SizedBox(height: 6),
          // Wallet (from)
          WalletTile(
            wallet,
            isMinimal: true,
            isColored: true,
            trailing: 'Wallet',
          ),
          SizedBox(height: 6),
          // Wallet (into)
          if (walletInto != null)
            WalletTile(
              walletInto,
              isMinimal: true,
              isColored: true,
              trailing: 'Into Wallet',
            ),
          if (walletInto != null) SizedBox(height: 6),
          // Kind
          AppTile(
            title: 'Kind',
            leading: AppTileIcon(icon: Icons.label_outline_sharp),
            subtitle: item.kind.label,
          ),
          // Note
          if (item.note != null && item.note!.isNotEmpty)
            AppTile(
              title: 'Note',
              leading: AppTileIcon(icon: Icons.note_outlined),
              subtitle: displayText(item.note),
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          // Excluded
          if (item.exclude)
            AppTile(
              title: 'Excluded',
              leading: AppTileIcon(icon: Icons.block),
            ),
          // Archived
          if (item.archive)
            AppTile(
              title: 'Archived',
              leading: AppTileIcon(icon: Icons.archive_outlined),
            ),
        ],
      ),
    );
  }
}
