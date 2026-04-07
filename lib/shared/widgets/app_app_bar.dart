import 'package:expense/core/router.dart';
import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    final leading = Navigator.of(context).canPop()
        ? BackButton()
        : IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => rootScaffoldKey.currentState?.openDrawer(),
          );
    return AppBar(leading: leading, title: Text(title), actions: actions);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
