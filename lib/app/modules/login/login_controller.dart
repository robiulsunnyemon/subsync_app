import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/routes/app_pages.dart';
import 'package:subsync/app/data/providers/auth_provider.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';
import 'package:dio/dio.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  
  final AuthProvider _authProvider = AuthProvider();

  final emailError = RxnString();
  final passwordError = RxnString();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    emailError.value = null;
    passwordError.value = null;

    bool hasError = false;
    if(emailController.text.isEmpty) {
      emailError.value = 'Email is required';
      hasError = true;
    }
    if(passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      hasError = true;
    }

    if (hasError) return;
    
    isLoading.value = true;
    try {
      final response = await _authProvider.login(
        emailController.text, 
        passwordController.text
      );
      
      if(response.statusCode == 200) {
        // Handle token storage here
        CustomSnackbar.showSuccess('Success', 'Login successful');
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      String errorMessage = 'Invalid credentials or server error';
      if (e is DioException && e.response?.data != null) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        }
      }
      CustomSnackbar.showError('Login Failed', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignUp() {
    Get.toNamed(Routes.SIGNUP);
  }

  void goToForgotPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }
}
