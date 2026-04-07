import 'package:expense/features/profile/domain/models/profile.dart';
import 'package:expense/features/profile/domain/models/profile_form.dart';

/// Abstract interface for profile operations.
/// Implemented by [ProfileRepositoryImpl] in the data layer.
abstract class ProfileRepository {
  Future<List<Profile>> list();

  Future<Profile> create(ProfileForm payload);

  Future<Profile> update(int id, ProfileForm payload);

  Future<Profile> retrieve(int id);

  Future<void> destroy(int id);
}
