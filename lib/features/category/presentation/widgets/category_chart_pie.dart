import 'package:expense/features/category/domain/models/category.dart';
import 'package:expense/shared/utils/display_color.dart';
import 'package:expense/shared/widgets/app_chart_pie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryChartPie extends ConsumerWidget {
  final List<Category> categories;

  const CategoryChartPie({super.key, required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (categories.isEmpty) {
      return AppChartPie.placeholder(context, count: 5);
    }
    return AppChartPie(
      sections: categories.map((c) {
        return PieChartSectionData(
          value: c.transactionsTotal,
          color: displayColor(c.color),
        );
      }).toList(),
    );
  }
}
