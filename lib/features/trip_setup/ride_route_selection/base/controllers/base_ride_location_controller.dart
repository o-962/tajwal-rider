import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/base/base_controller.dart';
import 'package:shared/core/crashlytics/crashlytics.dart';
import 'package:shared/models/message_dto.dart';
import 'package:shared/shared/constants/map_options.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:shared/shared/services/notification_service.dart';
import 'package:shared/utils/logger.dart';
import 'package:tajwal_rider/models/init_model.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';
import 'package:tajwal_rider/utils/ride_utils.dart';

abstract class BaseRideLocationController extends BaseController {
  late GoogleMapController mapController;

  final RxSet<Marker> markers = <Marker>{}.obs;

  /// polygons data by city
  final Map<String, List<LatLng>> polygons = {};

  /// polygons rendered on map
  final RxSet<Polygon> polygonSet = <Polygon>{}.obs;

  /// Search / manual text
  final TextEditingController textEditingController = TextEditingController();

  final RideService rideService;

  BaseRideLocationController(this.rideService);

  String? get excludedCityName => null;

  String get markerId;

  String get invalidToastHead;
  String get invalidToastBody;
  ToastTypes get invalidToastType => ToastTypes.ALERT;


  void onValidLocation(String cityName, double lat, double lng);



  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    try {
      mapController = controller;
      AppLogger.debug('Map created successfully for $markerId');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error creating map for $markerId',
        error: e,
        stackTrace: stackTrace,
      );
      Crashlytics().logError(e, stackTrace: stackTrace);
    }
  }

  void updateMarker(LatLng position) {
    markers.value = {Marker(markerId: MarkerId(markerId), position: position)};
  }

  /// Single entrypoint for tapping on map (removes duplication)
  void handleMapTap(LatLng position) {
    final cityName = _resolveCity(position);

    if (cityName == null) {
      markers.clear();
      _notifyInvalidLocation();
      return;
    }

    markers.value = {Marker(markerId: MarkerId(markerId), position: position)};

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
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), MapOptions.selectZoom),
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
      MessageDto(
        toastHead: invalidToastHead,
        toastType: invalidToastType,
        toastBody: invalidToastBody,
      ),
    );
  }

  void loadPolygons() {
    try {
      final String? pickupCity = rideService.ride.pickupLocation;
      polygonSet.clear();

      if (pickupCity == null || pickupCity.isEmpty) {
        // 1. No pickup city: Load all source cities (first level of costs)
        for (var sourceCity in rideService.costs.keys) {
          _addPolygon(sourceCity);
        }
        AppLogger.debug('No pickup: Loaded all source area polygons');
      } else {
        // 2. Pickup city exists: Load only allowed destinations for this city
        final Map<String, RideCost>? destinations =
            rideService.costs[pickupCity];
        destinations?.keys.forEach((targetCity) {
          if (excludedCityName != null && targetCity == excludedCityName)
            return;
          _addPolygon(targetCity);
        });
        AppLogger.debug(
          'Pickup set: Loaded allowed destinations for $pickupCity',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error loading polygons',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Helper to keep logic clean
  void _addPolygon(String cityName) {
    final coords = rideService.polygons[cityName];
    if (coords != null) {
      polygons[cityName] = coords;
      polygonSet.add(
        Polygon(
          polygonId: PolygonId(cityName),
          points: coords,
          strokeWidth: MapOptions.polygonStrokeWidth,
          strokeColor: MapOptions.polygonStrokeColor,
          fillColor: MapOptions.polygonFillColor.withOpacity(0.1),
        ),
      );
    }
  }
}
