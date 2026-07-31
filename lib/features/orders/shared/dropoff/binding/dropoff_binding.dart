import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/shared/dropoff/controller/dropoff_controller.dart';

class DropoffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DropoffController>(() => DropoffController());
  }
}
