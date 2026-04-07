import 'package:expense/core/service_locator.dart';
import 'package:expense/core/storage_service.dart';
import 'package:expense/features/category/presentation/providers/category_provider.dart';
import 'package:expense/features/profile/domain/models/profile.dart';
import 'package:expense/features/profile/domain/models/profile_form.dart';
import 'package:expense/features/profile/domain/profile_repository.dart';
import 'package:expense/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:expense/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:expense/shared/exceptions/app_exception.dart';
import 'package:expense/shared/utils/display_error.dart';
import 'package:expense/shared/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logger instance
final _logger = Logger('Profile');

/// Global provider for [ProfileNotifier] exposing [ProfileState].
final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  () => ProfileNotifier(),
);

// State

/// Base class for all possible profile states.
sealed class ProfileState {}

/// Initial state before profiles have been loaded.
class ProfileInitial extends ProfileState {}

/// Emitted while profiles are being fetched for the first time.
class ProfileLoading extends ProfileState {}

/// Emitted when profiles have been successfully loaded.
class ProfileLoaded extends ProfileState {
  final List<Profile> profiles;
  final Profile currentProfile;

  ProfileLoaded({required this.profiles, required this.currentProfile}) {
    _logger.log([
      'Loaded:',
      profiles.length,
      '- Selected:',
      currentProfile.name,
    ]);
  }
}

/// Emitted when profiles are loaded but user has no profiles.
class ProfileEmpty extends ProfileState {}

/// Emitted when a profile operation fails.
class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

// Notifier

/// Manages profile state and handles all CRUD operations in-memory.
///
/// The list is loaded once and kept as a cache. Write operations
/// mutate the in-memory list directly without refetching.
class ProfileNotifier extends Notifier<ProfileState> {
  late final ProfileRepository _repo;
  late final StorageService _storage;

  @override
  ProfileState build() {
    _repo = getIt<ProfileRepository>();
    _storage = getIt<StorageService>();
    return ProfileInitial();
  }

  /// Helper method to save current profile ID to secure storage
  Future<void> _saveCurrentProfileId(int profileId) async {
    try {
      await _storage.profile.write(profileId.toString());
      _logger.log(['Saved current profile ID to storage:', profileId]);
    } catch (e) {
      _logger.log(['Failed to save current profile ID:', e]);
    }
  }

  /// Fetches all profiles and sets [currentProfile] based on:
  /// 1. If state is already loaded, use that profile
  /// 2. Otherwise, try to load saved profile ID from storage
  /// 3. If no valid saved profile exists, use the first profile
  Future<void> initiate() async {
    if (state is! ProfileLoaded) {
      state = ProfileLoading();
    }
    try {
      final profiles = await _repo.list();
      // Check if no profiles
      if (profiles.isEmpty) {
        state = ProfileEmpty();
        return;
      }

      // Determine which profile to use as current
      int? currentProfileId;

      // If state is already loaded, use that profile
      if (state is ProfileLoaded) {
        currentProfileId = (state as ProfileLoaded).currentProfile.id;
      } else {
        // Try to load saved profile ID from secure storage
        final savedProfileId = await _storage.profile.read();
        if (savedProfileId != null) {
          currentProfileId = int.tryParse(savedProfileId);
        }
      }

      // If no valid profile ID found, use first profile's ID
      currentProfileId = currentProfileId ?? profiles.first.id;

      state = ProfileLoaded(
        profiles: profiles,
        currentProfile: profiles.firstWhere(
          (item) => item.id == currentProfileId,
          orElse: () => profiles.first,
        ),
      );
    } catch (e) {
      state = ProfileError(displayError(e));
    }
  }

  /// Creates a new profile from [data] and appends it to the cached list.
  /// - Throws if profiles are not yet loaded.
  Future<Profile> create(ProfileForm data) async {
    final created = await _repo.create(data);
    if (state is ProfileEmpty) {
      state = ProfileLoaded(profiles: [created], currentProfile: created);
    } else {
      final loaded = state as ProfileLoaded;
      state = ProfileLoaded(
        profiles: [...loaded.profiles, created],
        currentProfile: loaded.currentProfile,
      );
    }
    return created;
  }

  /// Updates the profile identified by [id] with [data], replacing the
  /// matching entry in the cached list.
  /// Throws if profiles are not yet loaded.
  Future<Profile> update(int id, ProfileForm data) async {
    final loaded = state as ProfileLoaded;
    final updated = await _repo.update(id, data);
    final profiles = loaded.profiles
        .map((p) => p.id == id ? updated : p)
        .toList();
    state = ProfileLoaded(
      profiles: profiles,
      currentProfile: loaded.currentProfile.id == id
          ? updated
          : loaded.currentProfile,
    );
    return updated;
  }

  /// Deletes the profile identified by [id] and removes it from the cached list.
  /// - Throws if [id] is the active profile.
  /// - Throws if profiles are not loaded.
  Future<void> destroy(int id) async {
    final loaded = state as ProfileLoaded;
    if (loaded.currentProfile.id == id) {
      throw AppException('Cannot delete the active profile.');
    }
    await _repo.destroy(id);
    final profiles = loaded.profiles.where((p) => p.id != id).toList();
    state = ProfileLoaded(
      profiles: profiles,
      currentProfile: loaded.currentProfile,
    );
  }

  /// Switches the active profile to [profile].
  /// Does nothing if profiles are not loaded.
  void select(Profile profile) {
    // Make sure profiles are loaded
    if (state is! ProfileLoaded) {
      _logger.log(['Ignored select() when profiles are not loaded']);
      return;
    }

    final loaded = state as ProfileLoaded;

    // Save the current profile ID
    _saveCurrentProfileId(profile.id);

    // Invalidate all profile related data
    ref.invalidate(walletProvider);
    ref.invalidate(categoryProvider);
    ref.invalidate(transactionListProvider);

    // Update state with the given profile as selected
    state = ProfileLoaded(profiles: loaded.profiles, currentProfile: profile);
  }
}
