// ==============================
// FILE: lib/features/ride_location/controllers/base_ride_location_controller.dart
// ==============================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/models/socket_model.dart';
import 'package:shared/shared/constants/map_options.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:shared/shared/services/notification_service.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';
import 'package:tajwal_rider/utils/ride_utils.dart';

abstract class BaseRideLocationController extends GetxController {
  late GoogleMapController mapController;

  final RxSet<Marker> markers = <Marker>{}.obs;

  /// polygons data by city
  final Map<String, List<LatLng>> polygons = {};

  /// polygons rendered on map
  final RxSet<Polygon> polygonSet = <Polygon>{}.obs;

  /// Search / manual text
  final TextEditingController textEditingController = TextEditingController();

  final RideService rideService = Get.find<RideService>();

  /// Child decides whether to exclude a city polygon (ex: dropoff excludes pickup city)
  String? get excludedCityName => null;

  /// Child decides marker id (pickup / dropoff)
  String get markerId;

  /// Child decides toast messages
  String get invalidToastHead;
  String get invalidToastBody;
  ToastTypes get invalidToastType => ToastTypes.alert;

  /// Child handles what happens after a valid tap/update (set pickup/dropoff, etc.)
  void onValidLocation(String cityName, double lat, double lng);

  @override
  void onInit() {
    super.onInit();
    _loadPolygons();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void updateMarker(LatLng position) {
    markers.value = {
      Marker(markerId: MarkerId(markerId), position: position),
    };
  }

  /// Single entrypoint for tapping on map (removes duplication)
  void handleMapTap(LatLng position) {
    final cityName = _resolveCity(position);

    if (cityName == null) {
      markers.clear();
      _notifyInvalidLocation();
      return;
    }

    markers.value = {
      Marker(markerId: MarkerId(markerId), position: position),
    };

    onValidLocation(cityName, position.latitude, position.longitude);

    // Optional: show coords in field (your old behavior)
    textEditingController.text =
        "${position.latitude.toStringAsFixed(6)} , ${position.longitude.toStringAsFixed(6)}";
  }

  /// Shared method for updating from search result / list item
  void updateLocation(String title, double lat, double lng) {
    final cityName = _resolveCity(LatLng(lat, lng));
    if (cityName == null) {
      markers.clear();
      _notifyInvalidLocation();
      return;
    }

    // Use provided title (place name) as user-visible text
    textEditingController.text = title;

    updateMarker(LatLng(lat, lng));
    onValidLocation(cityName, lat, lng);

    Future.delayed(const Duration(milliseconds: 100), () {
      mapController.moveCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(lat, lng),
          MapOptions.selectZoom,
        ),
      );
    });
  }

  String? _resolveCity(LatLng point) {
    for (final entry in polygons.entries) {
      if (isPointInPolygon(point, entry.value)) {
        return entry.key;
      }
    }
    return null;
  }

  void _notifyInvalidLocation() {
    NotificationService.message(
      MessageModel(
        toastHead: invalidToastHead,
        toastType: invalidToastType,
        toastBody: invalidToastBody,
      ),
    );
  }

  void _loadPolygons() {
    final rawData = rideService.polygons;

    rawData.forEach((cityName, coords) {
      final excluded = excludedCityName;
      if (excluded != null && cityName == excluded) return;

      final cityPolygon = coords;
      polygons[cityName] = cityPolygon;

      polygonSet.add(
        Polygon(
          polygonId: PolygonId(cityName),
          points: cityPolygon,
          strokeWidth: MapOptions.polygonStrokeWidth,
          strokeColor: MapOptions.polygonStrokeColor,
          fillColor: MapOptions.polygonFillColor.withOpacity(0.1),
        ),
      );
    });
  }
}
