import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppGlowDetail extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String? mainText;
  final String? topText;
  final String? bottomText;

  const AppGlowDetail({
    super.key,
    required this.color,
    required this.icon,
    this.mainText,
    this.topText,
    this.bottomText,
  });

  static Widget loading(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: Colors.transparent,
      highlightColor: theme.colorScheme.surfaceBright,
      child: AppGlowDetail(
        color: theme.colorScheme.secondary.withAlpha(60),
        icon: Icons.circle,
        mainText: '---',
        topText: '---',
        bottomText: '---',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      heightFactor: 2,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: color.withAlpha(50), blurRadius: 64)],
        ),
        child: Column(
          spacing: 16,
          children: [
            // Icon with glow color
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(64),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            // Top text
            if (topText != null)
              Text(
                topText!.toUpperCase(),
                style: TextStyle(
                  fontSize: theme.textTheme.bodySmall?.fontSize,
                  color: theme.hintColor,
                  letterSpacing: 4,
                ),
              ),
            // Main text
            if (mainText != null)
              Text(
                mainText!,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            // Bottom text
            if (bottomText != null)
              Text(
                bottomText!,
                style: TextStyle(
                  fontSize: theme.textTheme.bodySmall?.fontSize,
                  color: theme.hintColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
