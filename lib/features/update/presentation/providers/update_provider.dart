import 'package:expense/core/service_locator.dart';
import 'package:expense/features/update/domain/update_repository.dart';
import 'package:expense/shared/utils/display_error.dart';
import 'package:expense/shared/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Global provider for [UpdateNotifier] exposing [UpdateState].
final updateProvider = NotifierProvider<UpdateNotifier, UpdateState>(
  () => UpdateNotifier(),
);

// State

/// Base class for all possible update states.
sealed class UpdateState {}

/// Initial state before any check has been triggered.
class UpdateInitial extends UpdateState {}

/// Emitted while the version check is in progress.
class UpdateChecking extends UpdateState {}

/// Emitted when a newer version is available for download.
class UpdateAvailable extends UpdateState {
  final String version;
  final String url;

  UpdateAvailable({required this.version, required this.url});
}

/// Emitted when the app is already on the latest version.
class UpdateLatest extends UpdateState {}

/// Emitted when the version check fails.
class UpdateError extends UpdateState {
  final String message;

  UpdateError(this.message);
}

// Notifier

/// Checks whether a newer version of the app is available.
class UpdateNotifier extends Notifier<UpdateState> {
  final _logger = Logger('Update');
  late final UpdateRepository _repo;

  @override
  UpdateState build() {
    _repo = getIt<UpdateRepository>();
    return UpdateInitial();
  }

  /// Fetches the latest version and compares it against the installed version.
  Future<void> check() async {
    _logger.log(['Checking for update']);

    // Only check on release, skip in debug to avoid noise during dev
    if (kDebugMode) {
      _logger.log(['Skipping in debug mode']);
      return;
    }

    state = UpdateChecking();
    try {
      final updateInfo = await _repo.fetchLatestVersion();
      final currentVersion = (await PackageInfo.fromPlatform()).version;
      final isAvailable = currentVersion != updateInfo.version;

      if (isAvailable) {
        _logger.log(['New version available:', updateInfo.version]);
        state = UpdateAvailable(
          version: updateInfo.version,
          url: updateInfo.url,
        );
      } else {
        _logger.log(['App is up to date:', currentVersion]);
        state = UpdateLatest();
      }
    } catch (e) {
      // Update check should never crash the app, log and move on
      _logger.log(['Failed to check for update:', displayError(e)]);
      state = UpdateError(displayError(e));
    }
  }
}
