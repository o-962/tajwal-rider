// lib/features/history/binding/history_binding.dart
import 'package:get/get.dart';
import 'package:tajwal_rider/features/history/controllers/history_controller.dart';
import 'package:tajwal_rider/features/history/services/history_service.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(
      () => HistoryController(HistoryService()),
    );
  }
}
