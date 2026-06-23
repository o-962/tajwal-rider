// lib/features/trip_waiting/ride_pending_acceptance/controllers/pending_controller.dart
import 'package:shared/base/base_controller.dart';
import 'package:shared/core/socket/socket_gateway.dart';
import 'package:shared/shared/constants/socket_events.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class PendingController extends BaseController {
  final RideService _rideService;

  PendingController(this._rideService);

  @override
  void onInit() {
    super.onInit();
    SocketGateway.emit(SocketEvents.RIDER_INIT);
  }

  void cancelOrder() => _rideService.cancelOrder();
}
