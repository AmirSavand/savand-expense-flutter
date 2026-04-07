import 'package:expense/features/wallet/presentation/widgets/wallet_tile.dart';
import 'package:expense/shared/utils/display_currency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

import '../../../helpers/mock_data.dart';
import '../../../helpers/mock_providers.dart';
import '../../../helpers/pump_app.dart';

void main() {
  group('WalletTile', () {
    testWidgets('renders wallet information correctly', (tester) async {
      await pumpRiverpodWidget(tester, WalletTile(mockWallet));

      expect(find.text(mockWallet.name), findsOneWidget);
      expect(find.text('${mockWallet.used} transactions'), findsOneWidget);
      expect(
        find.text(
          displayCurrency(mockWallet.balance.total, mockProfile.currency),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows shimmer when profile is null', (tester) async {
      await pumpRiverpodWidget(
        tester,
        WalletTile(mockWallet),
        overrides: nullProfileOverrides,
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });
  });
}
