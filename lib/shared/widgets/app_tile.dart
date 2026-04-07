import 'package:expense/shared/constants/app_border_radius.dart';
import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final Widget? subtitleWidget;
  final String? trailing;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? tileColor;
  final BorderRadius? borderRadius;
  final CrossAxisAlignment crossAxisAlignment;

  const AppTile({
    super.key,
    this.leading,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.trailingWidget,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.borderRadius,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Handle title widget
    Widget? wTitle = titleWidget;
    if (wTitle == null && title != null) {
      wTitle = Text(
        title!,
        style: TextStyle(fontSize: theme.textTheme.bodyLarge?.fontSize),
      );
    }
    // Handle subtitle widget
    Widget? wSubtitle = subtitleWidget;
    if (wSubtitle == null && subtitle != null) {
      wSubtitle = Text(subtitle!, style: TextStyle(color: theme.hintColor));
    }
    // Handle trailing widget
    Widget? wTrailing = trailingWidget;
    if (wTrailing == null && trailing != null) {
      wTrailing = Text(
        trailing!,
        style: TextStyle(color: theme.hintColor),
        textAlign: TextAlign.end,
      );
    }
    return Material(
      color: tileColor ?? Colors.transparent,
      borderRadius: borderRadius ?? appBorderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        // [ leading ] - [ title, subtitle ] - [ trailing ]
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Row(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 16,
            children: [
              // Leading
              ?leading,
              // Title and subtitle,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Title
                    ?wTitle,
                    // Subtitle
                    ?wSubtitle,
                  ],
                ),
              ),
              // Trailing
              ?wTrailing,
            ],
          ),
        ),
      ),
    );
  }
}
