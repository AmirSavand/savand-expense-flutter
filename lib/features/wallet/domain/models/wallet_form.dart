import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_form.freezed.dart';
part 'wallet_form.g.dart';

@freezed
abstract class WalletForm with _$WalletForm {
  const factory WalletForm({
    required int profile,
    required String name,
    required String color,
    required String icon,
    @JsonKey(name: 'initial_balance') required double initialBalance,
    required String? note,
    required bool? archived,
  }) = _WalletForm;

  factory WalletForm.fromJson(Map<String, dynamic> json) =>
      _$WalletFormFromJson(json);
}
