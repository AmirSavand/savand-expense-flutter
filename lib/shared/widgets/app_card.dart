import 'package:expense/shared/constants/app_shape.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final List<Widget>? children;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double childrenSpacing;

  const AppCard({
    super.key,
    this.children,
    this.child,
    this.margin,
    this.padding,
    this.childrenSpacing = 0,
  }) : assert(children != null || child != null, 'Provide children or child');

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsetsGeometry.all(0),
      shape: appShape,
      child: Padding(
        padding: padding ?? EdgeInsetsGeometry.all(16),
        child:
            child ??
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: childrenSpacing,
              children: children!,
            ),
      ),
    );
  }
}
