import 'package:get/get.dart';
import 'package:subsync/app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart' as get_storage;

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 3), () {
      final box = get_storage.GetStorage();
      final token = box.read('token');
      if (token != null && token.toString().isNotEmpty) {
        Get.offAllNamed(Routes.BOTTOM_NAVIGATION);
      } else {
        Get.offAllNamed(Routes.ONBOARDING);
      }
    });
  }
}
