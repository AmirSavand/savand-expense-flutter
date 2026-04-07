import 'package:expense/features/category/domain/models/category.dart';
import 'package:expense/features/category/presentation/providers/category_provider.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_kind_filter_provider.g.dart';

/// Provides filtered categories based on the selected kind filter.
final filteredCategoriesProvider = Provider<List<Category>>((ref) {
  final selectedKind = ref.watch(categoryKindFilterProvider);
  final categoriesState = ref.watch(categoryProvider);
  // Return empty list if categories aren't loaded yet
  if (categoriesState is! CategoryLoaded) {
    return [];
  }
  // Filter categories by the selected kind
  return categoriesState.categories
      .where((category) => category.kind == selectedKind)
      .toList();
});

/// Tracks the currently selected kind filter for category lists.
@riverpod
class CategoryKindFilter extends _$CategoryKindFilter {
  @override
  ExpenseKind build() {
    return ExpenseKind.expense;
  }

  void change(ExpenseKind kind) {
    state = kind;
  }
}
