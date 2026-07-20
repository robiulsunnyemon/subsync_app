import 'package:get/get.dart';
import '../controllers/tax_report_controller.dart';

class TaxReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaxReportController>(
      () => TaxReportController(),
    );
  }
}
