import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.info, color: Colors.white),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
