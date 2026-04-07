import 'package:expense/features/profile/domain/models/profile.dart';
import 'package:expense/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current selected profile reference.
final currentProfileProvider = Provider<Profile?>((ref) {
  final state = ref.watch(profileProvider);
  if (state is ProfileLoaded) {
    return state.currentProfile;
  }
  return null;
});
