import 'dart:async';

import 'package:expense/core/dio_client.dart';
import 'package:expense/core/router.dart';
import 'package:expense/core/service_locator.dart';
import 'package:expense/core/theme.dart';
import 'package:expense/features/auth/presentation/providers/auth_provider.dart';
import 'package:expense/features/update/presentation/providers/update_provider.dart';
import 'package:expense/shared/widgets/app_scroll_behaviour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/update/presentation/widgets/update_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription? _jwtExpireSubscription;

  /// Watch JWT expire event to log user out and show snackbar.
  void handleJwtExpire() {
    _jwtExpireSubscription = onJwtExpire.stream.listen((_) async {
      // Logout (from auth)
      await ref.read(authProvider.notifier).logout();
      // Use the navigator context since MyApp's own context is above the
      // widget tree.
      final context = appRouter.routerDelegate.navigatorKey.currentContext;
      if (context == null || !context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please log in again.'),
          ),
        );
    });
  }

  /// Watch update for available state to show dialog.
  void handleUpdateAvailable() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(updateProvider.notifier).check();
    });
    ref.listenManual(updateProvider, (_, next) {
      if (next is! UpdateAvailable) {
        return;
      }
      final context = appRouter.routerDelegate.navigatorKey.currentContext;
      if (context == null || !context.mounted) {
        return;
      }
      UpdateSheet.show(context, next);
    });
  }

  @override
  void initState() {
    super.initState();
    handleUpdateAvailable();
    handleJwtExpire();
  }

  @override
  void dispose() {
    _jwtExpireSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Savand Expense',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      scrollBehavior: AppScrollBehavior(),
      routerConfig: appRouter,
    );
  }
}
