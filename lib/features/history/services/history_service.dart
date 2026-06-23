// lib/features/history/services/history_service.dart
import 'package:shared/core/network/api_client.dart';
import 'package:shared/core/routing/endpoints.dart';
import 'package:shared/models/api_dto.dart';
import 'package:tajwal_rider/features/history/models/history_model.dart';

class HistoryService {
  Future<RiderHistoryDto> fetchHistory() async {
    final request = await ApiServices.dio.get(ApiEndpoints.riderHistory);
    final ApiDto response = request.parsed;
    return RiderHistoryDto.fromJson(response.data ?? {});
  }
}
