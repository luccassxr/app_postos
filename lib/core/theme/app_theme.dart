import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF020712), card = Color(0xFF0A1729), field = Color(0xFF0E1D34), primary = Color(0xFF1768FF), success = Color(0xFF25D87A), danger = Color(0xFFFF1830), muted = Color(0xFFA7B1C3), border = Color(0xFF2B3C57);
}

ThemeData buildTheme() => ThemeData(useMaterial3: true, brightness: Brightness.dark, scaffoldBackgroundColor: AppColors.background, colorScheme: const ColorScheme.dark(primary: AppColors.primary, surface: AppColors.card), inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: AppColors.field, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))));
