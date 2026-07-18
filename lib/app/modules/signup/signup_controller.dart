import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/routes/app_pages.dart';
import 'package:subsync/app/data/providers/auth_provider.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    debugPrint("Starting Google Sign In...");
    try {
      final googleSignIn = GoogleSignIn(
        clientId: const String.fromEnvironment('GOOGLE_ANDROID_CLIENT_ID'),
        serverClientId: const String.fromEnvironment('GOOGLE_CLIENT_ID'),
      );
      final account = await googleSignIn.signIn();
      
      if (account != null) {
        debugPrint("Google Sign In Account: ${account.email}");
        final auth = await account.authentication;
        debugPrint("Google Auth Token fetched, ID Token: ${auth.idToken != null ? "EXISTS (len: ${auth.idToken!.length})" : "NULL"}");
        
        if (auth.idToken != null) {
          debugPrint("Sending token to backend...");
          final response = await _authProvider.socialLogin(auth.idToken!, 'GOOGLE');
          debugPrint("Backend response: ${response.statusCode} - ${response.data}");
          
          if (response.statusCode == 200) {
            CustomSnackbar.showSuccess('Success', 'Google Login successful');
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          debugPrint("ID Token is null!");
          CustomSnackbar.showError('Error', 'Failed to get ID token from Google');
        }
      } else {
        debugPrint("Google Sign In Account is null (User cancelled?)");
      }
    } catch (e, stackTrace) {
      debugPrint("Google Sign In Error: $e");
      debugPrint("Stacktrace: $stackTrace");
      String errorMessage = 'Google Login Failed';
      if (e is DioException && e.response?.data != null) {
        debugPrint("Dio Error Response: ${e.response?.data}");
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        }
      }
      CustomSnackbar.showError('Login Failed', errorMessage);
    } finally {
      isLoading.value = false;
      debugPrint("Google Sign In process finished.");
    }
  }
}
