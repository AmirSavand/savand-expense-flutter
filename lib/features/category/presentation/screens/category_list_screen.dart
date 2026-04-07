import 'package:expense/features/category/presentation/providers/category_kind_filter_provider.dart';
import 'package:expense/features/category/presentation/providers/category_provider.dart';
import 'package:expense/features/category/presentation/widgets/category_sheet.dart';
import 'package:expense/features/category/presentation/widgets/category_tile.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/shared/constants/app_padding.dart';
import 'package:expense/shared/widgets/app_app_bar.dart';
import 'package:expense/shared/widgets/app_guard.dart';
import 'package:expense/shared/widgets/app_scrollable_refresh.dart';
import 'package:expense/shared/widgets/app_tile_shimmer.dart';
import 'package:expense/shared/widgets/input/input_expense_kind.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen that lists all categories for the current profile.
class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final selectedKind = ref.watch(categoryKindFilterProvider);
    final filteredCategories = ref.watch(filteredCategoriesProvider);
    final state = ref.watch(categoryProvider);
    if (profile == null) {
      return AppGuard();
    }
    return Scaffold(
      appBar: AppAppBar(
        title: 'Categories',
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'create', child: Text('Create')),
            ],
            onSelected: (value) {
              switch (value) {
                case 'create':
                  CategorySheet.show(context);
                  break;
              }
            },
          ),
        ],
      ),
      body: AppScrollableRefresh(
        padding: appPadding,
        onRefresh: () async {
          await ref.read(categoryProvider.notifier).initiate(profile.id);
        },
        children: [
          InputKind(
            selected: selectedKind,
            onSelect: (kind) {
              ref.read(categoryKindFilterProvider.notifier).change(kind);
            },
          ),
          const SizedBox(height: 16),
          switch (state) {
            // Loading
            CategoryInitial() || CategoryLoading() => AppTileShimmer.list(25),
            // Loaded
            CategoryLoaded() => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                return CategoryTile(filteredCategories[index]);
              },
            ),
            // Error
            CategoryError(:final message) => Center(child: Text(message)),
          },
        ],
      ),
    );
  }
}
