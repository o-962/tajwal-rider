import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/core/network/socket_client.dart';
import 'package:shared/models/api_dto.dart';
import 'package:shared/shared/constants/socket_events.dart';
import 'package:tajwal_rider/features/orders/current_order/model/current_order_model.dart';

/// Owns the rider's single active order.
///
/// The server pushes the order on the `rider:refresh` channel (in reply to our
/// own emit, and again whenever it changes). We keep it null until one arrives,
/// so the "current order" entry point stays hidden by default.
class CurrentOrderController extends GetxController {
  final Rxn<CurrentOrderModel> currentOrder = Rxn<CurrentOrderModel>();

  bool get hasOrder => currentOrder.value != null;

  @override
  void onInit() {
    super.onInit();
    _bind();
  }

  /// Attach only once the socket is actually up.
  ///
  /// SplashBinding registers this controller as `permanent` — which runs onInit
  /// BEFORE SplashScreenController calls SocketClient.connect(). Checking
  /// `isConnected` at that moment is always false, so the listener was never
  /// attached, and a permanent controller's onInit never fires again: the rider
  /// received no `rider:refresh` at all, for the whole app lifetime.
  Future<void> _bind() async {
    await SocketClient.whenConnected;
    _listen();
    refreshCurrentOrder();
  }

  void _listen() {
    SocketClient.socket.on(SocketEvents.RIDER_REFRESH, (v) {
      inspect(v);
      if (v == null) {
        currentOrder.value = null;
        return;
      }
      _onRiderRefresh(Map<String, dynamic>.from(v as Map));
    });
  }

  /// Ask the server for the rider's current order; it replies on the same event.
  void refreshCurrentOrder() {
    if (!SocketClient.isConnected) return;
    SocketClient.emit(SocketEvents.RIDER_REFRESH);
  }

  void _onRiderRefresh(Map<String, dynamic> data) {
    currentOrder.value = CurrentOrderModel.fromJson(data);
  }

  /// Cancel the active order and clear it locally.
  ///
  /// NOTE: the backend gateway does not yet subscribe to `order:cancel`; this
  /// wires the rider side and optimistically clears the local state.
  void cancel() async {
    // final order = currentOrder.value;
    // if (order == null) return;
    final response = await ApiServices.dio.post('/orders/cancel' , data: {});
    ApiDto dto = response.parsed;
    if (dto.statusCode == HttpStatus.ok) {
      currentOrder.value = null;
    }
  }

  @override
  void onClose() {
    if (SocketClient.isConnected) {
      SocketClient.socket.off(SocketEvents.RIDER_REFRESH);
    }
    super.onClose();
  }
}
