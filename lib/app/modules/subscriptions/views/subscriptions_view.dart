import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/subscriptions_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';

class SubscriptionsView extends GetView<SubscriptionsController> {
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Subscriptions',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.primary),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                onChanged: (val) => controller.searchQuery.value = val,
                decoration: InputDecoration(
                  hintText: 'Search subscriptions...',
                  hintStyle: TextStyle(color: AppColors.neutral, fontSize: 14.sp),
                  prefixIcon: Icon(Icons.search, color: AppColors.neutral),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              AppSizes.gapH16,
              
              // Filter Chips
              Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip('All', controller.selectedCategory.value == 'All'),
                    AppSizes.gapW8,
                    _buildChip('Software', controller.selectedCategory.value == 'Software'),
                    AppSizes.gapW8,
                    _buildChip('Marketing', controller.selectedCategory.value == 'Marketing'),
                    AppSizes.gapW8,
                    _buildChip('Entertainment', controller.selectedCategory.value == 'Entertainment'),
                  ],
                ),
              )),
              AppSizes.gapH24,

              // List of Subscriptions
              Obx(() {
                final filteredSubs = controller.subscriptions.where((sub) {
                  final matchesSearch = (sub['name'] as String).toLowerCase().contains(controller.searchQuery.value.toLowerCase());
                  final matchesCategory = controller.selectedCategory.value == 'All' || 
                      (sub['tags'] as List).contains(controller.selectedCategory.value);
                  return matchesSearch && matchesCategory;
                }).toList();

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredSubs.length,
                  separatorBuilder: (context, index) => AppSizes.gapH12,
                  itemBuilder: (context, index) {
                    final sub = filteredSubs[index];
                    return _buildSubscriptionCard(sub);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.setCategory(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.tertiary),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.neutral,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12.sp
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(Map<String, dynamic> sub) {
    bool isActive = sub['status'] == 'Active';
    
    return GestureDetector(
      onTap: () => controller.openDetails(sub),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.tertiary),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  sub['icon'] as String,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.primary),
                ),
              ),
            ),
            AppSizes.gapW16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          sub['name'] as String,
                          style: AppTextStyles.h3,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      AppSizes.gapW8,
                      Text('€${(sub['amount'] as double).toStringAsFixed(2)}/mo', 
                          style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  AppSizes.gapH4,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: 4.w,
                        children: (sub['tags'] as List).map((tag) => 
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.tertiary,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(tag as String, style: TextStyle(fontSize: 8.sp, color: AppColors.neutral)),
                          )
                        ).toList(),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.secondary.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(sub['status'] as String, 
                            style: TextStyle(fontSize: 8.sp, color: isActive ? AppColors.secondary : Colors.red, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  AppSizes.gapH8,
                  Text('Next billing: ${sub['nextBilling']}', style: AppTextStyles.label.copyWith(fontSize: 10.sp)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
