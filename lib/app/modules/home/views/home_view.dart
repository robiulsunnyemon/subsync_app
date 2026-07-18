import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsync/app/core/theme/app_sizes.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView', style: TextStyle(fontSize: AppSizes.font20)),
        centerTitle: true,
        actions: [
          Obx(() => controller.isLoading.value
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  child: Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.logout, size: AppSizes.iconMedium),
                  onPressed: () => controller.logout(),
                )),
        ],
      ),
      body: Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: AppSizes.font20),
        ),
      ),
    );
  }
}
