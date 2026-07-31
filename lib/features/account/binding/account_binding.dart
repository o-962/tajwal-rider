import 'package:get/get.dart';
import 'package:tajwal_rider/features/account/controller/account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    // fenix rebuilds the controller on a fresh visit so it re-fetches.
    Get.lazyPut(() => AccountController(), fenix: true);
  }
}
