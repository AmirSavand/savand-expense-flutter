import 'package:flutter/material.dart';

Future<bool> showDialogConfirm({
  required BuildContext context,
  required String title,
  required List<String> content,
  VoidCallback? onConfirm,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content.join('\n')),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
            onConfirm?.call();
          },
          child: const Text('Yes'),
        ),
        FilledButton.tonal(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('No'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
