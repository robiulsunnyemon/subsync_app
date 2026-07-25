import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'package:subsync/app/core/constants/app_constants.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(SplashController());
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                borderRadius: BorderRadius.circular(AppSizes.radius20),
              ),
              child: Icon(
                Icons.laptop_mac_rounded,
                size: 50.w,
                color: AppColors.primary,
              ),
            ),
            AppSizes.gapH24,
            Text(
              AppConstants.appName,
              style: AppTextStyles.headline.copyWith(
                color: AppColors.white,
                fontSize: 40.sp,
              ),
            ),
            AppSizes.gapH12,
            Text(
              'Subscription intelligence for modern\nEuropean enterprises.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.white.withValues(alpha:0.8),
                fontSize: 16.sp,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 200.w,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.white.withValues(alpha:0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              ),
            ),
            AppSizes.gapH12,
            Text(
              'SECURING CONNECTION',
              style: AppTextStyles.label.copyWith(
                color: AppColors.white.withValues(alpha:0.6),
                letterSpacing: 2,
              ),
            ),
            AppSizes.gapH40,
            Text(
              'TRUSTED OPEN BANKING ARCHITECTURE',
              style: AppTextStyles.label.copyWith(
                color: AppColors.white.withValues(alpha:0.4),
                fontSize: AppSizes.font10,
              ),
            ),
            AppSizes.gapH8,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Powered by  ',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.white.withValues(alpha:0.6),
                  ),
                ),
                Icon(Icons.account_balance, color: AppColors.white, size: AppSizes.iconSmall),
                Text(
                  '  rSeeLabs',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            AppSizes.gapH40,
          ],
        ),
       ),
      )
    );
  }
}
