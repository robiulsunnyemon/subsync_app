import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsync/app/routes/app_pages.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Get.offAllNamed(Routes.LOGIN); 
    }
  }

  void skip() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
