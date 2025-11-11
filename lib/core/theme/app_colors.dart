import 'package:flutter/material.dart';

/// Application color palette based on ScoutMena brand
class AppColors {
  // Primary Brand Colors
  static const Color scoutBlue = Color(0xFF3B82F6);
  static const Color scoutGreen = Color(0xFF10B981);
  static const Color scoutOrange = Color(0xFFF59E0B);

  // Primary Colors
  static const Color primary = scoutBlue;
  static const Color primaryDark = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF60A5FA);

  // Secondary Colors
  static const Color secondary = scoutGreen;
  static const Color secondaryDark = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF34D399);

  // Accent Colors
  static const Color accent = scoutOrange;
  static const Color accentDark = Color(0xFFD97706);
  static const Color accentLight = Color(0xFFFBBF24);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF1F2937);
  static const Color surface = Colors.white;
  static const Color surfaceDark = Color(0xFF374151);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textInverse = Colors.white;

  // Role-Specific Colors
  static const Color playerPrimary = scoutBlue;
  static const Color scoutPrimary = scoutGreen;
  static const Color parentPrimary = scoutOrange;
  static const Color adminPrimary = Color(0xFF8B5CF6);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF4B5563);
  static const Color divider = Color(0xFFE5E7EB);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [scoutBlue, Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [scoutGreen, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);

  AppColors._();
}
