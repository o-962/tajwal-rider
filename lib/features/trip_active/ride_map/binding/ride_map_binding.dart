// lib/features/trip_active/ride_map/binding/ride_map_binding.dart
import 'package:get/get.dart';
import 'package:tajwal_rider/common/navigation/navigation_service.dart';
import 'package:tajwal_rider/features/trip_active/ride_map/controllers/ride_map_controller.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class RideMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideMapController>(
      () => RideMapController(
        nav: Get.find<NavigationService>(),
        rideService: Get.find<RideService>(),
      ),
    );
  }
}
