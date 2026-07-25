import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/settings_provider.dart';
import 'package:get_storage/get_storage.dart' as get_storage;
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';

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
  final profileImage = ''.obs;
  final isUploadingImage = false.obs;

  final ImagePicker _picker = ImagePicker();

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
        profileImage.value = data['profileImage'] ?? '';
      }
    } catch (e) {
      // Silently handle
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

  Future<void> saveProfileDetails({
    required String fullName,
    required String businessNameInput,
    required String vatNumberInput,
  }) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      final response = await _provider.updateProfile({
        'fullName': fullName.trim(),
        'businessName': businessNameInput.trim(),
        'vatNumber': vatNumberInput.trim(),
      });
      Get.back();

      if (response.statusCode == 200) {
        userName.value = fullName.trim();
        businessName.value = businessNameInput.trim();
        vatNumber.value = vatNumberInput.trim();
        CustomSnackbar.showSuccess('Success', 'Profile and business details updated successfully.');
      } else {
        CustomSnackbar.showError('Error', 'Failed to update profile');
      }
    } on DioException catch (e) {
      Get.back();
      String message = e.response?.data['message'] ?? 'Failed to update profile';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      Get.back();
      CustomSnackbar.showError('Error', 'An unexpected error occurred');
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      isUploadingImage.value = true;
      Get.dialog(
        const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Uploading profile image...'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      final response = await _provider.uploadProfileImage(pickedFile.path);
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200 && response.data != null) {
        final String newUrl = response.data['profileImage'] ?? '';
        if (newUrl.isNotEmpty) {
          profileImage.value = newUrl;
        }
        CustomSnackbar.showSuccess('Success', 'Profile picture updated successfully');
      } else {
        CustomSnackbar.showError('Error', 'Failed to upload image');
      }
    } on DioException catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      String message = e.response?.data['message'] ?? 'Failed to upload image';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      CustomSnackbar.showError('Error', 'Failed to select or upload image');
    } finally {
      isUploadingImage.value = false;
    }
  }

  void logout() {
    final box = importGetStorage();
    box.remove('token');
    Get.offAllNamed('/login');
  }

  get_storage.GetStorage importGetStorage() {
    return get_storage.GetStorage();
  }
}
