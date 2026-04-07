import 'package:expense/shared/converters/double_converter.dart';
import 'package:expense/shared/converters/expense_kind_converter.dart';
import 'package:expense/shared/enums/expense_kind.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required int wallet,
    required int? into,
    required int category,
    required int? event,
    required List<int> tags,
    @ExpenseKindConverter() required ExpenseKind kind,
    @DoubleConverter() required double amount,
    required String? note,
    required DateTime time,
    required bool archive,
    required bool exclude,
    required DateTime created,
    required DateTime updated,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
