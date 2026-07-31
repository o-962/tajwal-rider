import 'package:get/get.dart';
import 'package:tajwal_rider/features/splash_screen/dto/splash_screen_dto.dart';

class AppConfigController extends GetxController {
  final Rx<AppConfigDto> _appConfig = AppConfigDto().obs;

  void setConfig(AppConfigDto config) {
    print(config.costs);
    print(config.map);
    _appConfig.value = config;
  }

  AppConfigDto get config => _appConfig.value;
}