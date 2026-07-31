import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/shared/base/base_coordinates_screen.dart';
import 'package:tajwal_rider/features/orders/shared/dropoff/controller/dropoff_controller.dart';

class DropoffScreen extends BaseCoordinatesScreen<DropoffController> {
  const DropoffScreen({super.key});

  @override
  DropoffController get controller => Get.find<DropoffController>();

  @override
  String get title => 'dropoff_location';

  @override
  String get hintText => 'search_dropoff_location';

  @override
  String get buttonText => 'confirm';
}
