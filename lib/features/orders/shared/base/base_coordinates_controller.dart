import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/models/message_dto.dart';
import 'package:shared/shared/constants/map_options.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:shared/shared/services/notification_service.dart';
import 'package:shared/utils/parsing.dart';
import 'package:tajwal_rider/features/config/config_controller.dart';
import 'package:tajwal_rider/utils/map_utils.dart';

abstract class BaseCoordinatesController extends GetxController {
  late GoogleMapController mapController;

  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polygon> polygonSet = <Polygon>{}.obs;

  /// Service-area rings by city, parsed from the backend `map` config.
  final Map<String, List<LatLng>> polygons = {};

  final TextEditingController textEditingController = TextEditingController();
  final RxBool hasLocation = false.obs;

  final AppConfigController _appConfig = Get.find<AppConfigController>();

  String get markerId;

  /// City to hide from this screen's map (e.g. dropoff hides the pickup city).
  String? get excludedCity => null;

  void onValidLocation(String city, double lat, double lng);

  @override
  void onInit() {
    super.onInit();
    loadPolygons();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Builds [polygons] + [polygonSet] from `AppConfigDto.map`
  /// (`{ city: [{lat, lng}, ...] }`).
  void loadPolygons() {
    polygons.clear();
    polygonSet.clear();

    _appConfig.config.map.forEach((city, points) {
      if (points is! List) return;
      if (excludedCity != null && city == excludedCity) return;
      final ring = points
          .whereType<Map>()
          .map((p) => LatLng(toDouble(p['lat']), toDouble(p['lng'])))
          .toList();
      if (ring.isEmpty) return;

      polygons[city] = ring;
      polygonSet.add(
        Polygon(
          polygonId: PolygonId(city),
          points: ring,
          strokeWidth: MapOptions.polygonStrokeWidth,
          strokeColor: MapOptions.polygonStrokeColor,
          fillColor: MapOptions.polygonFillColor.withValues(alpha: 0.12),
        ),
      );
    });
  }

  /// Returns the city whose polygon contains [point], or null if outside all.
  String? _resolveCity(LatLng point) {
    for (final entry in polygons.entries) {
      if (isPointInPolygon(point, entry.value)) return entry.key;
    }
    return null;
  }

  void updateMarker(LatLng position) {
    markers.value = {Marker(markerId: MarkerId(markerId), position: position)};
    hasLocation.value = true;
  }

  void handleMapTap(LatLng position) {
    final city = _resolveCity(position);
    if (city == null) {
      markers.clear();
      hasLocation.value = false;
      _notifyInvalidLocation();
      return;
    }

    updateMarker(position);
    textEditingController.text =
        '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
    onValidLocation(city, position.latitude, position.longitude);
  }

  void updateLocation(String title, double lat, double lng) {
    final city = _resolveCity(LatLng(lat, lng));
    if (city == null) {
      _notifyInvalidLocation();
      return;
    }

    textEditingController.text = title;
    updateMarker(LatLng(lat, lng));
    onValidLocation(city, lat, lng);

    Future.delayed(const Duration(milliseconds: 100), () {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), MapOptions.selectZoom),
      );
    });
  }

  void _notifyInvalidLocation() {
    NotificationService.message(
      MessageDto(
        toastHead: 'location_invalid'.tr,
        toastType: ToastTypes.ALERT,
        toastBody: 'location_outside_service_area'.tr,
      ),
    );
  }
}
