import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

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
                          Text('Back', style: AppTextStyles.label),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Reset Password', style: AppTextStyles.headline.copyWith(fontSize: 24)),
                    const SizedBox(height: 8),
                    Text('Enter your new password to reset it.', style: AppTextStyles.body),
                    const SizedBox(height: 32),
                    
                    Text('New Password', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    Obx(() => TextField(
                      controller: controller.newPasswordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.neutral), 
                        hintText: '********',
                        errorText: controller.passwordError.value,
                      ),
                      obscureText: true,
                      onChanged: (_) => controller.passwordError.value = null,
                    )),
                    const SizedBox(height: 24),
                    
                    ElevatedButton(
                      onPressed: controller.resetPassword,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Reset Password'),
                          SizedBox(width: 8),
                          Icon(Icons.check_circle_outline),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text('© 2024 SubSync Financial Solutions. European Union\nCompliant.', textAlign: TextAlign.center, style: AppTextStyles.label.copyWith(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
