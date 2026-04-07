import 'package:expense/shared/converters/expense_kind_converter.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required int profile,
    required String name,
    required String color,
    required String icon,
    required bool archive,
    required bool protect,
    @ExpenseKindConverter() required ExpenseKind kind,
    @JsonKey(name: 'transactions_count') required int transactionsCount,
    @JsonKey(name: 'transactions_total') required double transactionsTotal,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
