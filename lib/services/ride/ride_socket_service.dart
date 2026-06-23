// lib/services/ride/ride_socket_service.dart
import 'package:get/get.dart';
import 'package:shared/core/crashlytics/crashlytics.dart';
import 'package:shared/core/socket/socket_gateway.dart';
import 'package:shared/models/driver_model.dart';
import 'package:shared/shared/constants/socket_events.dart';
import 'package:shared/shared/enums/order_status.dart';
import 'package:shared/utils/parsing.dart';
import 'package:tajwal_rider/common/navigation/navigation_service.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class RideSocketService extends GetxService {
  final RideService _rideService;
  final NavigationService _nav;

  RideSocketService({
    required RideService rideService,
    required NavigationService nav,
  })  : _rideService = rideService,
        _nav = nav;

  @override
  void onInit() {
    super.onInit();
    _registerListeners();
  }

  void _registerListeners() {
    SocketGateway.on(SocketEvents.ORDER_DETAILS, _onOrderDetails);
    SocketGateway.on(SocketEvents.ORDER_ACCEPTED, (_) => _nav.toRideMap());
    SocketGateway.on(SocketEvents.ORDER_STATUS, _onOrderStatus);
  }

  void _onOrderDetails(dynamic data) {
    try {
      final driver = DriverModel.fromJson(data);
      _rideService.currentDriver.value = driver;
      _nav.toRideMap();
    } catch (e, stackTrace) {
      Crashlytics().logError(e, stackTrace: stackTrace, message: 'Failed to parse ORDER_DETAILS');
    }
  }

  void _onOrderStatus(dynamic data) {
    final status = parseEnum<OrderStatus>(OrderStatus.values, data.toString()) ?? OrderStatus.PENDING;
    if (status == OrderStatus.COMPLETED) {
      _nav.toRate();
    }
  }
}