import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/bank_connection_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';

class ConnectBankView extends GetView<BankConnectionController> {
  const ConnectBankView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        backgroundColor: AppColors.tertiary,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Get.back(),
              )
            : null,
        title: Text(
          'Connect Bank',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
        actions: Navigator.canPop(context)
            ? [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel', style: TextStyle(color: AppColors.neutral)),
                )
              ]
            : null,
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
                  hintText: 'Search for your bank or institution...',
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
                  children: controller.countries.map((country) {
                    bool isSelected = controller.selectedCountry.value == country['code'];
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () => controller.changeCountry(country['code'] as String),
                        child: _buildChip(country['name'] as String, isSelected),
                      ),
                    );
                  }).toList(),
                ),
              )),
              AppSizes.gapH16,

              // Security Banner
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.security, color: AppColors.secondary, size: 24.sp),
                    AppSizes.gapW16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('100% Secure & Regulated', style: AppTextStyles.h3.copyWith(color: AppColors.secondary)),
                          AppSizes.gapH4,
                          Text(
                            'SubSync uses Open Banking powered by Tink. We never see your login credentials and only have read-only access to transaction data to help you manage your subscriptions.',
                            style: AppTextStyles.bodyText.copyWith(color: AppColors.neutral, fontSize: 12.sp),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              AppSizes.gapH24,

              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Popular Banks
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Popular Banks', style: AppTextStyles.h2),
                        Text('${controller.allInstitutions.fold(0, (sum, section) => sum + (section['banks'] as List).length)} institutions found', style: AppTextStyles.label.copyWith(fontSize: 10.sp)),
                      ],
                    ),
                    AppSizes.gapH16,
                    
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: controller.popularBanks.length,
                      itemBuilder: (context, index) {
                        var bank = controller.popularBanks[index];
                        String bankName = bank['name'] as String;
                        bool isConnected = controller.isBankConnected(bankName);

                        return GestureDetector(
                          onTap: () => controller.connectBank(bankName),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isConnected ? AppColors.secondary : AppColors.tertiary,
                                    width: isConnected ? 1.5 : 1.0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 40.w,
                                      height: 40.w,
                                      decoration: BoxDecoration(
                                        color: isConnected ? AppColors.secondary.withOpacity(0.12) : AppColors.tertiary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          bank['icon'] as String,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isConnected ? AppColors.secondary : AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    AppSizes.gapH8,
                                    Text(
                                      bankName,
                                      style: AppTextStyles.h3,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      bank['type'] as String,
                                      style: AppTextStyles.label.copyWith(fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ),
                              if (isConnected)
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle, size: 10.sp, color: Colors.white),
                                        SizedBox(width: 2.w),
                                        Text(
                                          'Synced',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    
                    AppSizes.gapH24,
                    Text('All Institutions', style: AppTextStyles.h2),
                    AppSizes.gapH16,
                    
                    // All Institutions List
                    Column(
                      children: controller.allInstitutions.map((section) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                              color: AppColors.tertiary,
                              child: Text(section['letter'] as String, style: AppTextStyles.label),
                            ),
                            ...((section['banks'] as List<dynamic>).map((bank) {
                              String bankName = bank['name'] as String;
                              bool isConnected = controller.isBankConnected(bankName);
                              return ListTile(
                                tileColor: AppColors.white,
                                leading: Container(
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    color: isConnected ? AppColors.secondary.withOpacity(0.12) : AppColors.tertiary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      (bank['icon'] as String),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isConnected ? AppColors.secondary : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(bankName, style: AppTextStyles.bodyText),
                                trailing: isConnected
                                    ? Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.check_circle, size: 12.sp, color: AppColors.secondary),
                                            SizedBox(width: 4.w),
                                            Text(
                                              'Synced',
                                              style: TextStyle(
                                                color: AppColors.secondary,
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Icon(Icons.chevron_right, color: AppColors.neutral),
                                onTap: () => controller.connectBank(bankName),
                              );
                            }).toList()),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
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
    );
  }
}
