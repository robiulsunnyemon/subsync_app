import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/subscriptions_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';

class SubscriptionDetailsView extends GetView<SubscriptionsController> {
  const SubscriptionDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> sub = Get.arguments ?? {};
    
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          sub['name'] ?? 'Details',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section
            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: EdgeInsets.all(AppSizes.padding24),
              child: Column(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        sub['icon'] ?? 'S',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.sp, color: AppColors.primary),
                      ),
                    ),
                  ),
                  AppSizes.gapH16,
                  Text(sub['name'] ?? '', style: AppTextStyles.h1),
                  AppSizes.gapH8,
                  Text('€${(sub['amount'] ?? 0.0).toStringAsFixed(2)} / Month', style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
                  AppSizes.gapH16,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: sub['status'] == 'Active' ? AppColors.secondary.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(sub['status'] ?? '', 
                        style: TextStyle(fontSize: 12.sp, color: sub['status'] == 'Active' ? AppColors.secondary : Colors.red, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            
            AppSizes.gapH16,
            
            // Details Section
            Padding(
              padding: EdgeInsets.all(AppSizes.padding16),
              child: Container(
                padding: EdgeInsets.all(AppSizes.padding16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Next Billing', sub['nextBilling'] ?? ''),
                    const Divider(),
                    _buildDetailRow('Category', 'Software / Business'),
                    const Divider(),
                    _buildDetailRow('Billing Cycle', 'Monthly'),
                    const Divider(),
                    _buildDetailRow('Payment Method', 'Visa ending in 4242'),
                    const Divider(),
                    _buildDetailRow('Started', 'Jan 15, 2023'),
                  ],
                ),
              ),
            ),
            
            AppSizes.gapH16,
            
            // Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.padding16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.download, color: AppColors.primary),
                      label: Text('Download Invoices', style: TextStyle(color: AppColors.primary)),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                    ),
                  ),
                  AppSizes.gapH16,
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Cancel Subscription', style: TextStyle(color: Colors.red)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyText.copyWith(color: AppColors.neutral)),
          Text(value, style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
