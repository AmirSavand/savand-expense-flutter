import 'package:expense/core/theme.dart';
import 'package:expense/shared/models/balance.dart';
import 'package:expense/shared/widgets/app_chart_pie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

class BalanceChartPie extends StatelessWidget {
  final Balance balance;
  final String? currency;

  const BalanceChartPie({super.key, required this.balance, this.currency});

  @override
  Widget build(BuildContext context) {
    if (balance.income == 0 && balance.expense == 0) {
      return AppChartPie.placeholder(context, count: 2);
    }
    return AppChartPie(
      currency: currency,
      sections: [
        PieChartSectionData(
          value: balance.income,
          color: ThemeColors.income,
          badgePositionPercentageOffset: -0.5,
        ),
        PieChartSectionData(
          value: balance.expense,
          color: ThemeColors.expense,
          badgePositionPercentageOffset: -0.5,
        ),
      ],
    );
  }
}
