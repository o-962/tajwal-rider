// lib/features/history/controllers/history_controller.dart
import 'package:get/get.dart';
import 'package:shared/base/base_controller.dart';
import 'package:tajwal_rider/features/history/models/history_model.dart';
import 'package:tajwal_rider/features/history/services/history_service.dart';

class HistoryController extends BaseController {
  final HistoryService _service;

  HistoryController(this._service);

  final Rx<RiderHistoryDto?> history = Rx<RiderHistoryDto?>(null);

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    await execute(
      () async {
        final history = await _service.fetchHistory();
        this.history.value = history;
      },
      errorMessage: 'failed_to_load_history'.tr,
    );
  }
}
