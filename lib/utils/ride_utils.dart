import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/core/crashlytics/crashlytics.dart';
import 'package:shared/core/env/app_env.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/utils/logger.dart';

bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
  if (polygon.isEmpty) return false;

  int intersectCount = 0;
  double x = point.longitude;
  double y = point.latitude;

  for (int i = 0; i < polygon.length; i++) {

    int j = (i + 1) % polygon.length;
    double xi = polygon[i].longitude;
    double yi = polygon[i].latitude;
    double xj = polygon[j].longitude;
    double yj = polygon[j].latitude;
    if ((yi > y) != (yj > y) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi)) {
      intersectCount++;
    }
    
  }

  return intersectCount % 2 == 1;
}

Future<List<Map<String, dynamic>>> getNearbyPlacesWithDetails(String location) async {
  try {
    final apiKey = AppEnv.googleMapApi;
    final response = await ApiServices.dio.get(
      'https://maps.googleapis.com/maps/api/place/textsearch/json',
      queryParameters: {
        'query': location,
        'key': apiKey,
      },
    );

    final results = response.data['results'] ?? [];
    AppLogger.debug('Nearby places fetched successfully for location: $location');

    return results.take(5).map<Map<String, dynamic>>((place) {
      return {
        'name': place['name'],
        'lat': place['geometry']['location']['lat'],
        'lng': place['geometry']['location']['lng'],
      };
    }).toList();
  } catch (e, stackTrace) {
    AppLogger.error('Error fetching nearby places for $location', error: e, stackTrace: stackTrace);
    Crashlytics().logError(e, stackTrace: stackTrace);
    return []; // Return empty list on error
  }
}