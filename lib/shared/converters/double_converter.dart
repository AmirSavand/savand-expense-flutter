import 'package:json_annotation/json_annotation.dart';

/// JsonConverter for double ↔ String, for use in freezed models.
/// Parses [String] to [double], returning 0 on null or parse failure.
class DoubleConverter implements JsonConverter<double, dynamic> {
  const DoubleConverter();

  @override
  double fromJson(dynamic value) => double.tryParse(value.toString()) ?? 0;

  @override
  String toJson(double value) => value.toString();
}
