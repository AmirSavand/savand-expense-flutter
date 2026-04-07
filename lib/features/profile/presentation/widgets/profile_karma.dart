import 'package:expense/features/profile/domain/models/profile.dart';
import 'package:expense/shared/utils/display_number.dart';
import 'package:expense/shared/widgets/app_card.dart';
import 'package:expense/shared/widgets/app_progress.dart';
import 'package:expense/shared/widgets/app_tile_icon.dart';
import 'package:flutter/material.dart';

class ProfileKaram extends StatelessWidget {
  final Profile profile;
  final EdgeInsetsGeometry? margin;

  const ProfileKaram({super.key, required this.profile, this.margin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      margin: margin,
      childrenSpacing: 16,
      children: [
        Row(
          spacing: 16,
          children: [
            AppTileIcon(icon: Icons.auto_awesome),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Profile Karam',
                    style: TextStyle(color: theme.hintColor),
                  ),
                  Text(
                    'Level ${displayNumber(profile.level)}',
                    style: TextStyle(
                      fontSize: theme.textTheme.titleLarge?.fontSize,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 6,
              children: [
                Text(
                  '${displayNumber(profile.karma)} XP',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
                Text(
                  'To level up: ${displayNumber(profile.nextLevelKarma)} XP',
                  style: TextStyle(color: theme.hintColor),
                ),
              ],
            ),
          ],
        ),
        AppProgress(
          segments: [
            (profile.karma.toDouble(), theme.colorScheme.primary),
            (profile.nextLevelKarma.toDouble(), theme.colorScheme.surface),
          ],
        ),
      ],
    );
  }
}
