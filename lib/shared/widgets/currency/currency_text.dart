import 'package:expense/shared/enums/expense_kind.dart';
import 'package:expense/shared/utils/display_currency.dart';
import 'package:flutter/material.dart';

class CurrencyText extends StatelessWidget {
  final double amount;
  final String currency;
  final ExpenseKind? kind;
  final TextStyle? style;

  const CurrencyText({
    super.key,
    required this.amount,
    required this.currency,
    this.kind,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ExpenseKind? resolvedKind = kind;
    final resolvedStyle = style ?? TextStyle();
    if (resolvedKind == null) {
      if (amount > 0) {
        resolvedKind = ExpenseKind.income;
      } else if (amount < 0) {
        resolvedKind = ExpenseKind.expense;
      }
    }
    final color = switch (resolvedKind) {
      ExpenseKind.income => theme.colorScheme.primary,
      ExpenseKind.expense => theme.colorScheme.error,
      _ => null,
    };
    return Text(
      displayCurrency(amount, currency),
      style: resolvedStyle.copyWith(color: color),
    );
  }
}
