import 'package:expense/shared/constants/app_padding.dart';
import 'package:flutter/material.dart';

class AppCardHeader extends StatelessWidget {
  final String label;
  final String? buttonLabel;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const AppCardHeader({
    super.key,
    required this.label,
    this.buttonLabel,
    this.onTap,
    this.padding = appPaddingH,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).hintColor)),
          if (onTap != null && buttonLabel != null)
            TextButton(onPressed: onTap, child: Text(buttonLabel!)),
        ],
      ),
    );
  }
}
