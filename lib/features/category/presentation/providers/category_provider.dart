import 'package:expense/core/service_locator.dart';
import 'package:expense/features/category/domain/category_repository.dart';
import 'package:expense/features/category/domain/models/category.dart';
import 'package:expense/features/category/domain/models/category_form.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/shared/utils/display_error.dart';
import 'package:expense/shared/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global provider for [CategoryNotifier] exposing [CategoryState].
final categoryProvider = NotifierProvider<CategoryNotifier, CategoryState>(
  () => CategoryNotifier(),
);

// State

/// Base class for all possible category states.
sealed class CategoryState {}

/// Initial state before categories have been loaded.
class CategoryInitial extends CategoryState {}

/// Emitted while categories are being fetched.
class CategoryLoading extends CategoryState {}

/// Emitted when categories are loaded. Holds the current list.
class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  CategoryLoaded(this.categories);
}

/// Emitted when a category operation fails.
class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}

// Notifier

/// Manages category state and fetches categories from the repository.
class CategoryNotifier extends Notifier<CategoryState> {
  final _logger = Logger('Category');
  late CategoryRepository _repo;

  @override
  CategoryState build() {
    _repo = getIt<CategoryRepository>();
    final currentProfile = ref.read(currentProfileProvider);
    if (currentProfile != null) {
      Future.microtask(() => initiate(currentProfile.id));
    }
    return CategoryInitial();
  }

  /// Fetches categories for [profileId].
  /// Shows existing data immediately while fetching fresh data in background.
  Future<void> initiate(int profileId) async {
    // If already loaded, keep showing current data while refreshing.
    if (state is! CategoryLoaded) {
      state = CategoryLoading();
    }
    try {
      final categories = await _repo.list(profileId);
      state = CategoryLoaded(categories);
      _logger.log(['Loaded', categories.length, 'items']);
    } catch (e) {
      state = CategoryError(displayError(e));
    }
  }

  Future<Category> create(CategoryForm data) async {
    final loaded = state as CategoryLoaded;
    final created = await _repo.create(data);
    state = CategoryLoaded([...loaded.categories, created]);
    return created;
  }

  Future<Category> update(int id, CategoryForm data) async {
    final loaded = state as CategoryLoaded;
    final updated = await _repo.update(id, data);
    final categories = loaded.categories
        .map((e) => e.id == id ? updated : e)
        .toList();
    state = CategoryLoaded(categories);
    return updated;
  }

  Future<void> destroy(int id) async {
    final loaded = state as CategoryLoaded;
    await _repo.destroy(id);
    final categories = loaded.categories.where((e) => e.id != id).toList();
    state = CategoryLoaded(categories);
  }
}
