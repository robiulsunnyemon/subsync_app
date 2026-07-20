import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/settings_provider.dart';
import 'package:get_storage/get_storage.dart' as get_storage;
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';

class SettingsController extends GetxController {
  
  final SettingsProvider _provider = SettingsProvider();

  // Notification Settings
  final emailEnabled = true.obs;
  final pushEnabled = false.obs;
  final reminderDays = '3 Days'.obs;
  
  // Account Profile
  final userName = ''.obs;
  final userEmail = ''.obs;
  final businessName = ''.obs;
  final vatNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await _provider.getProfile();
      if (response.statusCode == 200) {
        final data = response.data;
        userName.value = data['fullName'] ?? '';
        userEmail.value = data['email'] ?? '';
        businessName.value = data['businessName'] ?? '';
        vatNumber.value = data['vatNumber'] ?? '';
      }
    } catch (e) {
      // Silently fail for now if profile doesn't load
    }
  }

  void toggleEmail(bool value) {
    emailEnabled.value = value;
  }

  void togglePush(bool value) {
    pushEnabled.value = value;
  }

  void setReminderDays(String days) {
    reminderDays.value = days;
  }
  
  void navigateToNotifications() {
    Get.toNamed('/settings/notifications');
  }

  void saveSettings() async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await _provider.updateProfile({
        'fullName': userName.value,
        'businessName': businessName.value,
        'vatNumber': vatNumber.value
      });
      Get.back();
      CustomSnackbar.showSuccess('Saved', 'Your settings have been updated.');
    } on DioException catch (e) {
      Get.back();
      String message = e.response?.data['message'] ?? 'Failed to update profile';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      Get.back();
      CustomSnackbar.showError('Error', 'An unexpected error occurred');
    }
  }

  void logout() {
    // Clear local token and navigate to login
    final box = importGetStorage();
    box.remove('token');
    Get.offAllNamed('/login');
  }

  get_storage.GetStorage importGetStorage() {
    return get_storage.GetStorage();
  }
}
