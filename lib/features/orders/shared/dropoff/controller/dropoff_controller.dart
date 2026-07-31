import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/shared/base/base_coordinates_controller.dart';
import 'package:tajwal_rider/features/orders/shared/base/order_location_target.dart';

class DropoffController extends BaseCoordinatesController {
  @override
  String get markerId => 'dropoff';

  /// Hide the pickup city so the rider can't pick the same area for drop-off.
  @override
  String? get excludedCity => Get.find<OrderLocationTarget>().pickupCityValue;

  @override
  void onValidLocation(String city, double lat, double lng) {
    Get.find<OrderLocationTarget>()
        .setDrop(city, lat, lng, textEditingController.text);
  }
}
