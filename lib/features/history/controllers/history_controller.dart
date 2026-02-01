// history_controller.dart
import 'package:get/get.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/core/routing/endpoints.dart';
import 'package:shared/models/api_response_model.dart';
import 'package:tajwal_rider/features/history/models/history_model.dart';

class HistoryController extends GetxController {
  final Rx<RiderHistoryModel?> history = Rx<RiderHistoryModel?>(null);
  @override
  void onInit() {
    super.onInit();
    getHistory();
  }
  Future<void> getHistory() async {
    final request = await ApiServices.dio.get(ApiEndpoints.riderHistory);
    final ApiModel response = request.parsed;
    history.value = RiderHistoryModel.fromJson(response.data ?? {});
  }
}
