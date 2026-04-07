import 'package:expense/features/category/domain/models/category.dart';
import 'package:expense/features/category/domain/models/category_form.dart';

/// Abstract interface for category operations.
/// Implemented by [CategoryRepositoryImpl] in the data layer.
abstract class CategoryRepository {
  Future<List<Category>> list(int profileId);

  Future<Category> create(CategoryForm payload);

  Future<Category> update(int id, CategoryForm payload);

  Future<Category> retrieve(int id);

  Future<void> destroy(int id);
}
