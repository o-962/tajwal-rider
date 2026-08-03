import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared/base/cancelable_requests.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/core/routing/endpoints.dart';
import 'package:shared/models/api_dto.dart';
import 'package:tajwal_rider/features/account/dto/account_dto.dart';

/// Owns the account-details page: fetches the rider's profile over HTTP on open.
///
/// The page is view only, so this controller does nothing but load and hold the
/// data — always fresh from the server, not the init-time app config.
class AccountController extends GetxController with CancelableRequests {
  final Rxn<AccountDto> account = Rxn<AccountDto>();
  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchAccount();
  }

  /// Loads the profile. Called on open and by pull-to-refresh.
  Future<void> fetchAccount() async {
    cancelPendingRequests();

    // Captured per call: `finally` runs even on an early `return`, so a
    // superseded load compares its own token against the live one before
    // touching state the newer request now owns.
    final token = cancelToken;

    isLoading.value = true;
    error.value = null;
    try {
      final response = await ApiServices.dio.get(
        ApiEndpoints.account,
        cancelToken: token,
      );
      final ApiDto dto = response.parsed;
      if (dto.statusCode == HttpStatus.ok && dto.data != null) {
        account.value = AccountDto.fromJson(dto.data!);
      } else {
        error.value = dto.toastBody ?? dto.message ?? 'could_not_load_account'.tr;
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
