import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/utils/parsing.dart';

typedef MapInterface = Map<String, List<LatLng>>;

class InitRiderResponse {
  final MapInterface map;
  final Map<String, Map<String, RideCost>> costs;
  final Map<String, List<String>> allowedAreas;
  final bool auth;

  InitRiderResponse({
    required this.map,
    required this.costs,
    required this.allowedAreas,
    required this.auth,
  });

  factory InitRiderResponse.fromJson(Map<String, dynamic> json) {
    return InitRiderResponse(
      auth: json['auth'] ?? false,
      map: MapModel.fromJson(json['map'] is Map ? Map<String, dynamic>.from(json['map']) : {}).areas,
      costs: _parseCosts(json['costs']),
      allowedAreas: _parseAllowedAreas(json['allowed_areas']),
    );
  }

  static Map<String, Map<String, RideCost>> _parseCosts(dynamic json) {
    if (json == null || json is! Map) return {};
    return json.map(
      (key, value) => MapEntry(
        key.toString(),
        (value as Map).map(
          (k, v) => MapEntry(
            k.toString(), 
            RideCost.fromJson(Map<String, dynamic>.from(v))
          ),
        ),
      ),
    );
  }

  static Map<String, List<String>> _parseAllowedAreas(dynamic json) {
    if (json == null || json is! Map) return {};
    return json.map(
      (key, value) => MapEntry(
        key.toString(),
        (value as List).map((e) => e.toString()).toList(),
      ),
    );
  }
}

class MapModel {
  final MapInterface areas;

  MapModel({required this.areas});

  factory MapModel.fromJson(Map<String, dynamic> json) {
    final MapInterface polygons = {};

    json.forEach((key, value) {
      if (value is List) {
        final List<LatLng> parsed = [];
        for (final p in value) {
          if (p is Map) {
            final lat = p['lat'];
            final lng = p['lng'];
            if (lat is num && lng is num) {
              parsed.add(LatLng(lat.toDouble(), lng.toDouble()));
            }
          }
        }
        if (parsed.isNotEmpty) {
          polygons[key] = parsed;
        }
      }
    });

    return MapModel(areas: polygons);
  }
}

class RideCost {
  final double driverMale;
  final double driverFemale;
  final int male;
  final int female;
  final double giftFast;
  final double giftNormal;
  final double fullRide;

  RideCost({
    required this.driverMale,
    required this.driverFemale,
    required this.male,
    required this.female,
    required this.giftFast,
    required this.giftNormal,
    required this.fullRide,
  });

  factory RideCost.fromJson(Map<String, dynamic> json) {
    print(json);
    return RideCost(
      driverMale: toDouble(json['driver_male']),
      driverFemale: toDouble(json['driver_female']),
      male: toInt(json['male']),
      female: toInt(json['female']),
      giftFast: toDouble(json['gift_fast']),
      giftNormal: toDouble(json['gift_normal']),
      fullRide: toDouble(json['full_ride']),
    );
  }

  Map<String, dynamic> toJson() => {
    'driver_male': driverMale,
    'driver_female': driverFemale,
    'male': male,
    'female': female,
    'gift_fast': giftFast,
    'gift_normal': giftNormal,
    'full_ride': fullRide,
  };
}