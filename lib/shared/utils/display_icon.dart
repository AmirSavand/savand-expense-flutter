import 'package:expense/shared/constants/app_icons.dart';
import 'package:flutter/material.dart';

/// Maps a backend icon string key to the closest Material [IconData].
/// Falls back to [Icons.circle_outlined] for unknown keys.
IconData displayIcon(String key) {
  return appIcons[key] ?? Icons.circle_outlined;
}
