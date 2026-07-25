import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/tax_report_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';

class TaxReportView extends GetView<TaxReportController> {
  const TaxReportView({super.key});

  final List<String> availableYears = const ['2026', '2025', '2024', '2023'];

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
          'Tax Report',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Interactive Year Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TAX YEAR', style: AppTextStyles.label.copyWith(color: AppColors.neutral)),
                    PopupMenuButton<String>(
                      onSelected: controller.changeYear,
                      itemBuilder: (context) {
                        return availableYears.map((year) {
                          return PopupMenuItem<String>(
                            value: year,
                            child: Text(
                              year,
                              style: TextStyle(
                                fontWeight: controller.selectedYear.value == year ? FontWeight.bold : FontWeight.normal,
                                color: controller.selectedYear.value == year ? AppColors.primary : AppColors.neutral,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: AppColors.tertiary),
                        ),
                        child: Row(
                          children: [
                            Obx(() => Text(controller.selectedYear.value, style: AppTextStyles.h3)),
                            Icon(Icons.arrow_drop_down, color: AppColors.primary),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                AppSizes.gapH24,
                
                // Total Deductions Card
                Container(
                  padding: EdgeInsets.all(AppSizes.padding24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Business Deductions', style: AppTextStyles.bodyText.copyWith(color: AppColors.neutral)),
                      AppSizes.gapH8,
                      Obx(() => Text(
                        '€${controller.totalBusinessDeductions.value.toStringAsFixed(2)}',
                        style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 36.sp),
                      )),
                      AppSizes.gapH16,
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: AppColors.primary, size: 20.sp),
                            AppSizes.gapW8,
                            Expanded(
                              child: Text(
                                'These are automatically identified based on your "Business" categorization.',
                                style: TextStyle(fontSize: 10.sp, color: AppColors.primary),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                AppSizes.gapH32,

                Text('Eligible Expenses', style: AppTextStyles.h2),
                AppSizes.gapH16,
                
                // List of Expenses or Empty state
                Obx(() {
                  if (controller.businessSubscriptions.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.business_center_outlined, size: 40.sp, color: AppColors.neutral),
                          AppSizes.gapH8,
                          Text(
                            'No business deductions for ${controller.selectedYear.value}',
                            style: AppTextStyles.h3.copyWith(color: AppColors.neutral),
                          ),
                          AppSizes.gapH4,
                          Text(
                            'Categorize subscriptions as "Business" to claim tax deductions.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyText.copyWith(fontSize: 12.sp, color: AppColors.neutral),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.businessSubscriptions.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final sub = Map<String, dynamic>.from(controller.businessSubscriptions[index]);
                      final String name = sub['name']?.toString() ?? 'Subscription';
                      final String category = sub['category']?.toString() ?? 'Business';
                      final String iconStr = sub['icon']?.toString() ?? (name.isNotEmpty ? name[0].toUpperCase() : 'B');
                      final double annualTotal = (sub['annualTotal'] ?? 0.0).toDouble();

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.tertiary),
                          ),
                          child: Center(
                            child: Text(
                              iconStr,
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ),
                        ),
                        title: Text(name, style: AppTextStyles.h3),
                        subtitle: Text(category, style: AppTextStyles.label.copyWith(fontSize: 10.sp)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('€${annualTotal.toStringAsFixed(2)}', style: AppTextStyles.h3),
                            Text('Total Year', style: AppTextStyles.label.copyWith(fontSize: 10.sp)),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(AppSizes.padding16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.exportCsv,
                icon: Icon(Icons.table_chart_outlined, color: AppColors.primary),
                label: Text('Export CSV', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ),
            AppSizes.gapW16,
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.generatePdf,
                icon: Icon(Icons.picture_as_pdf, color: AppColors.white),
                label: Text('Generate PDF', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
