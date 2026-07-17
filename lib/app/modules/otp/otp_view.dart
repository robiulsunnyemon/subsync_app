import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/core/theme/app_colors.dart';
import 'package:subsync/app/core/theme/app_text_styles.dart';
import 'otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: controller.goBack),
        title: const Text('SubSync', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.primary),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.mail_outline, size: 30, color: AppColors.white),
              ),
              const SizedBox(height: 24),
              Text('Verify Your Email', style: AppTextStyles.headline.copyWith(fontSize: 28), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Enter the 4-digit code sent to your email\n${controller.maskedEmail}', style: AppTextStyles.body, textAlign: TextAlign.center),
              const SizedBox(height: 40),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOtpBox(index)),
              ),
              Obx(() => controller.otpError.value != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        controller.otpError.value!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox.shrink()),
              
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: controller.verify,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Verify'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              Obx(() => Text(
                controller.countdownTime.value > 0 
                    ? 'DIDN\'T RECEIVE THE CODE?'
                    : 'YOU CAN NOW RESEND THE CODE', 
                style: AppTextStyles.label.copyWith(color: AppColors.neutral.withOpacity(0.5)), 
                textAlign: TextAlign.center
              )),
              const SizedBox(height: 8),
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
                      )
                    ),
                    if (controller.countdownTime.value > 0)
                      Text(controller.formattedTime, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
              
              const Spacer(),
              
              _buildFeatureBadge(Icons.security, 'SECURE ACCESS', 'Banking-grade encryption'),
              const SizedBox(height: 16),
              _buildFeatureBadge(Icons.sync, 'AUTO SYNC', 'Real-time data fetching'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral.withOpacity(0.3)),
      ),
      child: Center(
        child: TextField(
          controller: controller.otpControllers[index],
          focusNode: controller.focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: AppTextStyles.headline,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
              Text(subtitle, style: AppTextStyles.label.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
