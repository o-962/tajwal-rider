import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/core/network/socket_client.dart';
import 'package:shared/core/routing/endpoints.dart';
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

  /// Kept so [onClose] removes only THIS handler. The bare
  /// `socket.off(RIDER_REFRESH)` this used to call removed EVERY listener on
  /// the event, so disposing any one screen that touched the current order
  /// silenced the permanent controller too.
  late final void Function(dynamic) _onRefresh;

  /// Re-requests the order on every (re)connection; deregistered in [onClose].
  late final void Function() _resync;

  @override
  void onInit() {
    super.onInit();

    _onRefresh = (v) {
      inspect(v);
      if (v == null) {
        currentOrder.value = null;
        return;
      }
      _onRiderRefresh(Map<String, dynamic>.from(v as Map));
    };

    // Attach straight away. The socket instance now outlives connect(), so a
    // listener registered before the link is up is still the live one after —
    // no need to await anything. This controller is registered `permanent` by
    // SplashBinding, i.e. constructed BEFORE SplashScreenController connects,
    // and a permanent controller's onInit never runs again.
    SocketClient.socket.on(SocketEvents.RIDER_REFRESH, _onRefresh);

    // Re-ask on every connection. Previously the request went out once, right
    // after the first connect; if the rider lost signal on the trip screen,
    // their driver's position and trip status froze at that moment and stayed
    // frozen — including a trip that had since been completed or cancelled.
    _resync = () => SocketClient.emit(SocketEvents.RIDER_REFRESH);
    SocketClient.onReady(_resync);
  }

  /// Ask the server for the rider's current order; it replies on the same event.
  void refreshCurrentOrder() => SocketClient.emit(SocketEvents.RIDER_REFRESH);

  void _onRiderRefresh(Map<String, dynamic> data) {
    currentOrder.value = CurrentOrderModel.fromJson(data);
  }

  /// Cancel the active order and clear it locally.
  ///
  /// NOTE: the backend gateway does not yet subscribe to `order:cancel`; this
  /// wires the rider side and optimistically clears the local state.
  void cancel() async {
    // No cancelToken: this is a mutation. Cancelling would abort our wait, not
    // the server's work — the order would be cancelled while the app believed it
    // wasn't. Guard the state write instead.
    final response = await ApiServices.dio.post(ApiEndpoints.cancelOrder, data: {});
    if (isClosed) return;

    ApiDto dto = response.parsed;
    if (dto.statusCode == HttpStatus.ok) {
      currentOrder.value = null;
    }
    // A non-OK response already surfaces to the rider: the service sets a
    // toast_body and the response interceptor shows it. The order deliberately
    // stays on screen so they can retry rather than being told it's gone.
  }

  @override
  void onClose() {
    SocketClient.offReady(_resync);
    SocketClient.socket.off(SocketEvents.RIDER_REFRESH, _onRefresh);
    super.onClose();
  }

  void clearCurrentOrder() {
    currentOrder.value = null;
  }
}
