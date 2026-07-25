import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';

class AccountProfileView extends GetView<SettingsController> {
  const AccountProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Get.back(),
              )
            : null,
        title: Text(
          'Account Profile',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                width: double.infinity,
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
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 40.r,
                          backgroundColor: AppColors.tertiary,
                          child: Icon(Icons.person, size: 40.sp, color: AppColors.primary),
                        ),
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit, color: AppColors.white, size: 12.sp),
                        )
                      ],
                    ),
                    AppSizes.gapH16,
                    Obx(() => Text(controller.userName.value, style: AppTextStyles.h1)),
                    AppSizes.gapH4,
                    Obx(() => Text(controller.userEmail.value, style: AppTextStyles.bodyText.copyWith(color: AppColors.neutral))),
                  ],
                ),
              ),
              AppSizes.gapH24,

              Text('BUSINESS DETAILS', style: AppTextStyles.label.copyWith(color: AppColors.neutral)),
              AppSizes.gapH8,
              Container(
                padding: EdgeInsets.all(AppSizes.padding16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    _buildTextField('Business Name', controller.businessName.value),
                    const Divider(),
                    _buildTextField('VAT Number', controller.vatNumber.value),
                  ],
                ),
              ),
              
              AppSizes.gapH24,
              Text('PREFERENCES', style: AppTextStyles.label.copyWith(color: AppColors.neutral)),
              AppSizes.gapH8,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ListTile(
                  leading: Icon(Icons.notifications_outlined, color: AppColors.primary),
                  title: Text('Notification Settings', style: AppTextStyles.bodyText),
                  trailing: Icon(Icons.chevron_right, color: AppColors.neutral),
                  onTap: () => controller.navigateToNotifications(),
                ),
              ),

              AppSizes.gapH32,
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => controller.logout(),
                  icon: Icon(Icons.logout, color: Colors.red),
                  label: Text('Log Out', style: TextStyle(color: Colors.red, fontSize: 16.sp)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label.copyWith(color: AppColors.neutral)),
          AppSizes.gapH4,
          Text(value, style: AppTextStyles.bodyText),
        ],
      ),
    );
  }
}
