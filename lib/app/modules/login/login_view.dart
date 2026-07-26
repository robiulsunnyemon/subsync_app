import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'package:subsync/app/core/constants/app_constants.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        title: Text(AppConstants.appName, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: AppSizes.font20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: AppColors.primary, size: AppSizes.iconMedium),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSizes.gapH20,
              Icon(Icons.laptop_mac_rounded, size: 60.w, color: AppColors.primary),
              AppSizes.gapH24,
              Text(
                'Welcome Back',
                style: AppTextStyles.headline.copyWith(fontSize: 28.sp),
                textAlign: TextAlign.center,
              ),
              AppSizes.gapH8,
              Text(
                'Manage your recurring costs with ease.',
                style: AppTextStyles.body.copyWith(fontSize: AppSizes.font16),
                textAlign: TextAlign.center,
              ),
              AppSizes.gapH40,
              Text('Email Address', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font12)),
              AppSizes.gapH8,
              Obx(() => TextField(
                controller: controller.emailController,
                style: TextStyle(fontSize: AppSizes.font14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline, color: AppColors.neutral, size: AppSizes.iconMedium),
                  hintText: 'name@company.com',
                  errorText: controller.emailError.value,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => controller.emailError.value = null,
              )),
              AppSizes.gapH20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Password', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font12)),
                  GestureDetector(
                    onTap: controller.goToForgotPassword,
                    child: Text('Forgot Password?', style: AppTextStyles.label.copyWith(color: AppColors.primary, fontSize: AppSizes.font12)),
                  ),
                ],
              ),
              AppSizes.gapH8,
              Obx(() => TextField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                style: TextStyle(fontSize: AppSizes.font14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.neutral, size: AppSizes.iconMedium),
                  hintText: '********',
                  errorText: controller.passwordError.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.neutral,
                      size: AppSizes.iconMedium,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
                onChanged: (_) => controller.passwordError.value = null,
              )),
              AppSizes.gapH32,
              ElevatedButton(
                onPressed: controller.login,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign In', style: TextStyle(fontSize: AppSizes.font16)),
                    AppSizes.gapW8,
                    Icon(Icons.arrow_forward, size: AppSizes.iconMedium),
                  ],
                ),
              ),
              AppSizes.gapH32,
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.neutral.withValues(alpha: 0.3))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                    child: Text('OR CONTINUE WITH', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font10)),
                  ),
                  Expanded(child: Divider(color: AppColors.neutral.withValues(alpha:0.3))),
                ],
              ),
              AppSizes.gapH24,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.signInWithGoogle,
                      icon: Icon(Icons.g_mobiledata, color: AppColors.black, size: AppSizes.iconLarge),
                      label: Text('Google', style: TextStyle(color: AppColors.black, fontSize: AppSizes.font14)),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.p16),
                        side: BorderSide(color: AppColors.neutral.withValues(alpha:0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radius8)),
                      ),
                    ),
                  ),
                  AppSizes.gapW16,
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.apple, color: AppColors.black, size: AppSizes.iconMedium),
                      label: Text('Apple', style: TextStyle(color: AppColors.black, fontSize: AppSizes.font14)),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.p16),
                        side: BorderSide(color: AppColors.neutral.withValues(alpha:0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radius8)),
                      ),
                    ),
                  ),
                ],
              ),
              AppSizes.gapH40,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account? ', style: TextStyle(fontSize: AppSizes.font14)),
                  GestureDetector(
                    onTap: controller.goToSignUp,
                    child: Text(
                      'Sign up for free',
                      style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: AppSizes.font14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
