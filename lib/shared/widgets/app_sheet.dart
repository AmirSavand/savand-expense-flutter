import 'package:flutter/material.dart';

class AppSheet extends StatelessWidget {
  final List<Widget> children;
  final String title;

  final double _spacing = 32;

  const AppSheet({super.key, required this.children, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.viewInsetsOf(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: mediaQuery.bottom + _spacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: _spacing / 2,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: _spacing),
              child: Text(title, style: theme.textTheme.titleLarge),
            ),
            // Space
            const SizedBox(),
            ...children,
          ],
        ),
      ),
    );
  }
}
