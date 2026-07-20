import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';

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
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.sync, color: AppColors.white, size: 20.sp),
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
      body: SingleChildScrollView(
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
              Obx(() => Text(
                    'Good Morning, ${controller.userName.value}',
                    style: AppTextStyles.h1,
                  )),
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
              AppSizes.gapH24,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.goToSubscriptions,
                      child: Text('Subscriptions', style: TextStyle(color: AppColors.primary)),
                    ),
                  ),
                  AppSizes.gapW16,
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.goToBankConnection,
                      child: Text('Bank Sync', style: TextStyle(color: AppColors.primary)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                child: Text(
                  '+12% vs LY',
                  style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold),
                ),
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
          Text(
            'Your optimization strategy in Software & Marketing categories has effectively reduced redundant spending.',
            style: AppTextStyles.bodyText.copyWith(
                color: AppColors.neutral, fontSize: 12.sp, height: 1.5),
          ),
          AppSizes.gapH16,
          ElevatedButton(
            onPressed: controller.goToTaxReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'View Report →',
              style: TextStyle(color: AppColors.white),
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
                  child: CircularProgressIndicator(
                    value: 0.65, // Business %
                    strokeWidth: 15.w,
                    backgroundColor: AppColors.secondary,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '€4.2k',
                      style: AppTextStyles.h2,
                    ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem(AppColors.primary, 'Business', '65%'),
              _buildLegendItem(AppColors.secondary, 'Personal', '35%'),
            ],
          )
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
    return Row(
      children: [
        Expanded(
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
                    Icon(Icons.cloud_outlined, color: AppColors.primary),
                    Text(
                      'TOMORROW',
                      style: TextStyle(fontSize: 10.sp, color: AppColors.neutral),
                    ),
                  ],
                ),
                AppSizes.gapH8,
                Text('AWS Instance', style: AppTextStyles.h3),
                Text('Infrastructure',
                    style: AppTextStyles.label.copyWith(fontSize: 10.sp)),
                AppSizes.gapH8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('€124.00',
                        style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text('BUSINESS',
                          style: TextStyle(
                              fontSize: 8.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        AppSizes.gapW16,
        Expanded(
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
                    Icon(Icons.movie_outlined, color: Colors.red),
                    Text(
                      '3 DAYS',
                      style: TextStyle(fontSize: 10.sp, color: AppColors.neutral),
                    ),
                  ],
                ),
                AppSizes.gapH8,
                Text('Netflix', style: AppTextStyles.h3),
                Text('Entertainment',
                    style: AppTextStyles.label.copyWith(fontSize: 10.sp)),
                AppSizes.gapH8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('€17.99',
                        style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text('PERSONAL',
                          style: TextStyle(
                              fontSize: 8.sp,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
