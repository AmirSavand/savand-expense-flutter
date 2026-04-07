import 'package:expense/features/category/presentation/providers/category_by_id_provider.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/transaction/domain/models/transaction.dart';
import 'package:expense/features/transaction/presentation/widgets/transaction_sheet.dart';
import 'package:expense/shared/utils/display_date.dart';
import 'package:expense/shared/widgets/app_tile.dart';
import 'package:expense/shared/widgets/app_tile_icon.dart';
import 'package:expense/shared/widgets/app_tile_icon_for_model.dart';
import 'package:expense/shared/widgets/app_tile_shimmer.dart';
import 'package:expense/shared/widgets/currency/currency_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransactionTile extends ConsumerWidget {
  final Transaction? transaction;

  const TransactionTile(this.transaction, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    if (profile == null || transaction == null) {
      return const AppTileShimmer();
    }
    final item = transaction as Transaction;
    final category = ref.watch(categoryByIdProvider(item.category));
    final theme = Theme.of(context);
    return AppTile(
      leading: category != null
          ? AppTileIconForModel(icon: category.icon, color: category.color)
          : AppTileIcon(icon: Icons.question_mark),
      title: category?.name ?? 'Category',
      trailingWidget: CurrencyText(
        amount: item.amount,
        currency: profile.currency,
        kind: item.kind,
      ),
      subtitleWidget: Text(
        displayTime(item.time),
        style: TextStyle(color: theme.hintColor),
      ),
      onTap: () => context.pushNamed(
        'transaction-detail',
        pathParameters: {'id': item.id.toString()},
      ),
      onLongPress: () => TransactionSheet.show(context, transaction: item),
    );
  }
}
