import 'package:get/get.dart';
import 'package:subsync/app/routes/app_pages.dart';
import 'package:subsync/app/data/providers/dashboard_provider.dart';
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';

class DashboardController extends GetxController {
  
  final DashboardProvider _provider = DashboardProvider();

  final userName = 'Alex'.obs;
  final totalExpense = 0.0.obs;
  final totalSavings = 0.0.obs;
  final activeSubscriptions = 0.obs;
  final isLoading = true.obs;

  final upcomingPayments = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      final response = await _provider.getDashboardSummary();
      if (response.statusCode == 200) {
        final data = response.data;
        totalExpense.value = (data['totalMonthlyExpense'] ?? 0.0).toDouble();
        totalSavings.value = (data['totalSavings'] ?? 0.0).toDouble();
        activeSubscriptions.value = data['activeSubscriptionsCount'] ?? 0;
        upcomingPayments.value = data['upcomingPayments'] ?? [];
      }
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Failed to load dashboard data';
      CustomSnackbar.showError('Error', message);
    } catch (e) {
      CustomSnackbar.showError('Error', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  void goToSettings() => Get.toNamed(Routes.SETTINGS);
  void goToSubscriptions() => Get.toNamed(Routes.SUBSCRIPTIONS);
  void goToTaxReport() => Get.toNamed(Routes.TAX_REPORT);
  void goToBankConnection() => Get.toNamed(Routes.BANK_CONNECTION);
}
