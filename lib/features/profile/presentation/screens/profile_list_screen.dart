import 'package:expense/features/profile/presentation/providers/profile_provider.dart';
import 'package:expense/features/profile/presentation/widgets/profile_sheet.dart';
import 'package:expense/features/profile/presentation/widgets/profile_tile.dart';
import 'package:expense/shared/constants/app_padding.dart';
import 'package:expense/shared/widgets/app_app_bar.dart';
import 'package:expense/shared/widgets/app_card.dart';
import 'package:expense/shared/widgets/app_scrollable_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileListScreen extends ConsumerWidget {
  const ProfileListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppAppBar(
        title: 'Profiles',
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(value: 'create', child: const Text('Create')),
            ],
            onSelected: (value) {
              switch (value) {
                case 'create':
                  ProfileSheet.show(context);
                  break;
              }
            },
          ),
        ],
      ),
      body: AppScrollableRefresh(
        padding: appPadding.copyWith(top: 0),
        onRefresh: () => ref.read(profileProvider.notifier).initiate(),
        children: [
          switch (state) {
            // Loading
            ProfileInitial() || ProfileLoading() => const ProfileTile(null),
            // Empty
            ProfileEmpty() => AppCard(
              childrenSpacing: 12,
              children: [
                const Text('Create your profile'),
                Text(
                  'Profiles group your wallets, categories, transactions, and '
                  'other information.',
                  style: TextStyle(color: theme.hintColor),
                ),
                FilledButton.tonal(
                  onPressed: () => ProfileSheet.show(context),
                  child: Text('Let\'s Go'),
                ),
              ],
            ),
            // Loaded
            ProfileLoaded(:final profiles) => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: profiles.length,
              itemBuilder: (context, index) => ProfileTile(profiles[index]),
            ),
            // Error
            ProfileError(:final message) => Center(child: Text(message)),
          },
        ],
      ),
    );
  }
}
