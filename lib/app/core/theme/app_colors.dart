import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_controller.dart';

class AppColors {
  AppColors._();

  static bool get _isDark {
    try {
      if (Get.isRegistered<ThemeController>()) {
        return ThemeController.to.isDarkMode;
      }
    } catch (_) {}
    return Get.isDarkMode;
  }

  static Color get primary => _isDark ? const Color(0xFF818CF8) : const Color(0xFF1A237E);
  static Color get secondary => const Color(0xFF2ECC71);
  static Color get tertiary => _isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F7F6);
  static Color get neutral => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF77767D);
  static Color get white => _isDark ? const Color(0xFF1E293B) : Colors.white;
  static Color get black => _isDark ? Colors.white : Colors.black;

  static Color get textPrimary => _isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1A237E);
  static Color get textSecondary => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF77767D);
  static Color get cardBackground => _isDark ? const Color(0xFF1E293B) : Colors.white;
  static Color get scaffoldBackground => _isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F7F6);
  static Color get inputFill => _isDark ? const Color(0xFF1E293B) : Colors.white;

  // Dark Theme Palette Raw Constants
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkPrimary = Color(0xFF818CF8);
}
