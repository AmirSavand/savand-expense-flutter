import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:expense/features/wallet/presentation/widgets/wallet_sheet.dart';
import 'package:expense/features/wallet/presentation/widgets/wallet_tile.dart';
import 'package:expense/shared/constants/app_padding.dart';
import 'package:expense/shared/widgets/app_app_bar.dart';
import 'package:expense/shared/widgets/app_guard.dart';
import 'package:expense/shared/widgets/app_scrollable_refresh.dart';
import 'package:expense/shared/widgets/app_tile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen that lists all wallets for the current profile.
class WalletListScreen extends ConsumerWidget {
  const WalletListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    if (profile == null) {
      return AppGuard();
    }
    final state = ref.watch(walletProvider);
    return Scaffold(
      appBar: AppAppBar(
        title: 'Wallets',
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(value: 'create', child: const Text('Create')),
            ],
            onSelected: (value) {
              switch (value) {
                case 'create':
                  WalletSheet.show(context);
                  break;
              }
            },
          ),
        ],
      ),
      body: AppScrollableRefresh(
        padding: appPadding.copyWith(left: 0, right: 0, top: 0),
        onRefresh: () async {
          await ref.read(walletProvider.notifier).initiate(profile.id);
        },
        children: [
          switch (state) {
            // Loading
            WalletInitial() || WalletLoading() => AppTileShimmer.list(5),
            // Loaded
            WalletLoaded(:final wallets) =>
              wallets.isEmpty
                  ? ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: const [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(
                            vertical: 64,
                            horizontal: 16,
                          ),
                          child: Center(
                            child: Text('There are no wallets yet.'),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: appPaddingH,
                      itemCount: wallets.length,
                      itemBuilder: (context, index) {
                        return WalletTile(wallets[index]);
                      },
                    ),
            // Error
            WalletError(:final message) => Center(child: Text(message)),
          },
        ],
      ),
    );
  }
}
