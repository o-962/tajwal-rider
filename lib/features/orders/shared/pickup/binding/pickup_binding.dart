import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/shared/pickup/controller/pickup_controller.dart';

class PickupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PickupController>(() => PickupController());
  }
}
