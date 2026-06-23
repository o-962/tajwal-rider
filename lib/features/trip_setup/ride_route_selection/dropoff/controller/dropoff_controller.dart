// lib/features/trip_setup/ride_route_selection/dropoff/controller/dropoff_controller.dart
import 'package:get/get.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/base/controllers/base_ride_location_controller.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class DropoffController extends BaseRideLocationController {
  DropoffController(super.rideService);

  @override
  void onInit() {
    super.onInit();
    loadPolygons();
  }

  @override
  String get markerId => 'dropoff';

  @override
  String? get excludedCityName => rideService.ride.pickupLocation;

  @override
  String get invalidToastHead => "location_invalid".tr;

  @override
  String get invalidToastBody => "location_outside_service_area".tr;

  @override
  void onValidLocation(String cityName, double lat, double lng) {
    rideService.setDropoff(cityName, lat, lng);
  }
}
