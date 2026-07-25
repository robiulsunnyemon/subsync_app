import 'package:get/get.dart';
import '../controllers/bottom_navigation_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../subscriptions/controllers/subscriptions_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../../tax_report/controllers/tax_report_controller.dart';
import '../../bank_connection/controllers/bank_connection_controller.dart';

class BottomNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavigationController>(() => BottomNavigationController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<SubscriptionsController>(() => SubscriptionsController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<TaxReportController>(() => TaxReportController());
    Get.lazyPut<BankConnectionController>(() => BankConnectionController());
  }
}
