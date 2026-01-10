import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/common/enums.dart';
import 'package:shared/services/notification_services.dart';
import 'package:tajwal_rider/services/ride_services.dart';
import 'package:tajwal_rider/utils/ride_utils.dart';

class DropoffController extends GetxController {
  late GoogleMapController mapController;
  RxSet<Marker> markers = <Marker>{}.obs;


  
  final Map<String, List<LatLng>> polygons = {};
  RxSet<Polygon> polygonSet = <Polygon>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPolygons();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void updateMarker(LatLng position) {
    markers.value = {Marker(markerId: MarkerId('marker'), position: position)};
  }

  void onMapTapped(LatLng position) {
    String cityName = isPointInCity(position);
    
    if (cityName.isNotEmpty) {
      markers.value = {Marker(markerId: MarkerId('dropoff'), position: position)};
      RideServices.setDropoffLocation(
        cityName,
        position.latitude,
        position.longitude,
      );
    }
    
  }

  String isPointInCity(LatLng point) {
    for (var entry in polygons.entries) {
      if (isPointInPolygon(point, entry.value)) {
        return entry.key;
      }
    }
    markers.clear();
    NotificationServices.snackBarMessage(
      header: "Unavailable location",
      message: "Please select a location inside the service area",
      messageStatus: MessageStatusType.alert,
    );
    return "";
  }

  void _loadPolygons() {
    final rawData = RideServices.polygons;
    
    rawData.forEach((cityName, coords) {
      if (cityName == RideServices.ride.pickupLocation) {
        return;
      }
      List<LatLng> cityPolygon = coords;
      polygons[cityName] = cityPolygon;

      polygonSet.add(
        Polygon(
          polygonId: PolygonId(cityName),
          points: cityPolygon,
          strokeWidth: 2,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.1),
        ),
      );
    });
  }
}
