import 'package:expense/core/router.dart';
import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double? scrolledUnderElevation;
  final double? elevation;
  final Color? backgroundColor;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
    this.scrolledUnderElevation,
    this.elevation,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final leading = Navigator.of(context).canPop()
        ? BackButton()
        : IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => rootScaffoldKey.currentState?.openDrawer(),
          );
    return AppBar(
      leading: leading,
      title: Text(title),
      actions: actions,
      bottom: bottom,
      scrolledUnderElevation: scrolledUnderElevation,
      elevation: elevation,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
