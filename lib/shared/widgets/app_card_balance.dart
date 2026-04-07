import 'package:expense/core/theme.dart';
import 'package:expense/shared/models/balance.dart';
import 'package:expense/shared/utils/display_currency.dart';
import 'package:expense/shared/widgets/app_card.dart';
import 'package:expense/shared/widgets/app_progress.dart';
import 'package:expense/shared/widgets/app_tile_icon.dart';
import 'package:flutter/material.dart';

class AppCardBalance extends StatelessWidget {
  final Balance balance;
  final String currency;
  final EdgeInsetsGeometry? margin;

  const AppCardBalance({
    super.key,
    required this.balance,
    required this.currency,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      childrenSpacing: 16,
      margin: margin,
      children: [
        Row(
          spacing: 16,
          children: [
            AppTileIcon(icon: Icons.attach_money),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Available Balance',
                    style: TextStyle(color: theme.hintColor),
                  ),
                  Text(
                    displayCurrency(balance.total, currency),
                    style: TextStyle(
                      fontSize: theme.textTheme.titleLarge?.fontSize,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 6,
              children: [
                Text(
                  displayCurrency(balance.income, currency),
                  style: TextStyle(color: ThemeColors.income),
                ),
                Text(
                  displayCurrency(balance.expense, currency),
                  style: TextStyle(color: ThemeColors.expense),
                ),
              ],
            ),
          ],
        ),
        AppProgress(
          segments: [
            (balance.income, ThemeColors.income),
            (balance.expense, ThemeColors.expense),
          ],
        ),
      ],
    );
  }
}
