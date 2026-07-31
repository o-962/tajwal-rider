import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/passengers_order/controller/passengers_order_controller.dart';

class PassengersOrderBinding extends Bindings {
  @override
  void dependencies() {
    // The controller registers itself as the shared OrderLocationTarget when it
    // opens the pickup / dropoff screens (see PassengersOrderController.openPickup),
    // so the target always points at the active flow.
    Get.lazyPut(() => PassengersOrderController(), fenix: true);
  }
}
