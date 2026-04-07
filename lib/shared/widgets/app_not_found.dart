import 'package:expense/shared/widgets/app_app_bar.dart';
import 'package:flutter/material.dart';

/// Shown when a detail screen cannot find its record, e.g. stale route or
/// deleted item. Allows the user to navigate back.
class AppNotFound extends StatelessWidget {
  const AppNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Not Found'),
      body: const Center(
        child: Text('This record does not exist or has been deleted.'),
      ),
    );
  }
}
