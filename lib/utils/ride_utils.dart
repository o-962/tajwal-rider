import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/core/network/api_client.dart';

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
  final apiKey = dotenv.env['GOOGLE_MAP_API'];
  final response = await ApiServices.dio.get(
    'https://maps.googleapis.com/maps/api/place/textsearch/json',
    queryParameters: {
      'query': location,
      'key': apiKey,
    },
  );

  final results = response.data['results'] ?? [];

  return results.take(5).map<Map<String, dynamic>>((place) {
    return {
      'name': place['name'],
      'lat': place['geometry']['location']['lat'],
      'lng': place['geometry']['location']['lng'],
    };
  }).toList();
}