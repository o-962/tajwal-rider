// ==============================
// FILE: lib/features/ride_location/dropoff/dropoff_screen.dart
// ==============================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tajwal_rider/common/navigation/navigation_service.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/base/base_map_screen.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/dropoff/controller/dropoff_controller.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class DropoffScreen extends BaseRideLocationScreen<DropoffController> {
  DropoffScreen({super.key});
  @override
  final DropoffController controller = Get.find<DropoffController>();

  final RideService rideService = Get.find<RideService>();

  @override
  String get hintText => 'dropoff_location'.tr;

  @override
  String get buttonText => 'options'.tr;

  @override
  bool get isButtonDisabled => !rideService.hasDropoff;

  @override
  VoidCallback get onButtonTap =>
      () => Get.find<NavigationService>().toOptions();

  @override
  Set<Marker> get markers => controller.markers.value;

  @override
  Set<Polygon> get polygons => controller.polygonSet.value;

  @override
  void Function(GoogleMapController) get onMapCreated => controller.onMapCreated;

  @override
  void Function(LatLng) get onMapTap => controller.handleMapTap;

  @override
  TextEditingController get textController => controller.textEditingController;

  @override
  void onLocationSelected(String title, double lat, double lng) {
    controller.updateLocation(title, lat, lng);
  }
}
