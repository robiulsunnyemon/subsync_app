import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('SubSync', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: AppColors.tertiary, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.check_box, size: 30, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text('Create Account', style: AppTextStyles.headline.copyWith(fontSize: 28), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Join thousands of freelancers\nmanaging expenses with clarity.', style: AppTextStyles.body, textAlign: TextAlign.center),
              const SizedBox(height: 30),
              
              Text('Full Name', style: AppTextStyles.label),
              const SizedBox(height: 8),
              Obx(() => TextField(
                controller: controller.fullNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.neutral), 
                  hintText: 'John Doe',
                  errorText: controller.fullNameError.value,
                ),
                onChanged: (_) => controller.fullNameError.value = null,
              )),
              const SizedBox(height: 16),
              
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
              const SizedBox(height: 16),
              
              Text('Password', style: AppTextStyles.label),
              const SizedBox(height: 8),
              Obx(() => TextField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.neutral),
                  hintText: '********',
                  errorText: controller.passwordError.value,
                  suffixIcon: IconButton(
                    icon: Icon(controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off, color: AppColors.neutral),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
                onChanged: (_) => controller.passwordError.value = null,
              )),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Obx(() => Checkbox(
                    value: controller.agreeToTerms.value,
                    onChanged: controller.toggleTerms,
                    activeColor: AppColors.primary,
                  )),
                  Expanded(
                    child: Text('I agree to the Terms of Service and Privacy Policy.', style: AppTextStyles.label),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.signUp,
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.neutral.withOpacity(0.3))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('OR CONTINUE WITH', style: AppTextStyles.label.copyWith(fontSize: 10))),
                  Expanded(child: Divider(color: AppColors.neutral.withOpacity(0.3))),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata, color: AppColors.black),
                      label: const Text('Google', style: TextStyle(color: AppColors.black)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.apple, color: AppColors.black),
                      label: const Text('Apple', style: TextStyle(color: AppColors.black)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? '),
                  GestureDetector(
                    onTap: controller.goToLogin,
                    child: Text('Log In', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
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
