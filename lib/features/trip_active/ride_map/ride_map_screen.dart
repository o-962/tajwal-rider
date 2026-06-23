import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/shared/constants/map_options.dart';
import 'package:shared/widgets/sheet_widget.dart';
import 'package:shared/widgets/spinner_widget.dart';
import 'package:tajwal_rider/features/trip_active/ride_map/controllers/ride_map_controller.dart';
import 'package:tajwal_rider/features/trip_active/ride_map/widgets/call_driver_button_widget.dart';
import 'package:tajwal_rider/features/trip_active/ride_map/widgets/driver_info_header_widget.dart';
import 'package:tajwal_rider/features/trip_active/ride_map/widgets/driver_stats_widget.dart';
import 'package:tajwal_rider/features/trip_active/ride_map/widgets/map_menu_button_widget.dart';

class RideMapScreen extends StatelessWidget {
  
  RideMapController controller = Get.find<RideMapController>();

  RideMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            Obx(
              () => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: MapOptions.initialPosition,
                  zoom: MapOptions.cameraZoom,
                ),
                onMapCreated: controller.onMapCreated,
                myLocationEnabled: controller.myLocation.value,
                markers: controller.markers.value,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
              ),
            ),
            // Menu button (top-left)
            const MapMenuButtonWidget(),
        
            sheetWidget(
              maxChildSize: 0.7,
              minChildSize: 0.15,
              initialChildSize: 0.30,
              builder: (scrollController) => Obx(() {
                final driver = controller.driverModule.value;
                if (driver == null) {
                  return spinnerWidget();
                }
                return ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    // Driver header with avatar and basic info
                    DriverInfoHeaderWidget(driver: driver),
        
                    // Stats cards
                    DriverStatsWidget(driver: driver),
        
                    const SizedBox(height: 16),
        
                    // Call button
                    CallDriverButtonWidget(
                      phoneNumber: driver.driverPhoneNumber,
                    ),
        
                    const SizedBox(height: 20),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
