import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/shared/constants/map_options.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:tajwal_rider/features/orders/shared/base/base_coordinates_controller.dart';
import 'package:tajwal_rider/features/orders/shared/widgets/location_search_widget.dart';

abstract class BaseCoordinatesScreen<T extends BaseCoordinatesController>
    extends StatelessWidget {
  const BaseCoordinatesScreen({super.key});

  T get controller;

  String get title;
  String get hintText;
  String get buttonText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title.tr)),
      body: Obx(() {
        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: MapOptions.initialPosition,
                zoom: MapOptions.cameraZoom,
              ),
              onMapCreated: controller.onMapCreated,
              markers: controller.markers.value,
              polygons: controller.polygonSet.value,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onTap: controller.handleMapTap,
            ),

            // ── Search bar ───────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LocationSearchWidget(
                hintText: hintText,
                textController: controller.textEditingController,
                onLocTap: (title, lat, lng) {
                  FocusScope.of(context).unfocus();
                  controller.updateLocation(title, lat, lng);
                },
              ),
            ),

            // ── Confirm button ───────────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Obx(
                () => buttonWidget(
                  text: buttonText,
                  disabled: !controller.hasLocation.value,
                  onTap: () => Get.back(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
