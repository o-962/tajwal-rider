import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/shared/base/base_coordinates_controller.dart';
import 'package:tajwal_rider/features/orders/shared/base/order_location_target.dart';

class PickupController extends BaseCoordinatesController {
  @override
  String get markerId => 'pickup';

  @override
  void onValidLocation(String city, double lat, double lng) {
    Get.find<OrderLocationTarget>()
        .setPickup(city, lat, lng, textEditingController.text);
  }
}
