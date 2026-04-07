import 'package:flutter/material.dart';

/// A scrollable widget that takes full height and supports pull-to-refresh.
/// Use this when you have minimal content and want refresh to work anywhere on screen.
class AppScrollableRefresh extends StatelessWidget {
  final List<Widget> children;
  final Future<void> Function() onRefresh;
  final EdgeInsetsGeometry padding;
  final double spacing;

  const AppScrollableRefresh({
    super.key,
    required this.children,
    required this.onRefresh,
    this.padding = const EdgeInsetsGeometry.all(0),
    this.spacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: spacing,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
