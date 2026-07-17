import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/routes/app_pages.dart';

import 'package:dio/dio.dart';
import 'package:subsync/app/data/providers/auth_provider.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';

class OtpController extends GetxController {
  final otpControllers = List.generate(4, (_) => TextEditingController());
  final focusNodes = List.generate(4, (_) => FocusNode());
  final AuthProvider _authProvider = AuthProvider();
  
  late String email;
  final otpError = RxnString();
  late bool isForgotPassword;
  final countdownTime = 120.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      email = args['email'] ?? '';
      isForgotPassword = args['isForgotPassword'] ?? false;
    } else {
      email = args ?? '';
      isForgotPassword = false;
    }
    
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email not found', backgroundColor: Colors.red, colorText: Colors.white);
      Get.offAllNamed(Routes.LOGIN);
    } else {
      startTimer();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }

  void startTimer() {
    countdownTime.value = 120;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownTime.value > 0) {
        countdownTime.value--;
      } else {
        timer.cancel();
      }
    });
  }

  String get formattedTime {
    int minutes = countdownTime.value ~/ 60;
    int seconds = countdownTime.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get maskedEmail {
    if (email.isEmpty || !email.contains('@')) return email;
    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];
    
    if (name.length <= 2) {
      return '${name[0]}***@$domain';
    }
    return '${name.substring(0, 2)}***@$domain';
  }

  void resendOtp() async {
    if (countdownTime.value > 0) return;

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      if (isForgotPassword) {
        await _authProvider.forgotPassword(email);
      } else {
        await _authProvider.resendOtp(email);
      }
      
      Get.back(); // close dialog
      
      CustomSnackbar.showSuccess('Success', 'OTP has been resent');
      startTimer();
    } catch (e) {
      Get.back();
      CustomSnackbar.showError('Error', 'Failed to resend OTP');
    }
  }
  
  void verify() async {
    String otp = otpControllers.map((c) => c.text).join();
    otpError.value = null;

    if (otp.length < 4) {
      otpError.value = 'Please enter the 4-digit code';
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      if (isForgotPassword) {
        final response = await _authProvider.verifyResetOtp(email, otp);
        Get.back(); // close dialog
        if (response.statusCode == 200) {
          String token = response.data['token'];
          Get.toNamed(Routes.RESET_PASSWORD, arguments: {'token': token});
        }
      } else {
        final response = await _authProvider.verifyOtp(email, otp);
        Get.back(); // close dialog
        if (response.statusCode == 200) {
          CustomSnackbar.showSuccess('Success', 'Email verified successfully');
          Get.offAllNamed(Routes.LOGIN);
        }
      }
    } on DioException catch (e) {
      Get.back(); // close dialog
      String message = e.response?.data['message'] ?? 'Failed to verify OTP';
      CustomSnackbar.showError('Verification Failed', message);
    } catch (e) {
      Get.back();
      CustomSnackbar.showError('Error', 'An unexpected error occurred');
    }
  }
  
  void goBack() {
    Get.back();
  }
}
