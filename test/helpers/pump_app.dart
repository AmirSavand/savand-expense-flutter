import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_providers.dart';

/// Wraps [child] with [MaterialApp] and [Scaffold] so that theme,
/// directionality, and media query are available in widget tests.
Future<void> pumpApp(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
}

/// Wraps a widget with ProviderScope and MaterialApp for Riverpod widget
/// tests. Use this for testing widgets that depend on providers.
Future<void> pumpRiverpodWidget(
  WidgetTester tester,
  Widget child, {
  List<Override>? overrides,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides ?? standardOverrides,
      child: MaterialApp(home: Scaffold(body: child)),
    ),
  );
}
