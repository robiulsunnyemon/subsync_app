import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        leading: Icon(Icons.lock_outline, color: AppColors.primary, size: AppSizes.iconMedium),
        title: Text('SubSync', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: AppSizes.font20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p24),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSizes.p24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radius16),
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
                                Icon(Icons.arrow_back, size: AppSizes.iconSmall, color: AppColors.neutral),
                                AppSizes.gapW8,
                                Text('Back to Login', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font12)),
                              ],
                            ),
                          ),
                          AppSizes.gapH24,
                          Text('Forgot Password?', style: AppTextStyles.headline.copyWith(fontSize: 24.sp)),
                          AppSizes.gapH8,
                          Text('Enter your email address to receive an\nOTP to reset your password', style: AppTextStyles.body.copyWith(fontSize: AppSizes.font14)),
                          AppSizes.gapH32,
                          
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
                          AppSizes.gapH24,
                          
                          ElevatedButton(
                            onPressed: controller.sendResetLink,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Send OTP', style: TextStyle(fontSize: AppSizes.font16)),
                                AppSizes.gapW8,
                                Icon(Icons.arrow_forward, size: AppSizes.iconMedium),
                              ],
                            ),
                          ),
                          
                          AppSizes.gapH40,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline, color: AppColors.secondary, size: AppSizes.iconMedium),
                              AppSizes.gapW12,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Having trouble?', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold, fontSize: AppSizes.font12)),
                                    Text('Check your spam folder or contact our\nsupport team at help@subsync.com.', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font10)),
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
                        Icon(Icons.refresh, color: AppColors.neutral, size: AppSizes.iconMedium),
                        AppSizes.gapW16,
                        Icon(Icons.grid_on, color: AppColors.neutral.withOpacity(0.5), size: AppSizes.iconMedium),
                        AppSizes.gapW16,
                        Icon(Icons.security, color: AppColors.neutral.withOpacity(0.5), size: AppSizes.iconMedium),
                      ],
                    ),
                    AppSizes.gapH16,
                    Text('© 2024 SubSync Financial Solutions. European Union\nCompliant.', textAlign: TextAlign.center, style: AppTextStyles.label.copyWith(fontSize: AppSizes.font10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
