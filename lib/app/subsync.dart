import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/routes/app_pages.dart';
import 'package:subsync/app/core/theme/app_theme.dart';
import 'package:subsync/app/core/constants/app_constants.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubSync extends StatelessWidget {
  const SubSync({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 13/14 Pro base design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppConstants.appName,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
