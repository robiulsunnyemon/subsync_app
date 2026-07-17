import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/data/providers/auth_provider.dart';
import 'package:subsync/app/routes/app_pages.dart';
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final AuthProvider _authProvider = AuthProvider();
  
  final emailError = RxnString();

  void sendResetLink() async {
    String email = emailController.text.trim();
    
    emailError.value = null;
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await _authProvider.forgotPassword(email);
      Get.back(); // close dialog
      
      CustomSnackbar.showSuccess('Success', 'OTP sent to your email');
      Get.toNamed(Routes.OTP, arguments: {'email': email, 'isForgotPassword': true});
    } on DioException catch (e) {
      Get.back(); // close dialog
      String message = e.response?.data['message'] ?? 'Failed to send OTP';
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
