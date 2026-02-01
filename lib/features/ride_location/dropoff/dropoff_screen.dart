// ==============================
// FILE: lib/features/ride_location/dropoff/dropoff_screen.dart
// ==============================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tajwal_rider/common/routes.dart';
import 'package:tajwal_rider/features/ride_location/dropoff/controller/dropoff_controller.dart';
import 'package:tajwal_rider/features/ride_location/base/base_map_screen.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class DropoffScreen extends BaseRideLocationScreen<DropoffController> {
  DropoffScreen({super.key});
  @override
  final DropoffController controller = Get.put(DropoffController());

  final RideService rideService = Get.find<RideService>();

  @override
  String get hintText => 'Drop off location';

  @override
  String get buttonText => 'Options';

  @override
  bool get isButtonDisabled => !rideService.hasDropoff;

  @override
  VoidCallback get onButtonTap =>
      () => Get.toNamed(AppRoutes.options);

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
