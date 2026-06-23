// lib/features/main-settings/binding/settings_binding.dart
import 'package:get/get.dart';
import 'package:shared/shared/services/token_service.dart';
import 'package:tajwal_rider/common/navigation/navigation_service.dart';
import 'package:tajwal_rider/features/main_settings/controller/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        authService: Get.find<AuthService>(),
        nav: Get.find<NavigationService>(),
      ),
    );
  }
}
