import 'package:get/get.dart';
import 'package:tajwal_rider/features/history/controller/rider_history_controller.dart';

class RiderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    // fenix rebuilds the controller on a fresh visit so the list re-fetches.
    Get.lazyPut(() => RiderHistoryController(), fenix: true);
  }
}
