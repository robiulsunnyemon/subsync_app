import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'package:subsync/app/core/constants/app_constants.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';
import 'widgets/taxes_illustration.dart';
import 'widgets/alerts_illustration.dart';
import 'widgets/bento_illustration.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());
    
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF), // match HTML background
      appBar: AppBar(
        title: Text(AppConstants.appName, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: AppSizes.font20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: controller.skip,
            child: Text('Skip', style: AppTextStyles.label.copyWith(color: AppColors.neutral, fontSize: AppSizes.font14)),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  _buildPage(
                    title: 'Track All Your Subscriptions',
                    description: 'Sync your bank account and automatically detect all your recurring payments in one place.',
                    illustration: const BentoIllustration(),
                  ),
                  _buildPage(
                    title: 'Never Miss a Renewal',
                    description: 'Get smart notifications before your trials end or prices increase. Save money effortlessly.',
                    illustration: const AlertsIllustration(),
                  ),
                  _buildPage(
                    title: 'Simplify Your Taxes',
                    description: 'Categorize your expenses as business or personal and generate reports for your accountant.',
                    illustration: const TaxesIllustration(),
                  ),
                ],
              ),
            ),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => _buildDot(index == controller.currentPage.value)),
            )),
            AppSizes.gapH24,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.p24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: controller.next,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.3),
                      ),
                      child: Obx(() => Text(
                        controller.currentPage.value == 2 ? 'Get Started' : 'Continue',
                        style: TextStyle(fontSize: AppSizes.font16, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  AppSizes.gapH16,
                  Obx(() => Opacity(
                    opacity: controller.currentPage.value > 0 ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: controller.currentPage.value == 0,
                      child: TextButton(
                        onPressed: controller.previous,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chevron_left, size: 20.sp, color: AppColors.neutral),
                            AppSizes.gapW4,
                            Text('Back', style: AppTextStyles.label.copyWith(fontSize: AppSizes.font14, color: AppColors.neutral)),
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            AppSizes.gapH8,
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String description, Widget? illustration, IconData? icon}) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.p24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (illustration != null) illustration else if (icon != null) Icon(icon, size: 100.w, color: AppColors.secondary),
          AppSizes.gapH40,
          Text(title, style: AppTextStyles.headline.copyWith(fontSize: 22.sp), textAlign: TextAlign.center),
          AppSizes.gapH16,
          Text(description, style: AppTextStyles.body.copyWith(fontSize: AppSizes.font16), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p4),
      height: 6.h,
      width: isActive ? 24.w : 6.w,
      decoration: BoxDecoration(
        color: isActive ? AppColors.secondary : AppColors.neutral.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}
