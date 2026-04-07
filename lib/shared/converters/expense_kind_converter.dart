import 'package:expense/shared/enums/expense_kind.dart';
import 'package:json_annotation/json_annotation.dart';

/// JsonConverter for ExpenseKind ↔ int, for use in freezed models.
class ExpenseKindConverter implements JsonConverter<ExpenseKind, int> {
  const ExpenseKindConverter();

  @override
  ExpenseKind fromJson(int value) => ExpenseKind.fromValue(value);

  @override
  int toJson(ExpenseKind kind) => kind.value;
}
