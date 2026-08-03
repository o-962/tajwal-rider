import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared/base/cancelable_requests.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/core/routing/endpoints.dart';
import 'package:shared/models/api_dto.dart';
import 'package:tajwal_rider/features/history/dto/rider_history_dto.dart';

/// Owns the rider's order-history page: fetches their past orders on open and
/// holds the list, loading and error state. The backend returns them newest
/// first, so this controller never re-sorts.
class RiderHistoryController extends GetxController with CancelableRequests {
  final RxList<RiderHistoryOrderDto> orders = <RiderHistoryOrderDto>[].obs;
  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();

  bool get isEmpty => orders.isEmpty && !isLoading.value && error.value == null;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  /// Loads past orders. Called on open and by pull-to-refresh.
  Future<void> fetchHistory() async {
    cancelPendingRequests();

    // Captured per call: `finally` runs even on an early `return`, so a
    // superseded load compares its own token against the live one before
    // touching state the newer request now owns.
    final token = cancelToken;

    isLoading.value = true;
    error.value = null;
    try {
      final response = await ApiServices.dio.get(
        ApiEndpoints.riderHistory,
        cancelToken: token,
      );
      final ApiDto dto = response.parsed;
      final raw = dto.data?['orders'];
      if (dto.statusCode == HttpStatus.ok && raw is List) {
        orders.assignAll(
          raw
              .whereType<Map>()
              .map((e) => RiderHistoryOrderDto.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
      } else {
        error.value = dto.toastBody ?? dto.message ?? 'could_not_load_history'.tr;
      }
    } catch (e) {
      // Cancelled = disposed or superseded, NOT a network failure. Without this
      // check, leaving the page mid-load or pulling to refresh would paint
      // "Couldn't reach the server" over a request we ourselves aborted.
      if (isCancellation(e)) return;
      // Timeouts and dropped connections still throw; without this the page
      // would spin forever.
      error.value = 'could_not_reach_server'.tr;
    } finally {
      if (!isClosed && identical(token, cancelToken)) isLoading.value = false;
    }
  }
}
