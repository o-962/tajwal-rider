import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/order_summary/controller/order_summary_controller.dart';

class OrderSummaryBinding extends Bindings {
  @override
  void dependencies() {
    // The flow being confirmed registers itself as the OrderSummaryTarget before
    // navigating here (see PassengersOrderController.openSummary), so this
    // controller resolves whichever flow is active.
    Get.lazyPut(() => OrderSummaryController(), fenix: true);
  }
}
