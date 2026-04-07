import 'package:expense/features/category/presentation/providers/category_provider.dart';
import 'package:expense/features/profile/domain/models/profile.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import 'mock_data.dart';

/// Standard provider overrides for common test scenarios
final standardOverrides = [
  currentProfileProvider.overrideWithValue(mockProfile),
];

/// Overrides for testing with null profile (unauthenticated/unloaded state)
final nullProfileOverrides = [currentProfileProvider.overrideWithValue(null)];

/// Overrides for testing with a specific profile
Override profileOverride(Profile profile) {
  return currentProfileProvider.overrideWithValue(profile);
}

/// Mock CategoryNotifier that returns loaded state with all mock categories
final mockCategoryProviderOverride = categoryProvider.overrideWith(
  () => MockCategoryNotifier(),
);

/// Mock CategoryNotifier that returns loaded state with only income categories
final mockCategoryProviderOnlyIncome = categoryProvider.overrideWith(
  () => MockCategoryNotifierOnlyIncome(),
);

/// Mock CategoryNotifier that returns loaded state with only expense categories
final mockCategoryProviderOnlyExpense = categoryProvider.overrideWith(
  () => MockCategoryNotifierOnlyExpense(),
);

/// Mock CategoryNotifier that returns empty list
final mockCategoryProviderEmpty = categoryProvider.overrideWith(
  () => MockCategoryNotifierEmpty(),
);

/// Mock CategoryNotifier that returns loading state
final mockCategoryProviderLoading = categoryProvider.overrideWith(
  () => MockCategoryNotifierLoading(),
);

/// Mock CategoryNotifier that returns error state
final mockCategoryProviderError = categoryProvider.overrideWith(
  () => MockCategoryNotifierError(),
);

/// Combined overrides for transaction tile tests
final transactionTileOverrides = [
  currentProfileProvider.overrideWithValue(mockProfile),
  categoryProvider.overrideWith(() => MockCategoryNotifier()),
];

/// Combined overrides for testing with null profile
final transactionTileNullProfileOverrides = [
  currentProfileProvider.overrideWithValue(null),
  categoryProvider.overrideWith(() => MockCategoryNotifier()),
];

/// Mock CategoryNotifier that returns loaded state with all mock categories
class MockCategoryNotifier extends CategoryNotifier {
  @override
  CategoryState build() {
    return CategoryLoaded([
      mockCategoryExpense,
      mockCategoryIncome,
      mockCategoryTransfer,
    ]);
  }
}

/// Mock CategoryNotifier that returns only income categories
class MockCategoryNotifierOnlyIncome extends CategoryNotifier {
  @override
  CategoryState build() {
    return CategoryLoaded([mockCategoryIncome]);
  }
}

/// Mock CategoryNotifier that returns only expense categories
class MockCategoryNotifierOnlyExpense extends CategoryNotifier {
  @override
  CategoryState build() {
    return CategoryLoaded([mockCategoryExpense]);
  }
}

/// Mock CategoryNotifier that returns empty list
class MockCategoryNotifierEmpty extends CategoryNotifier {
  @override
  CategoryState build() {
    return CategoryLoaded([]);
  }
}

/// Mock CategoryNotifier that returns loading state
class MockCategoryNotifierLoading extends CategoryNotifier {
  @override
  CategoryState build() {
    return CategoryLoading();
  }
}

/// Mock CategoryNotifier that returns error state
class MockCategoryNotifierError extends CategoryNotifier {
  @override
  CategoryState build() {
    return CategoryError('Failed to load categories');
  }
}
