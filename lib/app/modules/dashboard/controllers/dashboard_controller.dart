import 'package:get/get.dart';
import 'package:subsync/app/routes/app_pages.dart';
import 'package:subsync/app/data/providers/dashboard_provider.dart';
import 'package:dio/dio.dart';
import 'package:subsync/app/core/utils/custom_snackbar.dart';

import 'package:subsync/app/modules/bottom_navigation/controllers/bottom_navigation_controller.dart';

class DashboardController extends GetxController {
  
  final DashboardProvider _provider = DashboardProvider();

  final userName = 'User'.obs;
  final totalExpense = 0.0.obs;
  final totalSavings = 0.0.obs;
  final activeSubscriptions = 0.obs;
  final businessExpense = 0.0.obs;
  final personalExpense = 0.0.obs;
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
        userName.value = (data['fullName'] ?? data['full_name'] ?? 'User').toString().split(' ').first;
        totalExpense.value = (data['totalMonthlyExpense'] ?? 0.0).toDouble();
        totalSavings.value = (data['totalSavings'] ?? 0.0).toDouble();
        activeSubscriptions.value = data['activeSubscriptionsCount'] ?? 0;
        businessExpense.value = (data['businessExpense'] ?? 0.0).toDouble();
        personalExpense.value = (data['personalExpense'] ?? 0.0).toDouble();
        final List<dynamic> rawUpcoming = data['upcomingPayments'] ?? [];
        upcomingPayments.value = rawUpcoming.map((item) {
          final Map<String, dynamic> map = Map<String, dynamic>.from(item);
          final String merchantName = map['merchantName'] ?? 'Subscription';
          final String firstLetter = merchantName.isNotEmpty ? merchantName[0].toUpperCase() : 'S';
          
          final String backendType = map['type'] ?? 'UNCATEGORIZED';
          String category = 'Uncategorized';
          if (backendType == 'BUSINESS') {
            category = 'Business';
          } else if (backendType == 'PERSONAL') {
            category = 'Personal';
          }

          final String statusStr = map['status'] == 'ACTIVE' ? 'Active' : 'Cancelled';
          
          String daysLeftStr = 'Upcoming';
          if (map['nextBillingDate'] != null) {
            try {
              final nextBilling = DateTime.parse(map['nextBillingDate'].toString());
              final today = DateTime.now();
              final todayDate = DateTime(today.year, today.month, today.day);
              final nextBillingDate = DateTime(nextBilling.year, nextBilling.month, nextBilling.day);
              final difference = nextBillingDate.difference(todayDate).inDays;
              
              if (difference == 0) {
                daysLeftStr = 'TODAY';
              } else if (difference == 1) {
                daysLeftStr = 'TOMORROW';
              } else if (difference > 1) {
                daysLeftStr = '$difference DAYS';
              } else {
                daysLeftStr = 'PASSED';
              }
            } catch (e) {
              // fallback
            }
          }

          return {
            'id': map['id'],
            'name': merchantName,
            'amount': (map['amount'] as num?)?.toDouble() ?? 0.0,
            'currency': map['currency'] ?? 'EUR',
            'cycle': map['cycle'] ?? 'MONTHLY',
            'nextBilling': map['nextBillingDate'] ?? '',
            'daysLeft': daysLeftStr,
            'category': category,
            'icon': firstLetter,
            'status': statusStr,
          };
        }).toList();
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
  
  void goToTaxReport() {
    if (Get.isRegistered<BottomNavigationController>()) {
      Get.find<BottomNavigationController>().changePage(3);
    } else {
      Get.toNamed(Routes.TAX_REPORT);
    }
  }
  
  void goToBankConnection() => Get.toNamed(Routes.BANK_CONNECTION);
}
