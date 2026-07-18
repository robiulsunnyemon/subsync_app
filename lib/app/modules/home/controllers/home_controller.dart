import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:subsync/app/data/providers/auth_provider.dart';
import 'package:subsync/app/routes/app_pages.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  final isLoading = false.obs;
  final AuthProvider _authProvider = AuthProvider();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> logout() async {
    isLoading.value = true;
    try {
      // 1. Call backend logout API to invalidate refresh token
      await _authProvider.logout();
      
      // 2. Sign out from Google to clear the session so that the prompt is shown next time
      final googleSignIn = GoogleSignIn(
        clientId: const String.fromEnvironment('GOOGLE_ANDROID_CLIENT_ID'),
        serverClientId: const String.fromEnvironment('GOOGLE_CLIENT_ID'),
      );
      await googleSignIn.signOut();

      // 3. Navigate to login
      CustomSnackbar.showSuccess('Logged Out', 'You have successfully logged out');
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to logout properly');
      // Navigate anyway to ensure user is logged out locally
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }
}
