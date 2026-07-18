import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';
import 'reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

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
                          BoxShadow(color: AppColors.neutral.withValues(alpha:0.1), blurRadius: 10, offset: const Offset(0, 5))
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
                                Text('Back', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font12)),
                              ],
                            ),
                          ),
                          AppSizes.gapH24,
                          Text('Reset Password', style: AppTextStyles.headline.copyWith(fontSize: 24.sp)),
                          AppSizes.gapH8,
                          Text('Enter your new password to reset it.', style: AppTextStyles.body.copyWith(fontSize: AppSizes.font14)),
                          AppSizes.gapH32,
                          
                          Text('New Password', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font12)),
                          AppSizes.gapH8,
                          Obx(() => TextField(
                            controller: controller.newPasswordController,
                            style: TextStyle(fontSize: AppSizes.font14),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline, color: AppColors.neutral, size: AppSizes.iconMedium), 
                              hintText: '********',
                              errorText: controller.passwordError.value,
                            ),
                            obscureText: true,
                            onChanged: (_) => controller.passwordError.value = null,
                          )),
                          AppSizes.gapH24,
                          
                          ElevatedButton(
                            onPressed: controller.resetPassword,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Reset Password', style: TextStyle(fontSize: AppSizes.font16)),
                                AppSizes.gapW8,
                                Icon(Icons.check_circle_outline, size: AppSizes.iconMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
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
