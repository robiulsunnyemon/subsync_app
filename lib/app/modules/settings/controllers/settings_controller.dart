import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/settings_provider.dart';
import 'package:get_storage/get_storage.dart' as get_storage;
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:subsync/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:subsync/app/modules/tax_report/controllers/tax_report_controller.dart';
import 'package:subsync/app/core/theme/app_colors.dart';

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
        
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().fetchDashboardData();
        }
        if (Get.isRegistered<TaxReportController>()) {
          Get.find<TaxReportController>().fetchReport();
        }
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

  Future<void> pickCropAndPreviewImage(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickedFile == null) return;

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop & Position Profile Photo',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            cropStyle: CropStyle.circle,
          ),
          IOSUiSettings(
            title: 'Crop & Position Profile Photo',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) return;

      // Show Live Preview Dialog before uploading
      if (context.mounted) {
        _showPreviewDialog(context, File(croppedFile.path));
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to pick or crop image');
    }
  }

  void _showPreviewDialog(BuildContext context, File imageFile) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Profile Photo Preview',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              SizedBox(height: 6.h),
              Text(
                'Here is how your cropped avatar will look on your profile & dashboard:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.sp, color: AppColors.neutral),
              ),
              SizedBox(height: 20.h),
              
              // Live Avatar Preview
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2.5),
                ),
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundColor: AppColors.tertiary,
                  backgroundImage: FileImage(imageFile),
                ),
              ),
              
              SizedBox(height: 24.h),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.back();
                        pickCropAndPreviewImage(context);
                      },
                      icon: Icon(Icons.crop_outlined, size: 16.sp, color: AppColors.primary),
                      label: Text('Re-crop', style: TextStyle(color: AppColors.primary, fontSize: 12.sp)),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        _uploadCroppedImage(imageFile.path);
                      },
                      icon: Icon(Icons.check, size: 16.sp, color: Colors.white),
                      label: Text('Upload & Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _uploadCroppedImage(String filePath) async {
    try {
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

      final response = await _provider.uploadProfileImage(filePath);
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200 && response.data != null) {
        final String newUrl = response.data['profileImage'] ?? '';
        if (newUrl.isNotEmpty) {
          profileImage.value = newUrl;
        }
        CustomSnackbar.showSuccess('Success', 'Profile picture updated successfully');

        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().fetchDashboardData();
        }
        if (Get.isRegistered<TaxReportController>()) {
          Get.find<TaxReportController>().fetchReport();
        }
      } else {
        CustomSnackbar.showError('Error', 'Failed to upload image');
      }
    } on DioException catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      String message = e.response?.data['message'] ?? 'Failed to upload image';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      CustomSnackbar.showError('Error', 'Failed to upload image');
    } finally {
      isUploadingImage.value = false;
    }
  }

  void saveSettings() {
    CustomSnackbar.showSuccess('Saved', 'Notification preferences saved successfully.');
    Get.back();
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
