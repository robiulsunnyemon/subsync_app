import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/bottom_navigation_controller.dart';
import '../../../core/theme/app_colors.dart';

class BottomNavigationView extends GetView<BottomNavigationController> {
  const BottomNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: controller.pages,
          )),
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
                  _buildNavItem(1, Icons.credit_card_outlined, Icons.credit_card, 'Subscription'),
                  _buildCenterPlusItem(2),
                  _buildNavItem(3, Icons.receipt_long_outlined, Icons.receipt_long, 'Tax'),
                  _buildNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNavItem(int pageIndex, IconData outlineIcon, IconData solidIcon, String label) {
    final isSelected = controller.currentIndex.value == pageIndex;
    final color = isSelected ? AppColors.primary : AppColors.neutral;
    
    return GestureDetector(
      onTap: () => controller.changePage(pageIndex),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              isSelected ? solidIcon : outlineIcon,
              color: color,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPlusItem(int pageIndex) {
    final isSelected = controller.currentIndex.value == pageIndex;
    
    return GestureDetector(
      onTap: () => controller.changePage(pageIndex),
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.neutral,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isSelected ? AppColors.primary : AppColors.neutral).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: 28.sp,
        ),
      ),
    );
  }
}
