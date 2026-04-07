import 'package:expense/shared/models/balance.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required int id,
    required String name,
    required String? note,
    required String currency,
    required Balance balance,
    required int karma,
    required int level,
    @JsonKey(name: 'next_level_karma') required int nextLevelKarma,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
