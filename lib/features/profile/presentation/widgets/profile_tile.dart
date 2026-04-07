import 'package:expense/features/profile/domain/models/profile.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/profile/presentation/widgets/profile_sheet.dart';
import 'package:expense/shared/widgets/app_tile.dart';
import 'package:expense/shared/widgets/app_tile_icon.dart';
import 'package:expense/shared/widgets/app_tile_shimmer.dart';
import 'package:expense/shared/widgets/currency/currency_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileTile extends ConsumerWidget {
  final Profile? profile;

  const ProfileTile(this.profile, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProfile = ref.watch(currentProfileProvider);
    if (currentProfile == null || profile == null) {
      return AppTileShimmer();
    }
    final item = profile as Profile;
    final isSelected = item.id == currentProfile.id;
    return AppTile(
      leading: AppTileIcon(
        icon: isSelected ? Icons.check_circle : Icons.person,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
      ),
      title: item.name,
      subtitle: 'Level ${item.level}',
      trailingWidget: CurrencyText(
        amount: item.balance.total,
        currency: item.currency,
      ),
      onTap: () => context.pushNamed(
        'profile-detail',
        pathParameters: {'id': item.id.toString()},
      ),
      onLongPress: () => ProfileSheet.show(context, profile: item),
    );
  }
}
