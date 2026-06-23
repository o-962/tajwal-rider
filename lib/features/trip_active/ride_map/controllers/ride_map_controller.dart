// lib/features/trip_active/ride_map/controllers/ride_map_controller.dart
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/base/base_controller.dart';
import 'package:shared/core/socket/socket_gateway.dart';
import 'package:shared/models/driver_model.dart';
import 'package:shared/models/location_dto.dart';
import 'package:shared/shared/constants/socket_events.dart';
import 'package:shared/shared/enums/socket_events.dart';
import 'package:tajwal_rider/common/navigation/navigation_service.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class RideMapController extends BaseController {
  final NavigationService _nav;
  final RideService _rideService;

  RideMapController({
    required NavigationService nav,
    required RideService rideService,
  })  : _nav = nav,
        _rideService = rideService;

  final Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);
  final RxBool myLocation = true.obs;
  final markers = <Marker>{}.obs;
  final driverModule = Rxn<DriverModel>();

  @override
  void onInit() {
    super.onInit();
    final current = _rideService.currentDriver.value;
    if (current != null) {
      driverModule.value = current;
      _setDriverMarker(current);
    }
    ever(_rideService.currentDriver, (driver) {
      if (driver != null) {
        driverModule.value = driver;
        _setDriverMarker(driver);
      }
    });
    SocketGateway.on(SocketEvents.DRIVER_UPDATE_LOCATION, _onDriverLocation);
    SocketGateway.emit(SocketEvents.RIDER_INIT);
    SocketGateway.onConnect(() => SocketGateway.emit(SocketEvents.RIDER_INIT));
  }

  void _setDriverMarker(DriverModel driver) {
    markers.value = {
      Marker(
        markerId: const MarkerId('driver'),
        position: LatLng(driver.lat, driver.lng),
      ),
    };
    markers.refresh();
    _animateTo(driver.lat, driver.lng);
  }

  void _onDriverLocation(dynamic data) {
    LocationDto location = LocationDto.fromJson(data);
    
    markers.value = {
      Marker(markerId: const MarkerId('driver'), position: LatLng(location.lat, location.lng)),
    };
    markers.refresh();
    _animateTo(location.lat, location.lng);
  }

  void cancelOrder() => _rideService.cancelOrder();

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
  }

  void _animateTo(double lat, double lng) {
    final ctrl = mapController.value;
    if (ctrl == null) return;
    try {
      ctrl.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    } catch (_) {
      // Map widget was disposed before the camera move could execute.
      mapController.value = null;
    }
  }

  @override
  void onClose() {
    mapController.value = null;
    super.onClose();
  }
}
