import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:expense/shared/utils/display_color.dart';
import 'package:expense/shared/utils/display_icon.dart';
import 'package:expense/shared/widgets/input/input_select_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputWallet extends StatelessWidget {
  final int? selected;
  final void Function(int) onSelect;

  const InputWallet({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final profile = ref.watch(currentProfileProvider);
        final walletState = ref.watch(walletProvider);
        if (profile == null || walletState is! WalletLoaded) {
          return const SizedBox.shrink();
        }
        return InputSelectBaseWidget(
          selected: selected,
          onSelect: onSelect,
          items: walletState.wallets,
          getId: (w) => w.id,
          getName: (w) => w.name,
          getIcon: (w) => displayIcon(w.icon),
          getColor: (w) => displayColor(w.color),
          getUsageCount: (w) => w.used,
        );
      },
    );
  }
}
