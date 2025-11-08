import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF6A4C93),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
