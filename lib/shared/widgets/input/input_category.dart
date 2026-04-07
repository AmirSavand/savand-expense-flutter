import 'package:expense/features/category/presentation/providers/category_provider.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:expense/shared/utils/display_color.dart';
import 'package:expense/shared/utils/display_icon.dart';
import 'package:expense/shared/widgets/input/input_select_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputCategory extends StatelessWidget {
  final int? selected;
  final void Function(int) onSelect;
  final ExpenseKind? kind;

  const InputCategory({
    super.key,
    required this.selected,
    required this.onSelect,
    this.kind,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final profile = ref.watch(currentProfileProvider);
        final categoryState = ref.watch(categoryProvider);

        if (profile == null || categoryState is! CategoryLoaded) {
          return const SizedBox.shrink();
        }

        // Filter by kind
        final filtered = categoryState.categories.where((c) {
          if (kind == null) return true;
          return c.kind == kind;
        }).toList();

        return InputSelectBaseWidget(
          selected: selected,
          onSelect: onSelect,
          items: filtered,
          getId: (c) => c.id,
          getName: (c) => c.name,
          getIcon: (c) => displayIcon(c.icon),
          getColor: (c) => displayColor(c.color),
          getUsageCount: (c) => c.transactionsCount,
        );
      },
    );
  }
}
