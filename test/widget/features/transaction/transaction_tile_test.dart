import 'package:expense/features/category/presentation/providers/category_provider.dart';
import 'package:expense/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:expense/features/transaction/presentation/widgets/transaction_tile.dart';
import 'package:expense/shared/utils/display_currency.dart';
import 'package:expense/shared/utils/display_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

import '../../../helpers/mock_data.dart';
import '../../../helpers/mock_providers.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('TransactionTile', () {
    testWidgets('renders transaction information correctly', (tester) async {
      await pumpRiverpodWidget(
        tester,
        TransactionTile(mockTransaction),
        overrides: transactionTileOverrides,
      );

      // Check category name
      expect(find.text(mockCategoryExpense.name), findsOneWidget);

      // Check formatted amount
      expect(
        find.text(
          displayCurrency(mockTransaction.amount, mockProfile.currency),
        ),
        findsOneWidget,
      );

      // Check time
      expect(find.text(displayTime(mockTransaction.time)), findsOneWidget);
    });

    testWidgets('shows shimmer when profile is null', (tester) async {
      await pumpRiverpodWidget(
        tester,
        TransactionTile(mockTransaction),
        overrides: nullProfileOverrides,
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('shows shimmer when transaction is null', (tester) async {
      await pumpRiverpodWidget(tester, const TransactionTile(null));

      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('shows fallback when category not found', (tester) async {
      final transactionWithMissingCategory = mockTransaction.copyWith(
        category: 999,
      );

      // Use a mock that only has income category (not the expense category we need)
      final mockCategoryProviderOnlyIncome = categoryProvider.overrideWith(
        () => MockCategoryNotifierOnlyIncome(),
      );

      await pumpRiverpodWidget(
        tester,
        TransactionTile(transactionWithMissingCategory),
        overrides: [
          currentProfileProvider.overrideWithValue(mockProfile),
          mockCategoryProviderOnlyIncome,
        ],
      );

      // Should show "Category" as fallback text
      expect(find.text('Category'), findsOneWidget);
      expect(find.byIcon(Icons.question_mark), findsOneWidget);
    });
  });
}

// Additional mock for the "category not found" test
class MockCategoryNotifierOnlyIncome extends CategoryNotifier {
  @override
  CategoryState build() {
    return CategoryLoaded([
      // Only income, no expense category
      mockCategoryIncome,
    ]);
  }
}
