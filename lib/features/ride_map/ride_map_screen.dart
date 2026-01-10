import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/widgets/sheet_widget.dart';
import 'package:shared/widgets/spinner_widget.dart';
import 'package:tajwal_rider/features/ride_map/controllers/ride_map_controller.dart';

class RideMapScreen extends StatelessWidget {
  final RideMapController controller = Get.put(RideMapController());
  RideMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(31.95, 35.91),
                zoom: 8,
              ),
              onMapCreated: controller.onMapCreated,
              myLocationEnabled: controller.myLocation.value,
              markers: controller.markers.value,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),

          sheetWidget(
            maxChildSize: 0.5,
            minChildSize: 0.15,
            initialChildSize: 0.30,
            builder: (scrollController) => Obx(() {
              final driver = controller.driverModule.value;
              if (driver == null) {
                return spinnerWidget();
              }
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                                    'assets/images/default_driver.png',
                                  )
                                  as ImageProvider,
                      ),
                      const SizedBox(height: 12),

                      // Driver basic info
                      Text(
                        'Driver: ${driver.driverPhoneNumber}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gender: ${driver.gender}',
                      ),
                      Text(
                        'Status: ${driver.status.toString().split('.').last}',
                      ),
                      Text('Rating: ${driver.rating} ⭐'),
                      const SizedBox(height: 8),

                      // Other info in a row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          
                          Column(
                            children: [
                              const Text('Seats'),
                              Text('${driver.carSeats}/${driver.maxSeats}'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Call button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // implement call logic
                          },
                          icon: const Icon(Icons.phone),
                          label: Text('Call ${driver.driverPhoneNumber}'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            
            }),
          ),
        ],
      ),
    );
  }
}
