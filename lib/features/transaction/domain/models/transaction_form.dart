import 'package:expense/shared/converters/expense_kind_converter.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_form.freezed.dart';
part 'transaction_form.g.dart';

@freezed
abstract class TransactionForm with _$TransactionForm {
  const factory TransactionForm({
    required int wallet,
    @ExpenseKindConverter() required ExpenseKind kind,
    required String amount,
    required DateTime time,
    int? into,
    int? category,
    int? event,
    @Default([]) List<int> tags,
    @Default('') String note,
    @Default(false) bool archive,
    @Default(false) bool exclude,
  }) = _TransactionForm;

  factory TransactionForm.fromJson(Map<String, dynamic> json) =>
      _$TransactionFormFromJson(json);
}
