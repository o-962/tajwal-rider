import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/core/socket/socket_gateway.dart';
import 'package:shared/models/driver_model.dart';
import 'package:shared/shared/enums/socket_events.dart';
import 'package:tajwal_rider/common/routes.dart';
class RideMapController extends GetxController {
  final Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);
  final RxBool myLocation = true.obs;

  var markers = <Marker>{}.obs;

  final driverModule = Rxn<DriverModel>();

  @override
  void onInit() {
    super.onInit();
    SocketGateway.on(
      SocketEvents.DRIVER_UPDATE_LOCATION,
      (data) {
        print(' Received location update: $data');
        // Backend emits plain { lat, lng, driverId } for location updates
        final latRaw = data['lat'];
        final lngRaw = data['lng'];
        if (latRaw == null || lngRaw == null) return;

        final double lat = (latRaw as num).toDouble();
        final double lng = (lngRaw as num).toDouble();

        markers.value = {
          Marker(
            markerId: const MarkerId('driver'),
            position: LatLng(lat, lng),
          ),
        };
        markers.refresh();
        mapController.value?.animateCamera(
          CameraUpdate.newLatLng(LatLng(lat, lng)),
        );
      },
    );  
    SocketGateway.emit(SocketEvents.RIDER_INIT);
    SocketGateway.on(SocketEvents.ORDER_DETAILS, (
      data,
    ) {
      try {
        final orderPayload = data['order'] ?? data;
        driverModule.value = DriverModel.fromJson(orderPayload);
        driverModule.refresh();
        markers.value = {};
        final latRaw = orderPayload['lat'];
        final lngRaw = orderPayload['lng'];
        if (latRaw != null && lngRaw != null) {

          final double lat = (latRaw as num).toDouble();
          final double lng = (lngRaw as num).toDouble();
          markers.value = {
            Marker(
              markerId: const MarkerId('driver'),
              position: LatLng(lat, lng),
            ),
          };
          markers.refresh();
          mapController.value?.animateCamera(
            CameraUpdate.newLatLng(LatLng(lat, lng)),
          );
        }
      } catch (e) {
        print('Error parsing order details: $e');
      }
    });
    SocketGateway.on(SocketEvents.ORDER_STATUS, (
      data,
    ) {
      if(data['new_status'] != null && data['status_code'] == 200){
        if (data['new_status'] == 'completed') {
          if (Get.currentRoute != AppRoutes.rate) {
            Get.offAllNamed(AppRoutes.rate);
          }
        }
      }
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
  }
}
