// ==============================
// FILE: lib/features/ride_location/controllers/pickup_controller.dart
// ==============================
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/features/ride_location/base/controllers/base_ride_location_controller.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class PickupController extends BaseRideLocationController {
  @override
  String get markerId => 'pickup';

  @override
  String get invalidToastHead => "Location invalid";

  @override
  String get invalidToastBody => "Selected location is outside the service areas.";

  @override
  void onValidLocation(String cityName, double lat, double lng) {
    rideService.setPickup(cityName, lat, lng);
  }
}
