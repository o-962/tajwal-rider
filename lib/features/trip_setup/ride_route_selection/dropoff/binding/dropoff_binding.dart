// lib/features/trip_setup/ride_route_selection/dropoff/binding/dropoff_binding.dart
import 'package:get/get.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/dropoff/controller/dropoff_controller.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class DropoffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DropoffController>(
      () => DropoffController(Get.find<RideService>()),
    );
  }
}
