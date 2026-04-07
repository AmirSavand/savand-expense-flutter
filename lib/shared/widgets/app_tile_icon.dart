import 'package:expense/shared/constants/app_border_radius.dart';
import 'package:flutter/material.dart';

class AppTileIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;

  const AppTileIcon({
    super.key,
    required this.icon,
    this.color,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? Theme.of(context).colorScheme.onSurface;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: resolvedColor.withAlpha(35),
        borderRadius: appBorderRadius,
      ),
      child: Icon(icon, color: color, size: size * 0.55),
    );
  }
}
