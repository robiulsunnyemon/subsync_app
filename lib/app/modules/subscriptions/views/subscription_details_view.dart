import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/subscriptions_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';

class SubscriptionDetailsView extends StatefulWidget {
  const SubscriptionDetailsView({super.key});

  @override
  State<SubscriptionDetailsView> createState() => _SubscriptionDetailsViewState();
}

class _SubscriptionDetailsViewState extends State<SubscriptionDetailsView> {
  late String _currentCategory;
  late Map<String, dynamic> _sub;
  bool _isUpdating = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Business', 'icon': Icons.business_center_outlined, 'color': AppColors.primary},
    {'name': 'Personal', 'icon': Icons.person_outline, 'color': AppColors.secondary},
    {'name': 'Uncategorized', 'icon': Icons.help_outline_outlined, 'color': AppColors.neutral},
  ];

  @override
  void initState() {
    super.initState();
    _sub = Get.arguments ?? {};
    
    // Determine initial category
    if (_sub['category'] != null && _sub['category'].toString().isNotEmpty) {
      _currentCategory = _sub['category'];
    } else if (_sub['tags'] != null && (_sub['tags'] as List).isNotEmpty) {
      _currentCategory = (_sub['tags'] as List).first.toString();
    } else {
      _currentCategory = 'Uncategorized';
    }
  }

  Future<void> _onCategorySelected(String categoryName) async {
    if (_currentCategory == categoryName || _isUpdating) return;

    setState(() {
      _currentCategory = categoryName;
      _isUpdating = true;
    });

    final controller = Get.find<SubscriptionsController>();
    final success = await controller.updateCategory(_sub['id']?.toString(), categoryName);

    if (mounted) {
      setState(() {
        _isUpdating = false;
        if (!success) {
          // Revert if failed
          _currentCategory = _sub['category'] ?? 'Uncategorized';
        } else {
          _sub['category'] = categoryName;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionsController>();

    return Scaffold(
      backgroundColor: AppColors.tertiary,
      appBar: AppBar(
        backgroundColor: AppColors.tertiary,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          _sub['name'] ?? 'Details',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
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
                        _sub['icon'] ?? 'S',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.sp, color: AppColors.primary),
                      ),
                    ),
                  ),
                  AppSizes.gapH16,
                  Text(_sub['name'] ?? '', style: AppTextStyles.h1),
                  AppSizes.gapH8,
                  Text(
                    '€${(_sub['amount'] ?? 0.0).toStringAsFixed(2)} / Month',
                    style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                  ),
                  AppSizes.gapH16,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: _sub['status'] == 'Active'
                          ? AppColors.secondary.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      _sub['status'] ?? '',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _sub['status'] == 'Active' ? AppColors.secondary : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Next Billing', _sub['nextBilling'] ?? ''),
                    const Divider(),
                    
                    // Interactive Category Selector
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Category', style: AppTextStyles.bodyText.copyWith(color: AppColors.neutral)),
                              if (_isUpdating)
                                SizedBox(
                                  width: 14.w,
                                  height: 14.w,
                                  child: const CircularProgressIndicator(strokeWidth: 2),
                                ),
                            ],
                          ),
                          AppSizes.gapH12,
                          Row(
                            children: _categories.map((cat) {
                              final String catName = cat['name'];
                              final IconData icon = cat['icon'];
                              final Color catColor = cat['color'];
                              final bool isSelected = _currentCategory.toLowerCase() == catName.toLowerCase();

                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                  child: GestureDetector(
                                    onTap: () => _onCategorySelected(catName),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? catColor.withOpacity(0.12)
                                            : AppColors.tertiary.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(20.r),
                                        border: Border.all(
                                          color: isSelected ? catColor : Colors.transparent,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            icon,
                                            size: 14.sp,
                                            color: isSelected ? catColor : AppColors.neutral,
                                          ),
                                          SizedBox(width: 4.w),
                                          Flexible(
                                            child: Text(
                                              catName,
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                color: isSelected ? catColor : AppColors.neutral,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
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
                      onPressed: () {
                        controller.downloadAndOpenInvoice(
                          _sub['id']?.toString(),
                          _sub['name']?.toString() ?? 'Subscription',
                        );
                      },
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
                      onPressed: () {
                        if (_sub['id'] != null) {
                          controller.cancelSubscription(_sub['id'].toString());
                        }
                      },
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
