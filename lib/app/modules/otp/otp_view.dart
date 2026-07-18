import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';
import 'otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, color: AppColors.primary, size: AppSizes.iconMedium), onPressed: controller.goBack),
        title: Text('SubSync', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: AppSizes.font20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: AppColors.primary, size: AppSizes.iconMedium),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.all(AppSizes.p24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSizes.gapH20,
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppSizes.radius16)),
                      child: Icon(Icons.mail_outline, size: 30.w, color: AppColors.white),
                    ),
                    AppSizes.gapH24,
                    Text('Verify Your Email', style: AppTextStyles.headline.copyWith(fontSize: 28.sp), textAlign: TextAlign.center),
                    AppSizes.gapH8,
                    Text('Enter the 4-digit code sent to your email\n${controller.maskedEmail}', style: AppTextStyles.body.copyWith(fontSize: AppSizes.font14), textAlign: TextAlign.center),
                    AppSizes.gapH40,
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) => _buildOtpBox(index)),
                    ),
                    Obx(() => controller.otpError.value != null
                        ? Padding(
                            padding: EdgeInsets.only(top: AppSizes.p8),
                            child: Text(
                              controller.otpError.value!,
                              style: TextStyle(color: Colors.red, fontSize: AppSizes.font12),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const SizedBox.shrink()),
                    
                    AppSizes.gapH32,
                    ElevatedButton(
                      onPressed: controller.verify,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Verify', style: TextStyle(fontSize: AppSizes.font16)),
                          AppSizes.gapW8,
                          Icon(Icons.arrow_forward, size: AppSizes.iconMedium),
                        ],
                      ),
                    ),
                    AppSizes.gapH32,
                    
                    Obx(() => Text(
                      controller.countdownTime.value > 0 
                          ? 'DIDN\'T RECEIVE THE CODE?'
                          : 'YOU CAN NOW RESEND THE CODE', 
                      style: AppTextStyles.label.copyWith(color: AppColors.neutral.withValues(alpha:0.5), fontSize: AppSizes.font12),
                      textAlign: TextAlign.center
                    )),
                    AppSizes.gapH8,
                    Obx(() => GestureDetector(
                      onTap: controller.countdownTime.value == 0 ? controller.resendOtp : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Resend code ', 
                            style: AppTextStyles.body.copyWith(
                              color: controller.countdownTime.value == 0 ? AppColors.primary : AppColors.black,
                              fontWeight: controller.countdownTime.value == 0 ? FontWeight.bold : FontWeight.normal,
                              fontSize: AppSizes.font14,
                            )
                          ),
                          if (controller.countdownTime.value > 0)
                            Text(controller.formattedTime, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: AppSizes.font14)),
                        ],
                      ),
                    )),
                    
                    const Spacer(),
                    
                    _buildFeatureBadge(Icons.security, 'SECURE ACCESS', 'Banking-grade encryption'),
                    AppSizes.gapH16,
                    _buildFeatureBadge(Icons.sync, 'AUTO SYNC', 'Real-time data fetching'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius8),
        border: Border.all(color: AppColors.neutral.withValues(alpha:0.3)),
      ),
      child: Center(
        child: TextField(
          controller: controller.otpControllers[index],
          focusNode: controller.focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: AppTextStyles.headline.copyWith(fontSize: 24.sp),
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            counterText: "",
            filled: false,
          ),
          onChanged: (value) {
            controller.otpError.value = null;
            if (value.isNotEmpty && index < 3) {
              controller.focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              controller.focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: AppSizes.iconMedium),
          AppSizes.gapW16,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold, fontSize: AppSizes.font12)),
              Text(subtitle, style: AppTextStyles.label.copyWith(fontSize: AppSizes.font10)),
            ],
          ),
        ],
      ),
    );
  }
}
