// lib/services/rides/ride_services.dart
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/core/crashlytics/crashlytics.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/models/driver_model.dart';
import 'package:shared/shared/enums/index.dart';
import 'package:shared/shared/services/config_service.dart';
import 'package:shared/utils/logger.dart';
import 'package:tajwal_rider/models/init_model.dart' hide LatLng;
import 'package:tajwal_rider/models/ride_model.dart';

part 'ride_cancellation_service.dart';
part 'ride_gender_service.dart';
part 'ride_location_service.dart';
part 'ride_pricing_service.dart';
part 'ride_validation_service.dart';

class RideService extends GetxService {
  final RidePreferences ride = RidePreferences();
  final Rxn<DriverModel> currentDriver = Rxn<DriverModel>();
  final canSubmit = false.obs;
  final costs = <String, dynamic>{}.obs;
  final Map<String, List<LatLng>> polygons = {};
  final ConfigService configService = Get.find<ConfigService>();
  void applyInit(InitRiderResponse data) {
    try {
      polygons.clear();
      polygons.addAll(data.map);
      costs.assignAll(data.costs);
      AppLogger.debug('RideService initialization data applied successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Error applying init data in RideService', error: e, stackTrace: stackTrace);
      Crashlytics().logError(e, stackTrace: stackTrace);
    }
  }

  void reset() {
    ride.reset();
    canSubmit.value = false;
  }
}
