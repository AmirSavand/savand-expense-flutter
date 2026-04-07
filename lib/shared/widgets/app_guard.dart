import 'package:flutter/material.dart';

/// Safety guard for screens that require app state to be available.
/// Should never be visible to the user under normal circumstances.
class AppGuard extends StatelessWidget {
  final bool forSheet;

  const AppGuard({super.key, this.forSheet = false});

  @override
  Widget build(BuildContext context) {
    if (forSheet) {
      return Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: LinearProgressIndicator(),
      );
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
