import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/models/message_dto.dart';
import 'package:shared/shared/constants/map_options.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:shared/shared/services/notification_service.dart';
import 'package:shared/utils/parsing.dart';
import 'package:tajwal_rider/features/config/config_controller.dart';
import 'package:tajwal_rider/features/orders/shared/base/order_location_target.dart';
import 'package:tajwal_rider/utils/map_utils.dart';

abstract class BaseCoordinatesController extends GetxController {
  late GoogleMapController mapController;

  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polygon> polygonSet = <Polygon>{}.obs;

  /// Service-area rings this screen actually offers, by city.
  final Map<String, List<LatLng>> polygons = {};

  /// EVERY parsed ring, including the ones this screen filters out.
  ///
  /// Kept so a tap can tell "nowhere we serve" apart from "a real area you just
  /// can't get to from here" — otherwise an unreachable city reports the same
  /// "outside our service area" as the middle of the desert, which is both wrong
  /// and unactionable.
  final Map<String, List<LatLng>> _allRings = {};

  final TextEditingController textEditingController = TextEditingController();
  final RxBool hasLocation = false.obs;

  final AppConfigController appConfig = Get.find<AppConfigController>();

  String get markerId;

  /// Whether this screen may offer [city]. Default: every area with a polygon.
  ///
  /// Replaces the old single `excludedCity`, which could only ever hide one area
  /// — enough for "dropoff hides the pickup city", but not for "hide every city
  /// with no priced route from the pickup".
  bool isCitySelectable(String city) => true;

  /// Shown when a tap lands inside a real area this screen isn't offering.
  /// Takes the city so a screen can distinguish *why* it filtered it out.
  String unavailableCityMessage(String city) => 'location_outside_service_area'.tr;

  /// This leg's existing choice, restored on entry. Null when unchosen.
  LocationSelection? get existingSelection => null;

  void onValidLocation(String city, double lat, double lng);

  /// Where to point the camera once the map exists.
  ///
  /// The restore runs in [onInit], but [mapController] isn't assigned until
  /// [onMapCreated] — moving the camera straight away would throw on a late-init
  /// field, so the target is parked here and consumed when the map is ready.
  LatLng? _pendingCamera;

  @override
  void onInit() {
    super.onInit();
    loadPolygons();
    _restoreSelection();
  }

  /// Put the rider's existing pin back.
  ///
  /// These controllers are `fenix: true`, so leaving the screen disposes them
  /// and returning builds a fresh one — which used to come up with an empty
  /// marker set and an empty search box, as if nothing had ever been chosen,
  /// even though the order still held the coordinates.
  void _restoreSelection() {
    final selection = existingSelection;
    if (selection == null) return;

    final point = LatLng(selection.lat, selection.lng);
    textEditingController.text = selection.label;
    updateMarker(point);
    _pendingCamera = point;
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Frame the restored pin now that there is a map to move.
    final target = _pendingCamera;
    if (target != null) {
      _pendingCamera = null;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(target, MapOptions.selectZoom),
      );
    }
  }

  /// Builds [polygons] + [polygonSet] from `AppConfigDto.map`
  /// (`{ city: [{lat, lng}, ...] }`).
  void loadPolygons() {
    polygons.clear();
    polygonSet.clear();
    _allRings.clear();

    appConfig.config.map.forEach((city, points) {
      if (points is! List) return;
      final ring = points
          .whereType<Map>()
          .map((p) => LatLng(toDouble(p['lat']), toDouble(p['lng'])))
          .toList();
      if (ring.isEmpty) return;

      // Recorded before the filter so an unreachable city can still be
      // identified on tap and explained properly.
      _allRings[city] = ring;
      if (!isCitySelectable(city)) return;

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
      _notifyInvalidLocation(position);
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
      _notifyInvalidLocation(LatLng(lat, lng));
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

  /// The real area a refused tap landed in, if it landed in one this screen
  /// filtered out. Null means the tap was genuinely nowhere we serve.
  String? _filteredCityAt(LatLng point) {
    for (final entry in _allRings.entries) {
      if (polygons.containsKey(entry.key)) continue;
      if (isPointInPolygon(point, entry.value)) return entry.key;
    }
    return null;
  }

  /// A tap we refused. Distinguishes the reasons, because "outside our service
  /// area" is simply untrue for a city we do serve but are hiding here — and
  /// leaves the rider with nothing to act on.
  void _notifyInvalidLocation(LatLng point) {
    final filtered = _filteredCityAt(point);

    NotificationService.message(
      MessageDto(
        toastHead: 'location_invalid'.tr,
        toastType: ToastTypes.ALERT,
        toastBody: filtered != null
            ? unavailableCityMessage(filtered)
            : 'location_outside_service_area'.tr,
      ),
    );
  }
}
