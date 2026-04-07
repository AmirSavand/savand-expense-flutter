import 'package:expense/core/theme.dart';
import 'package:expense/shared/models/balance.dart';
import 'package:expense/shared/widgets/app_progress.dart';
import 'package:flutter/material.dart';

class AppProgressBalance extends StatelessWidget {
  final Balance balance;

  const AppProgressBalance(this.balance, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppProgress(
      segments: [
        (balance.income, ThemeColors.income),
        (balance.expense, ThemeColors.expense),
      ],
    );
  }
}
