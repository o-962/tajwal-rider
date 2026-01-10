import 'package:get/get.dart';
import 'package:shared/common/enums.dart';
import 'package:shared/services/socket_connection_services.dart';
import 'package:tajwal_rider/common/routes.dart';

class PendingController {

  void waitingForAcceptance(){
    SocketConnectionServices.socket.emit(SocketEvents.RIDER_INIT.value);
    SocketConnectionServices.socket.on(
      SocketEvents.ORDER_ACCEPTED.value,
      (x) {
        print('ORDER ACCEPTED');
        if (Get.currentRoute != AppRoutes.ride_map) {
          Get.offAllNamed(AppRoutes.ride_map);
        }
      },
    );
  }

  void cancelOrder(){
    SocketConnectionServices.socket.emit(SocketEvents.ORDER_CANCELLED.value);
  }
}