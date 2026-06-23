// lib/features/splash_screen/services/splash_services.dart
import 'package:get/get.dart';
import 'package:shared/core/crashlytics/crashlytics.dart';
import 'package:tajwal_rider/common/navigation/navigation_service.dart';
import 'package:tajwal_rider/models/init_model.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';
import 'package:tajwal_rider/services/ride/ride_socket_service.dart';

class SplashServices extends GetxService {
  Future<void> initializeApp(Map<String, dynamic>? data, String? redirect) async {
    final nav = Get.find<NavigationService>();
    try {

      if (data == null) {
        nav.toError();
        return;
      }
      final initRiderResponse = InitRiderResponse.fromJson(data);
      final rideService = Get.put<RideService>(RideService(), permanent: true);
      rideService.applyInit(initRiderResponse);
      Get.put<RideSocketService>(
        RideSocketService(rideService: rideService, nav: nav),
        permanent: true,
      );
      if (redirect != null) {
        nav.offAllTo(redirect);
      }
    } catch (e, stackTrace) {
      Crashlytics().logError(e, stackTrace: stackTrace, message: 'Failed to initialize app in SplashServices');
      nav.toError();
    }
  }
}