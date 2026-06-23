// ==============================
// FILE: lib/features/ride_location/pickup/pickup_screen.dart
// ==============================
import 'dart:ui';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tajwal_rider/common/navigation/navigation_service.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/base/base_map_screen.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/pickup/controller/pickup_controller.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class PickupScreen extends BaseRideLocationScreen<PickupController> {
  PickupScreen({super.key});

  @override
  final PickupController controller = Get.find<PickupController>();
  final RideService rideService = Get.find<RideService>();

  @override
  String get hintText => 'pickup_location'.tr;

  @override
  String get buttonText => 'choose_dropoff_location'.tr;

  @override
  bool get isButtonDisabled => !rideService.hasPickup;

  @override
  VoidCallback get onButtonTap =>
      () => Get.find<NavigationService>().toDropoff();

  @override
  Set<Marker> get markers => controller.markers.value;

  @override
  Set<Polygon> get polygons => controller.polygonSet.value;

  @override
  get onMapCreated => controller.onMapCreated;

  @override
  get onMapTap => controller.handleMapTap;

  @override
  get textController => controller.textEditingController;

  @override
  void onLocationSelected(String title, double lat, double lng) {
    controller.updateLocation(title, lat, lng);
  }
}
