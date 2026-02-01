// lib/services/rides/ride_services.dart
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/models/ride_model.dart';

part 'ride_location_service.dart';
part 'ride_validation_service.dart';
part 'ride_pricing_service.dart';
part 'ride_gender_service.dart';

class RideService extends GetxService {
  
  final RidePreferences ride = RidePreferences();
  final canSubmit = false.obs;
  final costs = <String, dynamic>{}.obs;
  final Map<String, List<LatLng>> polygons = {};


  void applyInit(Map<dynamic, dynamic> data) {
    final rawMap = data['map'];
    if (rawMap is Map) {
      polygons.clear();
      for (final entry in rawMap.entries) {
        final key = entry.key.toString();
        final value = entry.value;
        if (value is List) {
          polygons[key] = value .whereType<List>() .where((e) => e.length >= 2) .map((e) => LatLng((e[1] as num).toDouble(), (e[0] as num).toDouble())) .toList();
        }
      }
    }
    final rawCosts = data['costs'];
    if (rawCosts is Map) {
      costs.assignAll(Map<String, dynamic>.from(rawCosts));
    }
  }

  void reset() {
    ride.reset();
    canSubmit.value = false;
  }
}