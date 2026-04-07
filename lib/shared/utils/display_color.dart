import 'package:flutter/material.dart';

/// Converts a hex color string to a [Color].
/// Example: hexToColor('#827717') → Color(0xFF827717)
Color displayColor(String hex) {
  return Color(int.parse(hex.replaceFirst('#', '0xFF')));
}
