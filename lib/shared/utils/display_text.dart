/// Returns [text] if it is non-null and non-empty after trimming,
/// otherwise returns [fallback].
String displayText(String? text, {String fallback = 'Nothing here'}) {
  final trimmed = text?.trim();
  if (trimmed != null && trimmed.isNotEmpty) {
    return trimmed;
  }
  return fallback;
}
