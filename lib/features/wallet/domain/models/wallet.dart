import 'package:expense/shared/models/balance.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';
part 'wallet.g.dart';

@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    required int id,
    required int profile,
    required String name,
    required String color,
    required String icon,
    required bool archive,
    required int used,
    required Balance balance,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}
