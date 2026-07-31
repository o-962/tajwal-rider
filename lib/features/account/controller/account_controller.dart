import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/core/routing/endpoints.dart';
import 'package:shared/models/api_dto.dart';
import 'package:tajwal_rider/features/account/dto/account_dto.dart';

/// Owns the account-details page: fetches the rider's profile over HTTP on open.
///
/// The page is view only, so this controller does nothing but load and hold the
/// data — always fresh from the server, not the init-time app config.
class AccountController extends GetxController {
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
    isLoading.value = true;
    error.value = null;
    try {
      final response = await ApiServices.dio.get(ApiEndpoints.account);
      final ApiDto dto = response.parsed;
      if (dto.statusCode == HttpStatus.ok && dto.data != null) {
        account.value = AccountDto.fromJson(dto.data!);
      } else {
        error.value = dto.toastBody ?? dto.message ?? "Couldn't load your account.";
      }
    } catch (_) {
      // Timeouts and dropped connections still throw; without this the page
      // would spin forever.
      error.value = "Couldn't reach the server. Check your connection.";
    } finally {
      isLoading.value = false;
    }
  }
}
