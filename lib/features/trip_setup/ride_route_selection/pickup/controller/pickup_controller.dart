// lib/features/trip_setup/ride_route_selection/pickup/controller/pickup_controller.dart
import 'package:get/get.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/base/controllers/base_ride_location_controller.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class PickupController extends BaseRideLocationController {
  PickupController(super.rideService);
  @override
  void onInit(){
    super.onInit();
    rideService.reset();
    loadPolygons();
  }
  @override
  String get markerId => 'pickup';

  @override
  String get invalidToastHead => "location_invalid".tr;

  @override
  String get invalidToastBody => "location_outside_service_area".tr;

  @override
  void onValidLocation(String cityName, double lat, double lng) {
    rideService.setPickup(cityName, lat, lng);
  }
}
