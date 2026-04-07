import 'package:flutter/material.dart';

class AppProgress extends StatelessWidget {
  final List<(double, Color?)> segments;
  final double height;
  final double radius;

  const AppProgress({
    super.key,
    required this.segments,
    this.height = 8,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final total = segments.fold(0.0, (sum, s) => sum + s.$1.abs());
    if (total == 0) {
      return SizedBox(
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );
    }
    return Row(
      children: List.generate(segments.length, (index) {
        final (value, color) = segments[index];
        final flex = (value.abs() / total * 100).round();
        final resolvedColor = color ?? Theme.of(context).colorScheme.primary;
        final isFirst = index == 0;
        final isLast = index == segments.length - 1;
        return Expanded(
          flex: flex == 0 ? 1 : flex,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: resolvedColor,
              borderRadius: BorderRadius.only(
                topLeft: isFirst ? Radius.circular(radius) : Radius.zero,
                bottomLeft: isFirst ? Radius.circular(radius) : Radius.zero,
                topRight: isLast ? Radius.circular(radius) : Radius.zero,
                bottomRight: isLast ? Radius.circular(radius) : Radius.zero,
              ),
            ),
          ),
        );
      }),
    );
  }
}
