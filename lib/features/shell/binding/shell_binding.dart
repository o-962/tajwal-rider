import 'package:get/instance_manager.dart';
import 'package:tajwal_rider/features/home/controller/home_controller.dart';
import 'package:tajwal_rider/features/orders/current_order/controller/current_order_controller.dart';
import 'package:tajwal_rider/features/shell/controller/shell_controller.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShellController());
    // HomeScreen is embedded as a shell tab, not navigated to via AppRoutes.home
    // — HomeBinding never runs for it, so the controllers it Get.find() are
    // registered here instead.
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CurrentOrderController());
    Get.lazyPut(() => HomeController());
  }
}
