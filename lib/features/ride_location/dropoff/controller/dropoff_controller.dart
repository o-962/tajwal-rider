// ==============================
// FILE: lib/features/ride_location/controllers/dropoff_controller.dart
// ==============================
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/features/ride_location/base/controllers/base_ride_location_controller.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class DropoffController extends BaseRideLocationController {
  @override
  String get markerId => 'dropoff';

  @override
  String? get excludedCityName => rideService.ride.pickupLocation;

  @override
  String get invalidToastHead => "Unavailable location";

  @override
  String get invalidToastBody => "Please select a location inside the service area";

  @override
  void onValidLocation(String cityName, double lat, double lng) {
    rideService.setDropoff(cityName, lat, lng);
  }
}
