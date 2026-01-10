import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/models/api_response_model.dart';
import 'package:shared/services/shared_data.dart';
import 'package:shared/services/translations_services.dart';
import 'package:tajwal_rider/services/ride_services.dart';

String initUtils(ApiModel model){
  Map data = model.data!;
  print(data);
  if (data['map'] != null) {
    Map rawMap = data['map'];
    for (var entry in rawMap.entries) {
      RideServices.polygons[entry.key] = (entry.value as List) .map((e) => LatLng(e[1], e[0])) .toList();
    }
  }
  if (data['costs'] != null) {
    RideServices.costs.value = data['costs'];
  }
  if (data['translations'] != null) {
    AppTranslations().addTranslations(data['translations']);
  }
  if (data['fields'] != null && data['fields'].isNotEmpty) {
    SharedData.fields = data['fields'];
  }
  print(model.redirect);
  return model.redirect!;
}