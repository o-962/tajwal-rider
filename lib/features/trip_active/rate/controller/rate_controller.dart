import 'package:get/get.dart';
import 'package:tajwal_rider/common/navigation/navigation_service.dart';

class RateController extends GetxController {
  final NavigationService _nav;

  RateController(this._nav);

  void done() => _nav.toPickup();
}
