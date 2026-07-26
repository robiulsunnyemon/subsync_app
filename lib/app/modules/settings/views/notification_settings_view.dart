import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';

class NotificationSettingsView extends GetView<SettingsController> {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        backgroundColor: AppColors.tertiary,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notification Settings',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CHANNELS', style: AppTextStyles.label.copyWith(color: AppColors.neutral)),
            AppSizes.gapH8,
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Obx(() => SwitchListTile(
                    title: Text('Email Notifications', style: AppTextStyles.bodyText),
                    subtitle: Text('Receive renewal alerts via email', style: AppTextStyles.label.copyWith(fontSize: 10.sp)),
                    value: controller.emailEnabled.value,
                    activeColor: AppColors.secondary,
                    onChanged: controller.toggleEmail,
                  )),
                  const Divider(height: 1),
                  Obx(() => SwitchListTile(
                    title: Text('Push Notifications', style: AppTextStyles.bodyText),
                    subtitle: Text('Receive alerts on this device', style: AppTextStyles.label.copyWith(fontSize: 10.sp)),
                    value: controller.pushEnabled.value,
                    activeColor: AppColors.secondary,
                    onChanged: controller.togglePush,
                  )),
                ],
              ),
            ),
            
            AppSizes.gapH24,
            Text('REMINDER TIMING', style: AppTextStyles.label.copyWith(color: AppColors.neutral)),
            AppSizes.gapH8,
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Obx(() => Column(
                children: [
                  RadioListTile<String>(
                    title: Text('1 Day Before', style: AppTextStyles.bodyText),
                    value: '1 Day',
                    groupValue: controller.reminderDays.value,
                    activeColor: AppColors.primary,
                    onChanged: (val) => controller.setReminderDays(val!),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: Text('3 Days Before', style: AppTextStyles.bodyText),
                    value: '3 Days',
                    groupValue: controller.reminderDays.value,
                    activeColor: AppColors.primary,
                    onChanged: (val) => controller.setReminderDays(val!),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: Text('7 Days Before', style: AppTextStyles.bodyText),
                    value: '7 Days',
                    groupValue: controller.reminderDays.value,
                    activeColor: AppColors.primary,
                    onChanged: (val) => controller.setReminderDays(val!),
                  ),
                ],
              )),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.saveSettings(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: Text('Save Preferences', style: TextStyle(color: AppColors.white, fontSize: 16.sp)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
