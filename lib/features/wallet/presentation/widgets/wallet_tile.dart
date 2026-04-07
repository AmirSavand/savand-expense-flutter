import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/wallet/domain/models/wallet.dart';
import 'package:expense/features/wallet/presentation/widgets/wallet_sheet.dart';
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

class WalletTile extends ConsumerWidget {
  final Wallet? wallet;
  final bool isMinimal;
  final bool isColored;

  /// Used only when [isMinimal] is `true`.
  final String? trailing;

  const WalletTile(
    this.wallet, {
    super.key,
    this.isMinimal = false,
    this.isColored = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    if (profile == null || wallet == null) {
      return AppTileShimmer();
    }
    final item = wallet as Wallet;
    final count = Text('${displayNumber(item.used)} transactions');
    final total = isColored
        ? Text(displayCurrency(item.balance.total, profile.currency))
        : CurrencyText(amount: item.balance.total, currency: profile.currency);
    return AppTile(
      leading: AppTileIconForModel(icon: item.icon, color: item.color),
      title: item.name,
      subtitleWidget: isMinimal ? total : count,
      trailingWidget: isMinimal ? null : total,
      trailing: trailing,
      tileColor: isColored ? displayColor(item.color).withAlpha(35) : null,
      onTap: () => context.pushNamed(
        'wallet-detail',
        pathParameters: {'id': item.id.toString()},
      ),
      onLongPress: () => WalletSheet.show(context, wallet: item),
    );
  }
}
