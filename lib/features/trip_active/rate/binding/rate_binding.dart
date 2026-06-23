import 'package:get/get.dart';
import 'package:tajwal_rider/common/navigation/navigation_service.dart';
import 'package:tajwal_rider/features/trip_active/rate/controller/rate_controller.dart';

class RateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RateController>(
      () => RateController(Get.find<NavigationService>()),
    );
  }
}
