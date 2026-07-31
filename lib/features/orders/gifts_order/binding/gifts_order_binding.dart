import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/gifts_order/controller/gifts_order_controller.dart';

class GiftsOrderBinding extends Bindings {
  @override
  void dependencies() {
    // The controller registers itself as the shared OrderLocationTarget when it
    // opens the pickup / dropoff screens (see GiftsOrderController.openPickup),
    // so the target always points at the active flow.
    Get.lazyPut<GiftsOrderController>(
      () => GiftsOrderController(),
      fenix: true,
    );
  }
}