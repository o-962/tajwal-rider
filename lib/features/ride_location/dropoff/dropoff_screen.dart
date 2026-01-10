import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/common/media_query.dart';
import 'package:tajwal_rider/common/routes.dart';
import 'package:tajwal_rider/features/ride_location/controllers/dropoff_controller.dart';
import 'package:tajwal_rider/features/ride_location/widgets/ride_location_box_widget.dart';
import 'package:tajwal_rider/services/ride_services.dart';
import 'package:shared/widgets/button_widget.dart';

class DropoffScreen extends StatelessWidget {
  DropoffScreen({super.key});

  final DropoffController controller = Get.put(DropoffController());
  final TextEditingController _textEditingController = TextEditingController();
  final LatLng initialPosition = LatLng(31.9539, 35.9106);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 5,
              ),
              onMapCreated: controller.onMapCreated,
              markers: controller.markers.value,
              polygons: controller.polygonSet,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: (LatLng position) {
                if (controller.isPointInCity(position).isNotEmpty) {
                  _textEditingController.text = "${position.latitude},${position.longitude}";
                  controller.onMapTapped(position);
                }
              },
            ),
            RideLocationBoxWidget(
              hintText: 'Drop off location',
              textController: _textEditingController,
              onLocTap: (title, lat, lng) {
                
                if (controller.isPointInCity(LatLng(lat, lng)).isNotEmpty) {
                  RideServices.ride.dropoffLat = lat;
                  RideServices.ride.dropoffLng = lng;
                  RideServices.ride.dropoffLocation = title;
                  _textEditingController.text = title;
                  controller.updateMarker(LatLng(lat,lng));
                  FocusScope.of(context).unfocus();
                  Future.delayed(Duration(milliseconds: 100), () {
                    controller.mapController.moveCamera(
                      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0),
                    );
                  });
                }
              },
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: AppSize.width,
                child: buttonWidget(
                  text: 'Choose drop off location',
                  onTap: () => Get.toNamed(AppRoutes.options),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
