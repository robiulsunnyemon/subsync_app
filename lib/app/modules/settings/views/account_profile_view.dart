import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_sizes.dart';

class AccountProfileView extends StatefulWidget {
  const AccountProfileView({super.key});

  @override
  State<AccountProfileView> createState() => _AccountProfileViewState();
}

class _AccountProfileViewState extends State<AccountProfileView> {
  final SettingsController controller = Get.find<SettingsController>();

  late TextEditingController _fullNameController;
  late TextEditingController _businessNameController;
  late TextEditingController _vatNumberController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: controller.userName.value);
    _businessNameController = TextEditingController(text: controller.businessName.value);
    _vatNumberController = TextEditingController(text: controller.vatNumber.value);

    // Sync controllers if reactive values update asynchronously
    ever(controller.userName, (val) {
      if (_fullNameController.text != val) {
        _fullNameController.text = val;
      }
    });
    ever(controller.businessName, (val) {
      if (_businessNameController.text != val) {
        _businessNameController.text = val;
      }
    });
    ever(controller.vatNumber, (val) {
      if (_vatNumberController.text != val) {
        _vatNumberController.text = val;
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _businessNameController.dispose();
    _vatNumberController.dispose();
    super.dispose();
  }

  void _onSaveProfile() {
    controller.saveProfileDetails(
      fullName: _fullNameController.text,
      businessNameInput: _businessNameController.text,
      vatNumberInput: _vatNumberController.text,
    );
  }

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
          'Account Profile',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header & Avatar Upload
              Container(
                width: double.infinity,
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
                  children: [
                    GestureDetector(
                      onTap: () => controller.pickCropAndPreviewImage(context),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Obx(() {
                            final imgUrl = controller.profileImage.value;
                            if (imgUrl.isNotEmpty) {
                              return CircleAvatar(
                                radius: 42.r,
                                backgroundColor: AppColors.tertiary,
                                backgroundImage: NetworkImage(imgUrl),
                              );
                            }
                            return CircleAvatar(
                              radius: 42.r,
                              backgroundColor: AppColors.tertiary,
                              child: Icon(Icons.person, size: 44.sp, color: AppColors.primary),
                            );
                          }),
                          Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.white, width: 2),
                            ),
                            child: Icon(Icons.camera_alt, color: AppColors.white, size: 14.sp),
                          )
                        ],
                      ),
                    ),
                    AppSizes.gapH12,
                    Text('Tap avatar to change profile photo', style: TextStyle(fontSize: 10.sp, color: AppColors.neutral)),
                    AppSizes.gapH16,
                    
                    // Editable Full Name
                    TextField(
                      controller: _fullNameController,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: AppColors.tertiary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Obx(() => Text(
                      controller.userEmail.value,
                      style: AppTextStyles.bodyText.copyWith(color: AppColors.neutral),
                    )),
                  ],
                ),
              ),
              AppSizes.gapH24,

              // Business Details Card
              Text('BUSINESS DETAILS', style: AppTextStyles.label.copyWith(color: AppColors.neutral)),
              AppSizes.gapH8,
              Container(
                padding: EdgeInsets.all(AppSizes.padding16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    _buildEditableInput('Business Name', 'e.g. Emon Enterprises Ltd', _businessNameController, Icons.business_outlined),
                    const Divider(),
                    _buildEditableInput('VAT Number', 'e.g. GB987654321 / DE123456789', _vatNumberController, Icons.receipt_long_outlined),
                  ],
                ),
              ),
              
              AppSizes.gapH16,

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _onSaveProfile,
                  icon: Icon(Icons.save_outlined, color: AppColors.white),
                  label: Text('Save Profile Changes', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    elevation: 0,
                  ),
                ),
              ),

              AppSizes.gapH24,
              Text('PREFERENCES', style: AppTextStyles.label.copyWith(color: AppColors.neutral)),
              AppSizes.gapH8,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.notifications_outlined, color: AppColors.primary),
                      title: Text('Notification Settings', style: AppTextStyles.bodyText),
                      trailing: Icon(Icons.chevron_right, color: AppColors.neutral),
                      onTap: () => controller.navigateToNotifications(),
                    ),
                    Divider(height: 1, indent: 16.w, endIndent: 16.w, color: AppColors.neutral.withValues(alpha: 0.2)),
                    Obx(() => ListTile(
                      leading: Icon(Icons.brightness_6_outlined, color: AppColors.primary),
                      title: Text('App Theme', style: AppTextStyles.bodyText),
                      subtitle: Text(
                        controller.selectedThemeName.value,
                        style: TextStyle(fontSize: 12.sp, color: AppColors.neutral),
                      ),
                      trailing: Icon(Icons.chevron_right, color: AppColors.neutral),
                      onTap: () => controller.showThemeSelectorDialog(context),
                    )),
                  ],
                ),
              ),

              AppSizes.gapH32,
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => controller.logout(),
                  icon: Icon(Icons.logout, color: Colors.red),
                  label: Text('Log Out', style: TextStyle(color: Colors.red, fontSize: 16.sp)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableInput(String label, String hint, TextEditingController inputController, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: AppColors.primary),
              SizedBox(width: 6.w),
              Text(label, style: AppTextStyles.label.copyWith(color: AppColors.neutral)),
            ],
          ),
          AppSizes.gapH4,
          TextField(
            controller: inputController,
            style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey.shade400, fontWeight: FontWeight.normal),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: AppColors.tertiary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
