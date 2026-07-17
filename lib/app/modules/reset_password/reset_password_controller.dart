import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/auth_provider.dart';
import 'package:subsync/app/routes/app_pages.dart';
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final AuthProvider _authProvider = AuthProvider();
  
  late String token;

  @override
  void onInit() {
    super.onInit();
    token = Get.arguments?['token'] ?? '';
    if (token.isEmpty) {
      Get.snackbar('Error', 'Invalid access token. Please try again.', backgroundColor: Colors.red, colorText: Colors.white);
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  final passwordError = RxnString();

  void resetPassword() async {
    String newPassword = newPasswordController.text;
    
    passwordError.value = null;

    if (newPassword.isEmpty) {
      passwordError.value = 'New password is required';
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await _authProvider.resetPassword(token, newPassword);
      Get.back(); // close dialog
      
      CustomSnackbar.showSuccess('Success', 'Password has been reset successfully');
      Get.offAllNamed(Routes.LOGIN);
    } on DioException catch (e) {
      Get.back(); // close dialog
      String message = e.response?.data['message'] ?? 'Failed to reset password';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      Get.back();
      CustomSnackbar.showError('Error', 'An unexpected error occurred');
    }
  }

  void goBack() {
    Get.back();
  }
}
