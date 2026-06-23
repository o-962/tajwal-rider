// lib/features/trip_setup/ride_summary/binding/receipt_binding.dart
import 'package:get/get.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/controllers/receipt_controller.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/services/receipt_service.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class ReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptController>(
      () => ReceiptController(
        receiptService: ReceiptService(),
        rideService: Get.find<RideService>(),
      ),
    );
  }
}
