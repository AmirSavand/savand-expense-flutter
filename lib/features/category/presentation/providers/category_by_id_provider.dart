import 'package:collection/collection.dart';
import 'package:expense/features/category/domain/models/category.dart';
import 'package:expense/features/category/presentation/providers/category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryByIdProvider = Provider.family<Category?, int>((ref, id) {
  final state = ref.watch(categoryProvider);
  if (state is! CategoryLoaded) {
    return null;
  }
  return state.categories.firstWhereOrNull((e) => e.id == id);
});
