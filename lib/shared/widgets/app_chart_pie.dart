import 'package:expense/shared/utils/display_currency.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AppChartPie extends StatelessWidget {
  final List<PieChartSectionData> sections;
  final String? currency;
  final double sectionsSpace;
  final double radius;

  const AppChartPie({
    super.key,
    required this.sections,
    this.currency,
    this.sectionsSpace = 6,
    this.radius = 32,
  });

  static AppChartPie placeholder(BuildContext context, {int count = 5}) {
    return AppChartPie(
      sections: List.generate(
        count,
        (_) => PieChartSectionData(
          value: 1,
          color: Theme.of(context).colorScheme.secondary.withAlpha(60),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionsResolved = sections.map((section) {
      Widget? badge;
      if (currency != null) {
        badge = Text(
          displayCurrency(section.value, currency!),
          style: TextStyle(
            shadows: [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        );
      }
      return section.copyWith(
        radius: radius,
        showTitle: false,
        badgeWidget: badge,
      );
    }).toList();
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(sectionsSpace: sectionsSpace, sections: sectionsResolved),
      ),
    );
  }
}
