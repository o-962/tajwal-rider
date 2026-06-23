// lib/features/main-settings/controller/settings_controller.dart
import 'package:get/get.dart';
import 'package:shared/shared/services/token_service.dart';
import 'package:tajwal_rider/common/navigation/navigation_service.dart';

class SettingsController extends GetxController {
  final AuthService _authService;
  final NavigationService _nav;

  SettingsController({
    required AuthService authService,
    required NavigationService nav,
  })  : _authService = authService,
        _nav = nav;

  void logout() {
    _authService.logout();
    _nav.toSplash();
  }

  void toChangePassword() => _nav.toChangePassword();

  void toChangePhone() => _nav.toChangePhone();

  void toHistory() => _nav.toHistory();

  void toRemoveAccount() => _nav.toRemoveAccount();
}
