import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'package:subsync/app/core/constants/app_constants.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: controller.skip,
            child: Text('Skip', style: AppTextStyles.label.copyWith(color: AppColors.neutral)),
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
                    icon: Icons.sync,
                  ),
                  _buildPage(
                    title: 'Never Miss a Renewal',
                    description: 'Get smart notifications before your trials end or prices increase. Save money effortlessly.',
                    icon: Icons.notifications_active,
                  ),
                  _buildPage(
                    title: 'Simplify Your Taxes',
                    description: 'Categorize your expenses as business or personal and generate reports for your accountant.',
                    icon: Icons.receipt_long,
                  ),
                ],
              ),
            ),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => _buildDot(index == controller.currentPage.value)),
            )),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.next,
                  child: Obx(() => Text(controller.currentPage.value == 2 ? 'Get Started' : 'Next →')),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String description, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: AppColors.secondary),
          const SizedBox(height: 40),
          Text(title, style: AppTextStyles.headline.copyWith(fontSize: 22), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(description, style: AppTextStyles.body, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 24 : 6,
      decoration: BoxDecoration(
        color: isActive ? AppColors.secondary : AppColors.neutral.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
