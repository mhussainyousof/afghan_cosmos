import 'package:flutter/material.dart';

class TColors {
  // App theme colors
  static const Color primary = Color(0xFF0A74BF); // Afghan Cosmos brand blue
  static const Color secondary = Color(0xFFFFA500); // Accent orange
  static const Color accent = Color(0xFF5EA9DD); // Lighter version of primary

  // Text colors
  static const Color textPrimary = Color(0xFF1F1F1F); // Deep grey
  static const Color textSecondary = Color(0xFF5F6F81); // Softer grey
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color light = Color(0xFFF4F8FB); // Soft blue-tinted background
  static const Color dark = Color(0xFF121212); // For dark mode
  static const Color primaryBackground = Color(0xFFEAF4FB); // Very soft brand-tinted bg

  // Container background colors
  static const Color lightContainer = Color(0xFFFFFFFF); // White cards
  static Color darkContainer = Colors.white.withOpacity(0.05); // Low-opacity white for dark mode

  // Button colors
  static const Color buttonPrimary = Color(0xFF0A74BF); // Matches brand
  static const Color buttonSecondary = Color(0xFFADBBC4); // Soft bluish-grey
  static const Color buttonDisabled = Color(0xFFDDE4EA); // Very light blue-grey

  // Border colors
  static const Color borderPrimary = Color(0xFFCBD6E2); // Light blue-grey
  static const Color borderSecondary = Color(0xFFEAF0F6); // Almost white-blue

  // Error and validation colors
  static const Color error = Color(0xFFE63946); // Red for errors
  static const Color success = Color(0xFF2CA58D); // Calm green
  static const Color warning = Color(0xFFFFB703); // Golden yellow
  static const Color info = Color(0xFF219EBC); // Friendly sky blue

  // Neutral shades
  static const Color black = Color(0xFF000000);
  static const Color darkerGrey = Color(0xFF343A40);
  static const Color darkGrey = Color(0xFF6C757D);
  static const Color grey = Color(0xFFDDE2E5);
  static const Color softGrey = Color(0xFFF5F5F5);
  static const Color lightGrey = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
}
