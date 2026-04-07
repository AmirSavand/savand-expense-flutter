import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_form.freezed.dart';
part 'profile_form.g.dart';

@freezed
abstract class ProfileForm with _$ProfileForm {
  const factory ProfileForm({
    required String name,
    required String currency,
    required String? note,
  }) = _ProfileForm;

  factory ProfileForm.fromJson(Map<String, dynamic> json) =>
      _$ProfileFormFromJson(json);
}
