import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';

import 'bento_illustration.dart'; // For AnimatedFloatWidget and blurred extension

class AlertsIllustration extends StatelessWidget {
  const AlertsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Background Glow
          ImageFilterWidget(
            sigma: 60,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A237E).withOpacity(0.1), // primary-container
              ),
            ),
          ),

          // Calendar Card (rotated left)
          Positioned(
            top: 20.h,
            left: 20.w,
            child: Transform.rotate(
              angle: -6 * pi / 180, // -6 degrees
              child: Container(
                width: 140.w,
                height: 180.h,
                padding: EdgeInsets.all(AppSizes.p16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(AppSizes.radius12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 40.w, height: 8.h, decoration: BoxDecoration(color: const Color(0xFFEAE7EF), borderRadius: BorderRadius.circular(4))),
                        Container(width: 8.w, height: 8.w, decoration: const BoxDecoration(color: Color(0xFFBA1A1A), shape: BoxShape.circle)), // error color
                      ],
                    ),
                    AppSizes.gapH16,
                    // Grid of days
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 7,
                        mainAxisSpacing: 4.h,
                        crossAxisSpacing: 4.w,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(28, (index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: index == 12 ? const Color(0xFF1A237E) : const Color(0xFFF5F2FB), // primary-container vs surface-container-low
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                    ),
                    AppSizes.gapH12,
                    Container(width: double.infinity, height: 12.h, decoration: BoxDecoration(color: const Color(0xFFF5F2FB), borderRadius: BorderRadius.circular(6))),
                    AppSizes.gapH8,
                    Container(width: 60.w, height: 12.h, decoration: BoxDecoration(color: const Color(0xFFF5F2FB), borderRadius: BorderRadius.circular(6))),
                  ],
                ),
              ),
            ),
          ),

          // Abstract Data Decoration (Chart, rotated right)
          Positioned(
            bottom: 30.h,
            right: 10.w,
            child: Transform.rotate(
              angle: 10 * pi / 180, // 10 degrees
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 120.w,
                  height: 90.h,
                  padding: EdgeInsets.all(AppSizes.p12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(AppSizes.radius12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: Container(height: 30.h, color: const Color(0xFFE4E1EA))),
                      AppSizes.gapW4,
                      Expanded(child: Container(height: 50.h, color: const Color(0xFFE4E1EA))),
                      AppSizes.gapW4,
                      Expanded(child: Container(height: 70.h, color: const Color(0xFF006D37))), // secondary color
                      AppSizes.gapW4,
                      Expanded(child: Container(height: 40.h, color: const Color(0xFFE4E1EA))),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Central Notification Bell Container
          AnimatedFloatWidget(
            child: Transform.rotate(
              angle: 4 * pi / 180, // 4 degrees
              child: SizedBox(
                width: 220.w,
                height: 220.h,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // The main bell card
                    Container(
                      width: 150.w,
                      height: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(AppSizes.radius16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.notifications_active, color: AppColors.primary, size: 80.w),
                    ),
                    
                    // Floating Alert Bubble 1 (Save)
                    Positioned(
                      top: 10.h,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6BFE9C), // secondary-container
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF006D37).withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.trending_down, color: const Color(0xFF00743A), size: 16.w),
                            AppSizes.gapW4,
                            Text('Save \$12.99', style: TextStyle(color: const Color(0xFF00743A), fontWeight: FontWeight.bold, fontSize: 10.sp)),
                          ],
                        ),
                      ),
                    ),

                    // Floating Alert Bubble 2 (Trial Ends)
                    Positioned(
                      bottom: 20.h,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDAD6), // error-container
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFBA1A1A).withOpacity(0.1)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber_rounded, color: const Color(0xFF93000A), size: 16.w),
                            AppSizes.gapW4,
                            Text('Trial Ends', style: TextStyle(color: const Color(0xFF93000A), fontWeight: FontWeight.bold, fontSize: 10.sp)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
