import 'package:dio/dio.dart';
import 'package:expense/core/service_locator.dart';
import 'package:expense/features/profile/domain/models/profile.dart';
import 'package:expense/features/profile/domain/models/profile_form.dart';
import 'package:expense/features/profile/domain/profile_repository.dart';

/// Concrete implementation of [ProfileRepository] using Dio.
class ProfileRepositoryImpl implements ProfileRepository {
  Dio get _dio => getIt<Dio>();

  @override
  Future<List<Profile>> list() async {
    final response = await _dio.get('expense/api/profile/');
    final data = response.data as List<dynamic>;
    return data
        .map((e) => Profile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Profile> create(ProfileForm payload) async {
    final response = await _dio.post(
      'expense/api/profile/',
      data: payload.toJson(),
    );
    return Profile.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Profile> update(int id, ProfileForm payload) async {
    final response = await _dio.patch(
      'expense/api/profile/$id/',
      data: payload.toJson(),
    );
    return Profile.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Profile> retrieve(int id) async {
    final response = await _dio.get('expense/api/profile/$id/');
    return Profile.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> destroy(int id) async {
    await _dio.delete('expense/api/profile/$id/');
  }
}
