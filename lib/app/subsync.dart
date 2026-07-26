import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/routes/app_pages.dart';
import 'package:subsync/app/core/theme/app_theme.dart';
import 'package:subsync/app/core/theme/theme_controller.dart';
import 'package:subsync/app/core/constants/app_constants.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubSync extends StatelessWidget {
  const SubSync({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppConstants.appName,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          unknownRoute: GetPage(
            name: '/notfound',
            page: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          ),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeController.to.themeMode,
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300)
        );
      },
    );
  }
}
