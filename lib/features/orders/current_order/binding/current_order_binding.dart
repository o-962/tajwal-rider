import 'package:get/instance_manager.dart';
import 'package:tajwal_rider/features/orders/current_order/controller/current_order_controller.dart';

class CurrentOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CurrentOrderController());
  }
}