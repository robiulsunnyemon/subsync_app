import 'package:get/get.dart';
import '../controllers/bank_connection_controller.dart';

class BankConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BankConnectionController>(
      () => BankConnectionController(),
    );
  }
}
