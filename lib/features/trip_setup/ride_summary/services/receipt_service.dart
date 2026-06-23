// lib/features/trip_setup/ride_summary/services/receipt_service.dart
import 'package:get/get.dart';
import 'package:shared/core/config/app_config.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/models/api_dto.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/models/promo_code_model.dart';
import 'package:tajwal_rider/models/ride_model.dart';

class ReceiptService {
  Future<void> submit(RidePreferences data) async {
    if (!AppConfig.isInitialized) throw Exception('dio_not_initialized'.tr);
    
    await ApiServices.dio.post('/orders', data: data.toJson());
  }

  Future<PromoCodeModel> applyPromoCode(RidePreferences data) async {
    if (!AppConfig.isInitialized) throw Exception('dio_not_initialized'.tr);

    final request = await ApiServices.dio.post('/orders/promo-code', data: data.toJson());
    final ApiDto response = request.parsed;

    return PromoCodeModel.fromJson(response.data ?? {});
  }
}