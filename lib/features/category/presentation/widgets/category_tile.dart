import 'package:expense/features/category/domain/models/category.dart';
import 'package:expense/features/category/presentation/widgets/category_sheet.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/shared/utils/display_color.dart';
import 'package:expense/shared/utils/display_currency.dart';
import 'package:expense/shared/utils/display_number.dart';
import 'package:expense/shared/widgets/app_tile.dart';
import 'package:expense/shared/widgets/app_tile_icon_for_model.dart';
import 'package:expense/shared/widgets/app_tile_shimmer.dart';
import 'package:expense/shared/widgets/currency/currency_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategoryTile extends ConsumerWidget {
  final Category? category;
  final bool isMinimal;
  final bool isColored;

  /// Used only when [isMinimal] is `true`.
  final String? trailing;

  const CategoryTile(
    this.category, {
    super.key,
    this.isMinimal = false,
    this.isColored = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    if (profile == null || category == null) {
      return AppTileShimmer();
    }
    final item = category as Category;
    final count = Text('${displayNumber(item.transactionsCount)} transactions');
    final total = isColored
        ? Text(displayCurrency(item.transactionsTotal, profile.currency))
        : CurrencyText(
            amount: item.transactionsTotal,
            currency: profile.currency,
          );
    return AppTile(
      leading: AppTileIconForModel(icon: item.icon, color: item.color),
      title: item.name,
      subtitle: '${item.transactionsCount} transactions',
      subtitleWidget: isMinimal ? total : count,
      trailingWidget: isMinimal ? null : total,
      trailing: trailing,
      tileColor: isColored ? displayColor(item.color).withAlpha(35) : null,
      onTap: () => context.pushNamed(
        'category-detail',
        pathParameters: {'id': item.id.toString()},
      ),
      onLongPress: () => CategorySheet.show(context, category: item),
    );
  }
}
