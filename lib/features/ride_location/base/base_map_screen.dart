// ==============================
// FILE: lib/features/ride_location/base/base_ride_location_screen.dart
// ==============================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/shared/constants/layout.dart';
import 'package:shared/shared/constants/map_options.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:tajwal_rider/features/ride_location/base/controllers/base_ride_location_controller.dart';
import 'package:tajwal_rider/features/ride_location/widgets/ride_location_box_widget.dart';

abstract class BaseRideLocationScreen<T extends BaseRideLocationController>
    extends StatelessWidget {
  const BaseRideLocationScreen({super.key});

  T get controller => Get.put(Get.find<T>());

  String get hintText;
  String get buttonText;
  bool get isButtonDisabled;
  VoidCallback get onButtonTap;

  Set<Marker> get markers;
  Set<Polygon> get polygons;
  void Function(GoogleMapController) get onMapCreated;
  void Function(LatLng) get onMapTap;
  TextEditingController get textController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: MapOptions.initialPosition,
                zoom: MapOptions.cameraZoom,
              ),
              onMapCreated: onMapCreated,
              markers: markers,
              polygons: polygons,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: onMapTap,
            ),
            RideLocationBoxWidget(
              hintText: hintText,
              textController: textController,
              onLocTap: (title, lat, lng) {
                FocusScope.of(context).unfocus();
                onLocationSelected(title, lat, lng);
              },
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: AppSize.width,
                child: buttonWidget(
                  disabled: isButtonDisabled,
                  text: buttonText,
                  onTap: onButtonTap,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void onLocationSelected(String title, double lat, double lng);
}
