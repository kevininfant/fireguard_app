import 'package:flutter/material.dart';

/// Industrial FireGuard Dark & Safety Color System
class AppColors {
  AppColors._();

  // Dark Surface Containers
  static const Color darkBackground = Color(0xFF131313);
  static const Color darkSurface = Color(0xFF131313);
  static const Color surfaceContainerLowest = Color(0xFF141414);
  static const Color surfaceContainerLow = Color(0xFF1C1B1B);
  static const Color surfaceContainer = Color(0xFF201F1F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceContainerHighest = Color(0xFF353534);
  static const Color surfaceBright = Color(0xFF393939);

  // Industrial Accent Palette
  static const Color industrialOrange = Color(0xFFFF6B00);
  static const Color onIndustrialOrange = Color(0xFF561F00);
  static const Color industrialOrangeDim = Color(0xFFFFB693);

  // Safety & Hazard Indicators
  static const Color safetyRed = Color(0xFFA40213);
  static const Color onSafetyRed = Color(0xFF680008);
  static const Color safetyRedDim = Color(0xFFFFB3AC);

  // Compliance & Gold Badges
  static const Color industrialGold = Color(0xFFE9C400);
  static const Color goldYellow = Color(0xFFFFD700);
  static const Color onIndustrialGold = Color(0xFF3A3000);

  // Text Colors
  static const Color onSurfaceText = Color(0xFFE5E2E1);
  static const Color onSurfaceVariantText = Color(0xFFE2BFB0);
  static const Color textMuted = Color(0xFF9E9E9E);

  // Outlines & Borders
  static const Color outlineColor = Color(0xFFA98A7D);
  static const Color outlineVariantColor = Color(0xFF5A4136);

  // Success & Status
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFF4CAF50);
  static const Color infoBlue = Color(0xFF2196F3);

  // Aliases for compatibility
  static const Color primary = industrialOrange;
  static const Color primaryDark = onIndustrialOrange;
  static const Color secondary = industrialGold;
  static const Color accent = goldYellow;
  static const Color background = darkBackground;
  static const Color surface = surfaceContainer;
  static const Color error = safetyRed;
}
