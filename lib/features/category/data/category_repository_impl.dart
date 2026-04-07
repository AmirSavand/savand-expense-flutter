import 'package:dio/dio.dart';
import 'package:expense/core/service_locator.dart';
import 'package:expense/features/category/domain/category_repository.dart';
import 'package:expense/features/category/domain/models/category.dart';
import 'package:expense/features/category/domain/models/category_form.dart';

/// Concrete implementation of [CategoryRepository] using Dio.
class CategoryRepositoryImpl implements CategoryRepository {
  Dio get _dio => getIt<Dio>();

  @override
  Future<List<Category>> list(int profileId) async {
    final response = await _dio.get(
      'expense/api/category/',
      queryParameters: {'profile': profileId},
    );
    final data = response.data as List<dynamic>;
    return data
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Category> create(CategoryForm payload) async {
    final response = await _dio.post(
      'expense/api/category/',
      data: payload.toJson(),
    );
    return Category.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Category> update(int id, CategoryForm payload) async {
    final response = await _dio.patch(
      'expense/api/category/$id/',
      data: payload.toJson(),
    );
    return Category.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Category> retrieve(int id) async {
    final response = await _dio.patch('expense/api/category/$id/');
    return Category.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> destroy(int id) async {
    await _dio.delete('expense/api/category/$id/');
  }
}
