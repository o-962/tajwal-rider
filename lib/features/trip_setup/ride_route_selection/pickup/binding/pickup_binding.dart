// lib/features/trip_setup/ride_route_selection/pickup/binding/pickup_binding.dart
import 'package:get/get.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/pickup/controller/pickup_controller.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class PickupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PickupController>(
      () => PickupController(Get.find<RideService>()),
    );
  }
}
