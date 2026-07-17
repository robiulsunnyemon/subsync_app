import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headline = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.neutral,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral,
  );
}
