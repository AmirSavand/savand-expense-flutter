import 'package:expense/features/auth/presentation/providers/auth_provider.dart';
import 'package:expense/features/profile/presentation/providers/profile_provider.dart';
import 'package:expense/shared/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Entry point screen that restores session and redirects accordingly.
/// Shows a loading indicator while the session check is in progress.
class StartScreen extends ConsumerStatefulWidget {
  const StartScreen({super.key});

  @override
  ConsumerState<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen> {
  /// Logger instance
  final _logger = Logger('Start Screen');

  @override
  void initState() {
    super.initState();

    // Restore authentication session.
    _logger.log(['Restoring auth session']);
    ref.read(authProvider.notifier).restoreSession();

    // Trigger profile load when authenticated
    ref.listenManual(authProvider, (_, next) {
      if (next is AuthAuthenticated) {
        _logger.log(['Authenticated. Initiating profile']);
        ref.read(profileProvider.notifier).initiate();
      }
      if (next is AuthInitial) {
        _logger.log(['Not authenticated. Going to login']);
        context.goNamed('login');
      }
    });

    // Navigate to dash only when profiles are ready
    ref.listenManual(profileProvider, (_, next) {
      if (next is ProfileEmpty) {
        _logger.log(['No profiles.', 'Going to profile list']);
        context.goNamed('profile-list');
      } else if (next is ProfileLoaded) {
        _logger.log(['Has profile.', 'Going to dash']);
        context.goNamed('dash');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Shown briefly while restoreSession resolves.
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
