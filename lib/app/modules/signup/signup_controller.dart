import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/routes/app_pages.dart';
import 'package:subsync/app/data/providers/auth_provider.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';
import 'package:dio/dio.dart';

class SignupController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final agreeToTerms = false.obs;
  final isLoading = false.obs;
  
  final AuthProvider _authProvider = AuthProvider();

  final fullNameError = RxnString();
  final emailError = RxnString();
  final passwordError = RxnString();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  void toggleTerms(bool? value) {
    agreeToTerms.value = value ?? false;
  }

  Future<void> signUp() async {
    if(!agreeToTerms.value) {
      CustomSnackbar.showError('Error', 'Please agree to the Terms of Service');
      return;
    }
    
    fullNameError.value = null;
    emailError.value = null;
    passwordError.value = null;

    bool hasError = false;
    if(fullNameController.text.isEmpty) {
      fullNameError.value = 'Full name is required';
      hasError = true;
    }
    if(emailController.text.isEmpty) {
      emailError.value = 'Email is required';
      hasError = true;
    }
    if(passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      hasError = true;
    }

    if(hasError) return;

    isLoading.value = true;
    try {
      final response = await _authProvider.register(
        fullNameController.text,
        emailController.text, 
        passwordController.text
      );
      
      if(response.statusCode == 200) {
        CustomSnackbar.showSuccess('Success', 'OTP sent to your email');
        Get.toNamed(Routes.OTP, arguments: emailController.text);
      }
    } catch (e) {
      String errorMessage = 'Error creating account. Email may exist.';
      if (e is DioException && e.response?.data != null) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        }
      }
      CustomSnackbar.showError('Registration Failed', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.back();
  }
}
