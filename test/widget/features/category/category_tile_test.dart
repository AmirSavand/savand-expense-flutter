import 'package:expense/features/category/presentation/widgets/category_tile.dart';
import 'package:expense/shared/utils/display_currency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

import '../../../helpers/mock_data.dart';
import '../../../helpers/mock_providers.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('CategoryTile', () {
    testWidgets('renders category information correctly', (tester) async {
      await pumpRiverpodWidget(tester, CategoryTile(mockCategoryExpense));

      expect(find.text(mockCategoryExpense.name), findsOneWidget);
      expect(
        find.text('${mockCategoryExpense.transactionsCount} transactions'),
        findsOneWidget,
      );
      expect(
        find.text(
          displayCurrency(
            mockCategoryExpense.transactionsTotal,
            mockProfile.currency,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows shimmer when profile is null', (tester) async {
      await pumpRiverpodWidget(
        tester,
        CategoryTile(mockCategoryExpense),
        overrides: nullProfileOverrides,
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('shows minimal version without transaction count', (
      tester,
    ) async {
      await pumpRiverpodWidget(
        tester,
        CategoryTile(mockCategoryExpense, isMinimal: true),
      );

      // Should show total (not transaction count) in minimal mode
      expect(
        find.text(
          displayCurrency(
            mockCategoryExpense.transactionsTotal,
            mockProfile.currency,
          ),
        ),
        findsOneWidget,
      );

      // Should NOT show transaction count
      expect(
        find.text('${mockCategoryExpense.transactionsCount} transactions'),
        findsNothing,
      );
    });

    testWidgets('shows custom trailing text when provided', (tester) async {
      await pumpRiverpodWidget(
        tester,
        CategoryTile(
          mockCategoryExpense,
          isMinimal: true,
          trailing: 'Selected',
        ),
      );

      expect(find.text('Selected'), findsOneWidget);
    });
  });
}
