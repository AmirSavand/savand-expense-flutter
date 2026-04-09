import 'package:expense/shared/utils/display_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData _build(ThemeData base) =>
    base.copyWith(textTheme: GoogleFonts.ubuntuTextTheme(base.textTheme));

final lightTheme = _build(ThemeData.light(useMaterial3: true));
final darkTheme = _build(ThemeData.dark(useMaterial3: true));

class ThemeColors {
  static final success = displayColor('#27ae60');
  static final danger = displayColor('#e74c3c');

  static final income = ThemeColors.success;
  static final expense = ThemeColors.danger;
}
