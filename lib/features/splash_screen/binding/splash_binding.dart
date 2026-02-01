import 'package:get/get.dart';
import 'package:shared/features/splash_screen/controllers/splash_screen_controller.dart';
import 'package:tajwal_rider/features/splash_screen/services/splash_services.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashServices>(SplashServices());

    Get.put<SplashScreenController>(
      SplashScreenController(
        initializeApp: (data , redirect) {
          print("GOING TO $redirect");
          Get.find<SplashServices>().initializeApp(data , redirect);
        },
      ),
    );
  }
}
