import 'package:get/get.dart';
import 'package:shared/core/socket/socket_gateway.dart';
import 'package:shared/shared/enums/socket_events.dart';
import 'package:tajwal_rider/common/routes.dart';

class PendingController {

  void waitingForAcceptance(){
    SocketGateway.emit(SocketEvents.RIDER_INIT);
    SocketGateway.on( SocketEvents.ORDER_ACCEPTED, (x) {
        if (Get.currentRoute != AppRoutes.rideMap) {
          Get.offAllNamed(AppRoutes.rideMap);
        }
      },
    );
  }

  void cancelOrder(){
    SocketGateway.emit(SocketEvents.ORDER_CANCELLED);
  }
}