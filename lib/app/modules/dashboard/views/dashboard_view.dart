import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: controller.goToSettings,
              child: Obx(() {
                final imgUrl = controller.profileImage.value;
                if (imgUrl.isNotEmpty) {
                  return CircleAvatar(
                    radius: 18.r,
                    backgroundColor: AppColors.tertiary,
                    backgroundImage: NetworkImage(imgUrl),
                  );
                }
                return Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: AppColors.white, size: 20.sp),
                );
              }),
            ),
            AppSizes.gapW8,
            Text(
              'SubSync',
              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: AppColors.neutral),
            onPressed: controller.goToSettings,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerScreen();
        }
        return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OVERVIEW',
                style: AppTextStyles.label.copyWith(color: AppColors.neutral),
              ),
              AppSizes.gapH4,
              Obx(() {
                final hour = DateTime.now().hour;
                final greeting = hour < 12 ? 'Good Morning' : hour < 17 ? 'Good Afternoon' : 'Good Evening';
                return Text(
                  '$greeting, ${controller.userName.value}',
                  style: AppTextStyles.h1,
                );
              }),
              AppSizes.gapH16,
              _buildTotalSavingsCard(),
              AppSizes.gapH16,
              _buildExpenseSplitCard(),
              AppSizes.gapH24,
              Text(
                'Upcoming Payments',
                style: AppTextStyles.h2,
              ),
              AppSizes.gapH16,
              _buildUpcomingPayments(),

            ],
          ),
        ),
      );
      }),
    );
  }

  Widget _buildShimmerScreen() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // OVERVIEW label
              _shimmerBox(width: 60.w, height: 12.h, radius: 4),
              AppSizes.gapH8,
              // Greeting
              _shimmerBox(width: 220.w, height: 28.h, radius: 6),
              AppSizes.gapH20,

              // Savings Card skeleton
              Container(
                padding: EdgeInsets.all(AppSizes.padding20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _shimmerBox(width: 130.w, height: 14.h, radius: 4),
                        _shimmerBox(width: 70.w, height: 22.h, radius: 12),
                      ],
                    ),
                    AppSizes.gapH12,
                    _shimmerBox(width: 150.w, height: 36.h, radius: 6),
                    AppSizes.gapH12,
                    _shimmerBox(width: double.infinity, height: 12.h, radius: 4),
                    SizedBox(height: 6.h),
                    _shimmerBox(width: 200.w, height: 12.h, radius: 4),
                    AppSizes.gapH20,
                    _shimmerBox(width: double.infinity, height: 44.h, radius: 8),
                  ],
                ),
              ),
              AppSizes.gapH16,

              // Expense Split Card skeleton
              Container(
                padding: EdgeInsets.all(AppSizes.padding20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: 100.w, height: 12.h, radius: 4),
                    AppSizes.gapH20,
                    Center(
                      child: Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    AppSizes.gapH16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _shimmerBox(width: 80.w, height: 14.h, radius: 4),
                        SizedBox(width: 24.w),
                        _shimmerBox(width: 80.w, height: 14.h, radius: 4),
                      ],
                    ),
                  ],
                ),
              ),
              AppSizes.gapH24,

              // Upcoming Payments heading
              _shimmerBox(width: 170.w, height: 22.h, radius: 6),
              AppSizes.gapH16,

              // 3 upcoming payment card skeletons
              ...List.generate(3, (_) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _shimmerBox(width: 28.w, height: 28.w, radius: 6),
                          _shimmerBox(width: 60.w, height: 12.h, radius: 4),
                        ],
                      ),
                      AppSizes.gapH8,
                      _shimmerBox(width: 130.w, height: 16.h, radius: 4),
                      SizedBox(height: 6.h),
                      _shimmerBox(width: 70.w, height: 11.h, radius: 4),
                      AppSizes.gapH8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _shimmerBox(width: 70.w, height: 16.h, radius: 4),
                          _shimmerBox(width: 60.w, height: 20.h, radius: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({required double width, required double height, double radius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }

  Widget _buildTotalSavingsCard() {
    return Container(
      padding: EdgeInsets.all(AppSizes.padding20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Annual Total Savings',
                style: AppTextStyles.bodyText,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Obx(() => Text(
                  '${controller.activeSubscriptions.value} active',
                  style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ],
          ),
          AppSizes.gapH8,
          Obx(() => Text(
                '€${controller.totalSavings.value.toStringAsFixed(2)}',
                style: AppTextStyles.h1.copyWith(
                    color: AppColors.primary,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold),
              )),
          AppSizes.gapH16,
          Obx(() {
            final total = controller.totalExpense.value;
            String subtitle;
            if (total == 0) {
              subtitle = 'Connect your bank or add subscriptions to start tracking expenses.';
            } else if (total < 100) {
              subtitle = 'Great job keeping expenses low! Review your subscriptions to stay on track.';
            } else if (total < 500) {
              subtitle = 'You have €${total.toStringAsFixed(0)} in monthly subscriptions. Consider reviewing underused services.';
            } else {
              subtitle = 'High monthly spend detected. Optimizing Software & Marketing categories could reduce costs significantly.';
            }
            return Text(
              subtitle,
              style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.neutral, fontSize: 12.sp, height: 1.5),
            );
          }),
          AppSizes.gapH16,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.goToTaxReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'View Report →',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExpenseSplitCard() {
    return Container(
      padding: EdgeInsets.all(AppSizes.padding20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPENSE SPLIT',
            style: AppTextStyles.label.copyWith(color: AppColors.neutral),
          ),
          AppSizes.gapH16,
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120.w,
                  height: 120.w,
                  child: Obx(() {
                    final total = controller.totalExpense.value;
                    final business = controller.businessExpense.value;
                    final progress = (total > 0) ? (business / total) : 0.0;
                    return CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 15.w,
                      backgroundColor: AppColors.secondary,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    );
                  }),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text(
                      '€${controller.totalExpense.value.toStringAsFixed(0)}',
                      style: AppTextStyles.h2.copyWith(fontSize: 20.sp),
                    )),
                    Text(
                      'Total',
                      style: AppTextStyles.label,
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSizes.gapH24,
          Obx(() {
            final total = controller.totalExpense.value;
            final business = controller.businessExpense.value;
            final personal = controller.personalExpense.value;
            
            final businessPct = (total > 0) ? (business / total * 100).toStringAsFixed(0) : '0';
            final personalPct = (total > 0) ? (personal / total * 100).toStringAsFixed(0) : '0';
            
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLegendItem(AppColors.primary, 'Business', '$businessPct%'),
                _buildLegendItem(AppColors.secondary, 'Personal', '$personalPct%'),
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, String percentage) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        AppSizes.gapW8,
        Text(
          label,
          style: AppTextStyles.bodyText,
        ),
        AppSizes.gapW8,
        Text(
          percentage,
          style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildUpcomingPayments() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (controller.upcomingPayments.isEmpty) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.tertiary),
          ),
          child: Center(
            child: Text(
              'No upcoming payments found',
              style: AppTextStyles.bodyText.copyWith(color: AppColors.neutral),
            ),
          ),
        );
      }

      return Column(
        children: controller.upcomingPayments.map((payment) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildUpcomingCard(Map<String, dynamic>.from(payment)),
          );
        }).toList(),
      );
    });
  }

  Widget _buildUpcomingCard(Map<String, dynamic> payment) {
    final String name = payment['name'] ?? 'Subscription';
    final String daysLeft = payment['daysLeft'] ?? 'Upcoming';
    final double amount = payment['amount'] ?? 0.0;
    final String category = payment['category'] ?? 'Uncategorized';
    final bool isBusiness = category == 'Business';
    
    IconData categoryIcon = Icons.payment_outlined;
    if (category == 'Business') {
      categoryIcon = Icons.business_center_outlined;
    } else if (category == 'Personal') {
      categoryIcon = Icons.person_outline;
    }

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.SUBSCRIPTION_DETAILS, arguments: payment),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.tertiary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(categoryIcon, color: isBusiness ? AppColors.primary : AppColors.secondary),
                Text(
                  daysLeft,
                  style: TextStyle(fontSize: 10.sp, color: AppColors.neutral, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            AppSizes.gapH8,
            Text(
              name, 
              style: AppTextStyles.h3,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              category,
              style: AppTextStyles.label.copyWith(fontSize: 10.sp),
            ),
            AppSizes.gapH8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '€${amount.toStringAsFixed(2)}',
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: (isBusiness ? AppColors.primary : AppColors.secondary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: isBusiness ? AppColors.primary : AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
