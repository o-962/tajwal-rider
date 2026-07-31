import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/shared/base/base_coordinates_screen.dart';
import 'package:tajwal_rider/features/orders/shared/pickup/controller/pickup_controller.dart';

class PickupScreen extends BaseCoordinatesScreen<PickupController> {
  const PickupScreen({super.key});

  @override
  PickupController get controller => Get.find<PickupController>();

  @override
  String get title => 'pickup_location';

  @override
  String get hintText => 'search_pickup_location';

  @override
  String get buttonText => 'confirm';
}
