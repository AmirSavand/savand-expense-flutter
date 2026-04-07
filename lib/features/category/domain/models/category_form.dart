import 'package:expense/shared/converters/expense_kind_converter.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_form.freezed.dart';
part 'category_form.g.dart';

@freezed
abstract class CategoryForm with _$CategoryForm {
  const factory CategoryForm({
    required int profile,
    @ExpenseKindConverter() required ExpenseKind kind,
    required String name,
    required String color,
    required String icon,
    required String? note,
    required bool? archived,
  }) = _CategoryForm;

  factory CategoryForm.fromJson(Map<String, dynamic> json) =>
      _$CategoryFormFromJson(json);
}
