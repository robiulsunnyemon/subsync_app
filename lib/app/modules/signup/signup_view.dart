import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';
import 'signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('SubSync', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: AppSizes.font20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSizes.gapH12,
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(color: AppColors.tertiary, borderRadius: BorderRadius.circular(AppSizes.radius16)),
                child: Icon(Icons.check_box, size: 30.w, color: AppColors.primary),
              ),
              AppSizes.gapH16,
              Text('Create Account', style: AppTextStyles.headline.copyWith(fontSize: 28.sp), textAlign: TextAlign.center),
              AppSizes.gapH8,
              Text('Join thousands of freelancers\nmanaging expenses with clarity.', style: AppTextStyles.body.copyWith(fontSize: AppSizes.font16), textAlign: TextAlign.center),
              AppSizes.gapH32,
              
              Text('Full Name', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font12)),
              AppSizes.gapH8,
              Obx(() => TextField(
                controller: controller.fullNameController,
                style: TextStyle(fontSize: AppSizes.font14),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.neutral, size: AppSizes.iconMedium), 
                  hintText: 'John Doe',
                  errorText: controller.fullNameError.value,
                ),
                onChanged: (_) => controller.fullNameError.value = null,
              )),
              AppSizes.gapH16,
              
              Text('Email Address', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font12)),
              AppSizes.gapH8,
              Obx(() => TextField(
                controller: controller.emailController,
                style: TextStyle(fontSize: AppSizes.font14),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline, color: AppColors.neutral, size: AppSizes.iconMedium), 
                  hintText: 'name@company.com',
                  errorText: controller.emailError.value,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => controller.emailError.value = null,
              )),
              AppSizes.gapH16,
              
              Text('Password', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font12)),
              AppSizes.gapH8,
              Obx(() => TextField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                style: TextStyle(fontSize: AppSizes.font14),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.neutral, size: AppSizes.iconMedium),
                  hintText: '********',
                  errorText: controller.passwordError.value,
                  suffixIcon: IconButton(
                    icon: Icon(controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off, color: AppColors.neutral, size: AppSizes.iconMedium),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
                onChanged: (_) => controller.passwordError.value = null,
              )),
              AppSizes.gapH16,
              
              Row(
                children: [
                  Obx(() => Checkbox(
                    value: controller.agreeToTerms.value,
                    onChanged: controller.toggleTerms,
                    activeColor: AppColors.primary,
                  )),
                  Expanded(
                    child: Text('I agree to the Terms of Service and Privacy Policy.', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font12)),
                  ),
                ],
              ),
              
              AppSizes.gapH24,
              ElevatedButton(
                onPressed: controller.signUp,
                child: Text('Sign Up', style: TextStyle(fontSize: AppSizes.font16)),
              ),
              AppSizes.gapH24,
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.neutral.withValues(alpha:0.3))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: AppSizes.p16), child: Text('OR CONTINUE WITH', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font10))),
                  Expanded(child: Divider(color: AppColors.neutral.withValues(alpha:0.3))),
                ],
              ),
              AppSizes.gapH20,
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
              AppSizes.gapH32,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: TextStyle(fontSize: AppSizes.font14)),
                  GestureDetector(
                    onTap: controller.goToLogin,
                    child: Text('Log In', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: AppSizes.font14)),
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
