import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/common/enums.dart';
import 'package:shared/models/driver_model.dart';
import 'package:shared/services/socket_connection_services.dart';
import 'package:tajwal_rider/common/routes.dart';

class RideMapController extends GetxController {
  final Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);
  final RxBool myLocation = true.obs;
  final CameraPosition initialPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco
    zoom: 12,
  );

  var markers = <Marker>{}.obs;

  final driverModule = Rxn<DriverModel>();

  @override
  void onInit() {
    super.onInit();
    SocketConnectionServices.socket.on(
      SocketEvents.DRIVER_UPDATE_LOCATION.value,
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
    SocketConnectionServices.socket.emit(SocketEvents.RIDER_INIT.value);
    SocketConnectionServices.socket.on(SocketEvents.ORDER_DETAILS.value, (
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

      // else if (apiResponse.code == OrderExistence.no_order.value) {
      //   if (Get.currentRoute != AppRoutes.pickup) {
      //     Get.offAllNamed(AppRoutes.pickup);
      //   }
      // }
      // else if (apiResponse.code == OrderExistence.pending.value){
      //   if (Get.currentRoute != AppRoutes.pending) {
      //     Get.offAllNamed(AppRoutes.pending);
      //   }
      // }
    });
    SocketConnectionServices.socket.on(SocketEvents.ORDER_STATUS.value, (
      data,
    ) {
      print(data);
      if(data['new_status'] != null && data['status_code'] == 200){
        if (data['new_status'] == 'completed') {
          if (Get.currentRoute != AppRoutes.rate) {
            Get.offAllNamed(AppRoutes.rate);
          }
        }
        Get.snackbar('New update', 'Order status updated to be ${data['new_status']}');
        
      }
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
  }
}
