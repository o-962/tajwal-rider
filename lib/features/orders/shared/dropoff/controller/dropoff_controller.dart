import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/shared/base/base_coordinates_controller.dart';
import 'package:tajwal_rider/features/orders/shared/base/order_location_target.dart';
import 'package:tajwal_rider/utils/route_options.dart';

class DropoffController extends BaseCoordinatesController {
  @override
  String get markerId => 'dropoff';

  OrderLocationTarget get _target => Get.find<OrderLocationTarget>();

  String get _pickupCity => _target.pickupCityValue ?? '';

  /// Only areas with a priced route FROM the chosen pickup.
  ///
  /// This used to hide the pickup city alone, so every other area stayed
  /// tappable whether or not a route to it existed. Picking an unpriced pair
  /// looked fine all the way through seats, gender and slot selection, then died
  /// at submit with `INVALID_PICKUP_OR_DROPOFF_LOCATION` — the backend's
  /// `findRoutePricing` has no cell for it. [RouteOptions.canTravel] also
  /// excludes the pickup area itself, which is why the old rule is gone rather
  /// than merely extended.
  @override
  bool isCitySelectable(String city) => RouteOptions.canTravel(_pickupCity, city);

  @override
  String unavailableCityMessage(String city) => city == _pickupCity
      ? 'location_same_as_pickup'.tr
      : 'location_no_route_from_pickup'.tr;

  @override
  LocationSelection? get existingSelection => _target.dropSelection;

  @override
  void onValidLocation(String city, double lat, double lng) {
    _target.setDrop(city, lat, lng, textEditingController.text);
  }
}
