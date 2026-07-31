// lib/features/splash_screen/binding/splash_binding.dart
import 'package:get/get.dart';
import 'package:tajwal_rider/features/config/config_controller.dart';
import 'package:tajwal_rider/features/orders/current_order/controller/current_order_controller.dart';
import 'package:tajwal_rider/features/splash_screen/controller/splash_screen_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppConfigController(),permanent: true);
    
    Get.put<SplashScreenController>(
      SplashScreenController()
    );
    Get.put(CurrentOrderController(),permanent: true);
  }
}