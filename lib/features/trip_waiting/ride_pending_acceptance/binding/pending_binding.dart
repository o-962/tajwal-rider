// lib/features/trip_waiting/ride_pending_acceptance/binding/pending_binding.dart
import 'package:get/get.dart';
import 'package:tajwal_rider/features/trip_waiting/ride_pending_acceptance/controllers/pending_controller.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class PendingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PendingController>(
      () => PendingController(Get.find<RideService>()),
    );
  }
}
