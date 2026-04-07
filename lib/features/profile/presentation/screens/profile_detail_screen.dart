import 'package:collection/collection.dart';
import 'package:expense/features/profile/domain/models/profile.dart';
import 'package:expense/features/profile/presentation/providers/profile_provider.dart';
import 'package:expense/features/profile/presentation/widgets/profile_karma.dart';
import 'package:expense/features/profile/presentation/widgets/profile_sheet.dart';
import 'package:expense/shared/utils/display_text.dart';
import 'package:expense/shared/widgets/app_app_bar.dart';
import 'package:expense/shared/widgets/app_card_balance.dart';
import 'package:expense/shared/widgets/app_guard.dart';
import 'package:expense/shared/widgets/app_not_found.dart';
import 'package:expense/shared/widgets/app_scrollable_refresh.dart';
import 'package:expense/shared/widgets/app_tile.dart';
import 'package:expense/shared/widgets/app_tile_icon.dart';
import 'package:expense/shared/widgets/dialog/dialog_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Displays detail information for a single profile identified by [id].
class ProfileDetailScreen extends ConsumerWidget {
  final int id;

  const ProfileDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    if (profile is! ProfileLoaded) {
      return AppGuard();
    }
    final item = profile.profiles.firstWhereOrNull(
      (Profile item) => item.id == id,
    );
    if (item == null) {
      return AppNotFound();
    }
    final isSelected = item.id == profile.currentProfile.id;
    return Scaffold(
      appBar: AppAppBar(
        title: item.name,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              // Select
              PopupMenuItem(
                value: 'select',
                enabled: !isSelected,
                child: const Text('Select'),
              ),
              // Edit
              PopupMenuItem(value: 'edit', child: const Text('Edit')),
              // Delete
              PopupMenuItem(
                value: 'delete',
                enabled: !isSelected,
                child: const Text('Delete'),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'select':
                  ref.read(profileProvider.notifier).select(item);
                  context.goNamed('dash');
                  break;
                case 'edit':
                  ProfileSheet.show(context, profile: item);
                  break;
                case 'delete':
                  showDialogConfirm(
                    context: context,
                    title: 'Delete Profile',
                    content: [
                      'Are you sure you want to delete "${item.name}"?',
                      'Everything related to this profile will be lost.',
                      'This action can not be undone.',
                    ],
                    onConfirm: () {
                      ref.read(profileProvider.notifier).destroy(id);
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
        padding: const EdgeInsets.all(16).copyWith(top: 0),
        onRefresh: () => ref.read(profileProvider.notifier).initiate(),
        children: [
          ProfileKaram(profile: item),
          const SizedBox(height: 16),
          AppCardBalance(balance: item.balance, currency: item.currency),
          AppTile(
            title: 'Note',
            subtitle: displayText(item.note),
            leading: AppTileIcon(icon: Icons.note_outlined),
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ],
      ),
    );
  }
}
