import 'package:collection/collection.dart';
import 'package:expense/features/category/presentation/providers/category_provider.dart';
import 'package:expense/features/category/presentation/widgets/category_sheet.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:expense/features/transaction/presentation/widgets/transaction_list.dart';
import 'package:expense/shared/constants/app_padding.dart';
import 'package:expense/shared/utils/display_currency.dart';
import 'package:expense/shared/widgets/app_app_bar.dart';
import 'package:expense/shared/widgets/app_guard.dart';
import 'package:expense/shared/widgets/app_not_found.dart';
import 'package:expense/shared/widgets/app_scrollable_refresh.dart';
import 'package:expense/shared/widgets/app_tile.dart';
import 'package:expense/shared/widgets/app_tile_icon.dart';
import 'package:expense/shared/widgets/dialog/dialog_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoryDetailScreen extends ConsumerWidget {
  final int id;

  const CategoryDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final state = ref.watch(categoryProvider);
    // Make sure state is loaded
    if (state is! CategoryLoaded || profile == null) {
      return AppGuard();
    }
    final item = state.categories.firstWhereOrNull((e) => e.id == id);
    // Make sure item is found
    if (item == null) {
      return AppNotFound();
    }
    final transactionsFilter = {'category': id};
    return Scaffold(
      appBar: AppAppBar(
        title: item.name,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              // Edit
              PopupMenuItem(
                value: 'edit',
                enabled: !item.protect,
                child: const Text('Edit'),
              ),
              // Delete
              PopupMenuItem(
                value: 'delete',
                enabled: !item.protect,
                child: const Text('Delete'),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  CategorySheet.show(context, category: item);
                  break;
                case 'delete':
                  showDialogConfirm(
                    context: context,
                    title: 'Delete Category',
                    content: [
                      'Are you sure you want to delete "${item.name}"?',
                      'All transactions from and to this category will be lost.',
                    ],
                    onConfirm: () {
                      ref.read(categoryProvider.notifier).destroy(id);
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
        onRefresh: () =>
            ref.refresh(transactionListProvider(transactionsFilter).future),
        children: [
          AppTile(
            title: 'Total',
            leading: AppTileIcon(icon: Icons.attach_money),
            subtitle: displayCurrency(item.transactionsTotal, profile.currency),
          ),
          AppTile(
            title: 'Type',
            leading: AppTileIcon(icon: Icons.label_outline_sharp),
            subtitle: item.kind.label,
          ),
          TransactionList(filters: transactionsFilter),
        ],
      ),
    );
  }
}
