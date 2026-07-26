import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/bank_connection_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';

import '../../settings/controllers/settings_controller.dart';

class AuthBankView extends GetView<BankConnectionController> {
  const AuthBankView({super.key});

  Widget _buildTopLeftAvatar() {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsCtrl = Get.find<SettingsController>();
        return Obx(() {
          final String url = settingsCtrl.profileImage.value;
          return CircleAvatar(
            radius: 16.r,
            backgroundColor: AppColors.tertiary,
            backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
            child: url.isEmpty
                ? Icon(Icons.person, color: AppColors.primary, size: 18.sp)
                : null,
          );
        });
      }
    } catch (_) {}
    return CircleAvatar(
      radius: 16.r,
      backgroundColor: AppColors.tertiary,
      child: Icon(Icons.person, color: AppColors.primary, size: 18.sp),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String bankName = Get.arguments as String? ?? 'Your Bank';

    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        backgroundColor: AppColors.tertiary,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Row(
          children: [
            AppSizes.gapW8,
            _buildTopLeftAvatar(),
            AppSizes.gapW8,
            Text('SubSync', style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
          ],
        ),
        leadingWidth: 200,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.padding16),
          child: Container(
            padding: EdgeInsets.all(AppSizes.padding24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIconBox(Icons.sync, AppColors.primary),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Icon(Icons.compare_arrows, color: AppColors.neutral),
                    ),
                    _buildIconBox(Icons.account_balance, AppColors.primary),
                  ],
                ),
                AppSizes.gapH24,
                Text(
                  'Authorize SubSync',
                  style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                ),
                AppSizes.gapH8,
                Text(
                  'Connect your $bankName account to automatically track and sync your recurring subscriptions.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyText.copyWith(color: AppColors.neutral),
                ),
                AppSizes.gapH32,
                
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'REQUESTED PERMISSIONS',
                    style: AppTextStyles.label.copyWith(color: AppColors.neutral),
                  ),
                ),
                AppSizes.gapH16,
                
                _buildPermissionItem('Access account balance', 'To display your current liquidity across all tracked accounts.'),
                AppSizes.gapH16,
                _buildPermissionItem('View transaction history (past 90 days)', 'To identify recurring payments and subscription patterns.'),
                AppSizes.gapH16,
                _buildPermissionItem('Access account details (IBAN, Holder Name)', 'For secure identification and cross-referencing your business entity.'),
                
                AppSizes.gapH32,
                
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.shield, color: AppColors.primary, size: 20.sp),
                      AppSizes.gapW12,
                      Expanded(
                        child: Text(
                          'This connection is encrypted and follows PSD2 regulations. We will never have access to your login credentials or allow unauthorized transfers.',
                          style: AppTextStyles.bodyText.copyWith(fontSize: 12.sp, color: AppColors.primary),
                        ),
                      )
                    ],
                  ),
                ),
                
                AppSizes.gapH32,
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.agreeAndContinue(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary, // Green agree button
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text('Agree and Continue →', style: TextStyle(color: AppColors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ),
                ),
                AppSizes.gapH16,
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: BorderSide(color: AppColors.neutral),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text('Cancel', style: TextStyle(color: AppColors.neutral, fontSize: 16.sp)),
                  ),
                ),
                
                AppSizes.gapH24,
                Text(
                  'You can revoke this permission at any time from your SubSync settings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10.sp, color: AppColors.neutral),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, color: color),
    );
  }

  Widget _buildPermissionItem(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: AppColors.secondary, size: 20.sp),
        AppSizes.gapW12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.h3),
              AppSizes.gapH4,
              Text(desc, style: AppTextStyles.bodyText.copyWith(color: AppColors.neutral, fontSize: 12.sp)),
            ],
          ),
        )
      ],
    );
  }
}
