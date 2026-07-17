import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        leading: const Icon(Icons.lock_outline, color: AppColors.primary),
        title: const Text('SubSync', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: AppColors.neutral.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: controller.goBack,
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back, size: 16, color: AppColors.neutral),
                          const SizedBox(width: 8),
                          Text('Back to Login', style: AppTextStyles.label),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Forgot Password?', style: AppTextStyles.headline.copyWith(fontSize: 24)),
                    const SizedBox(height: 8),
                    Text('Enter your email address to receive an\nOTP to reset your password', style: AppTextStyles.body),
                    const SizedBox(height: 32),
                    
                    Text('Email Address', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    Obx(() => TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail_outline, color: AppColors.neutral), 
                        hintText: 'name@company.com',
                        errorText: controller.emailError.value,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => controller.emailError.value = null,
                    )),
                    const SizedBox(height: 24),
                    
                    ElevatedButton(
                      onPressed: controller.sendResetLink,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Send OTP'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.secondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Having trouble?', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                              Text('Check your spam folder or contact our\nsupport team at help@subsync.com.', style: AppTextStyles.label.copyWith(fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.refresh, color: AppColors.neutral, size: 20),
                  const SizedBox(width: 16),
                  Icon(Icons.grid_on, color: AppColors.neutral.withOpacity(0.5), size: 20),
                  const SizedBox(width: 16),
                  Icon(Icons.security, color: AppColors.neutral.withOpacity(0.5), size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Text('© 2024 SubSync Financial Solutions. European Union\nCompliant.', textAlign: TextAlign.center, style: AppTextStyles.label.copyWith(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
