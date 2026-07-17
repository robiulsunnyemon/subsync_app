import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'package:subsync/app/core/constants/app_constants.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(SplashController());
    
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.laptop_mac_rounded,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppConstants.appName,
              style: AppTextStyles.headline.copyWith(
                color: AppColors.white,
                fontSize: 40,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Subscription intelligence for modern\nEuropean enterprises.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'SECURING CONNECTION',
              style: AppTextStyles.label.copyWith(
                color: AppColors.white.withOpacity(0.6),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'TRUSTED OPEN BANKING ARCHITECTURE',
              style: AppTextStyles.label.copyWith(
                color: AppColors.white.withOpacity(0.4),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Powered by  ',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.white.withOpacity(0.6),
                  ),
                ),
                const Icon(Icons.account_balance, color: AppColors.white, size: 16),
                Text(
                  '  rSeeLabs',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
