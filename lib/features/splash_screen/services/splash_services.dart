import 'package:get/get.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class SplashServices extends GetxService {

  Future<void> initializeApp(Map<String, dynamic>? data , String? redirect) async {
    RideService rideService = Get.put<RideService>(RideService());
    if (data == null) return;
    rideService.applyInit(data);
    if (redirect != null) {
      Get.offAllNamed(redirect);
    }
  }
}