import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';

import 'bento_illustration.dart'; // For AnimatedFloatWidget and ImageFilterWidget

class TaxesIllustration extends StatelessWidget {
  const TaxesIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Decorative Elements
          Positioned(
            top: -20.h,
            left: -20.w,
            child: ImageFilterWidget(
              sigma: 60,
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6BFE9C).withOpacity(0.2), // secondary-container
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -20.h,
            right: -20.w,
            child: ImageFilterWidget(
              sigma: 60,
              child: Container(
                width: 180.w,
                height: 180.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A237E).withOpacity(0.1), // primary-container
                ),
              ),
            ),
          ),

          // Main Report Card
          Positioned(
            top: 20.h,
            left: 20.w,
            right: 20.w,
            child: AnimatedFloatWidget(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radius12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.p16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      border: Border.all(color: const Color(0xFFE2E8F0).withOpacity(0.8)),
                      borderRadius: BorderRadius.circular(AppSizes.radius12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.receipt_long, color: AppColors.secondary, size: 20.w),
                                AppSizes.gapW8,
                                Text('Tax Report Q4', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: AppColors.black)),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6BFE9C).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Export Ready', style: TextStyle(color: AppColors.secondary, fontSize: 9.sp, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        AppSizes.gapH16,
                        // Line 1
                        Container(
                          padding: EdgeInsets.only(bottom: 8.h),
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(width: 80.w, height: 8.h, decoration: BoxDecoration(color: const Color(0xFFE4E1EA), borderRadius: BorderRadius.circular(4))),
                                  AppSizes.gapH4,
                                  Container(width: 120.w, height: 12.h, decoration: BoxDecoration(color: const Color(0xFF000666).withOpacity(0.1), borderRadius: BorderRadius.circular(4))),
                                ],
                              ),
                              Text('€ 1,240.00', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12.sp)),
                            ],
                          ),
                        ),
                        AppSizes.gapH8,
                        // Line 2
                        Container(
                          padding: EdgeInsets.only(bottom: 8.h),
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(width: 60.w, height: 8.h, decoration: BoxDecoration(color: const Color(0xFFE4E1EA), borderRadius: BorderRadius.circular(4))),
                                  AppSizes.gapH4,
                                  Container(width: 90.w, height: 12.h, decoration: BoxDecoration(color: const Color(0xFF000666).withOpacity(0.1), borderRadius: BorderRadius.circular(4))),
                                ],
                              ),
                              Text('€ 450.50', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12.sp)),
                            ],
                          ),
                        ),
                        AppSizes.gapH16,
                        // Bottom of card
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 24.w,
                                  height: 24.w,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFEFECF5), border: Border.all(color: Colors.white, width: 2)),
                                  child: Icon(Icons.work, size: 12.w, color: AppColors.neutral),
                                ),
                                Transform.translate(
                                  offset: const Offset(-8, 0),
                                  child: Container(
                                    width: 24.w,
                                    height: 24.w,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFEFECF5), border: Border.all(color: Colors.white, width: 2)),
                                    child: Icon(Icons.person, size: 12.w, color: AppColors.neutral),
                                  ),
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 90.w,
                                height: 8.h,
                                child: LinearProgressIndicator(
                                  value: 0.75,
                                  backgroundColor: AppColors.secondary.withOpacity(0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Floating Overlapping Receipt
          Positioned(
            bottom: 20.h,
            left: 10.w,
            child: Transform.rotate(
              angle: -3 * pi / 180,
              child: Container(
                width: 180.w,
                padding: EdgeInsets.all(AppSizes.p12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(AppSizes.radius12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: const BoxDecoration(color: Color(0xFFEFECF5), shape: BoxShape.circle),
                          child: Icon(Icons.cloud_done, color: AppColors.primary, size: 16.w),
                        ),
                        AppSizes.gapW8,
                        Text('DIGITAL RECEIPT', style: TextStyle(fontSize: 10.sp, color: AppColors.neutral, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    AppSizes.gapH16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Merchant', style: TextStyle(fontSize: 10.sp, color: AppColors.neutral)),
                        Text('AWS Europe', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    AppSizes.gapH4,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date', style: TextStyle(fontSize: 10.sp, color: AppColors.neutral)),
                        Text('Oct 12, 2023', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    AppSizes.gapH8,
                    Container(
                      padding: EdgeInsets.only(top: 8.h),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: const Color(0xFFE2E8F0), style: BorderStyle.solid)), // Flutter doesn't natively support dashed border bottom easily, solid is fine for mockup
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                          Text('€ 89.99', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    AppSizes.gapH16,
                    Container(
                      padding: EdgeInsets.all(AppSizes.p8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F2FB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('BUSINESS', style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold, color: AppColors.neutral, letterSpacing: 1)),
                          Container(
                            width: 24.w,
                            height: 12.h,
                            decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(6)),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 2.w),
                            child: Container(width: 8.w, height: 8.w, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Accountant Notification
          Positioned(
            top: 0,
            right: 0,
            child: AnimatedFloatWidget(
              delay: const Duration(seconds: 1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      border: Border.all(color: const Color(0xFFE2E8F0).withOpacity(0.8)),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: const BoxDecoration(color: Color(0xFF1A237E), shape: BoxShape.circle),
                          child: Icon(Icons.person_outline, color: Colors.white, size: 20.w), // Placeholder for image
                        ),
                        AppSizes.gapW12,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sent to Accountant', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 10.sp)),
                            Text('Q4 Full Report.pdf', style: TextStyle(color: AppColors.neutral, fontSize: 8.sp)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
