import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/shared/base/base_coordinates_controller.dart';
import 'package:tajwal_rider/features/orders/shared/base/order_location_target.dart';
import 'package:tajwal_rider/utils/route_options.dart';

class PickupController extends BaseCoordinatesController {
  @override
  String get markerId => 'pickup';

  OrderLocationTarget get _target => Get.find<OrderLocationTarget>();

  String get _dropCity => _target.dropCityValue ?? '';

  /// Areas with at least one priced route out, minus the chosen dropoff.
  ///
  /// - `canDepartFrom`: an area nobody priced a route FROM is a dead end — the
  ///   rider picks it, advances, and finds an empty dropoff map.
  /// - `city != _dropCity`: the mirror of the dropoff screen hiding the pickup
  ///   city. Hiding it on only one side meant the rule held if you chose pickup
  ///   first and broke if you chose dropoff first, which is the same trip.
  @override
  bool isCitySelectable(String city) =>
      RouteOptions.canDepartFrom(city) && city != _dropCity;

  @override
  String unavailableCityMessage(String city) => city == _dropCity
      ? 'location_same_as_dropoff'.tr
      : 'location_no_routes_available'.tr;

  @override
  LocationSelection? get existingSelection => _target.pickupSelection;

  @override
  void onValidLocation(String city, double lat, double lng) {
    _target.setPickup(city, lat, lng, textEditingController.text);
  }
}
