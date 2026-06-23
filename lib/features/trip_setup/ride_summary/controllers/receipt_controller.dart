// lib/features/trip_setup/ride_summary/controllers/receipt_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/base/base_controller.dart';
import 'package:shared/utils/logger.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/models/promo_code_model.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/services/receipt_service.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class ReceiptController extends BaseController {
  final ReceiptService _receiptService;
  final RideService _rideService;

  RideService get rideService => _rideService;

  final promoLoading = false.obs;
  final Rxn<PromoCodeModel> promoResult = Rxn<PromoCodeModel>();
  final promoCodeController = TextEditingController();

  @override
  void onClose() {
    promoCodeController.dispose();
    rideService.ride.promoCode = null;
    super.onClose();
  }

  ReceiptController({required ReceiptService receiptService, required RideService rideService})
    : _receiptService = receiptService,
      _rideService = rideService;

  Future<void> submit() async {
    await execute(() async {
      _rideService.ride.promoCode = promoCodeController.text.trim();
      await _receiptService.submit(_rideService.ride);
      AppLogger.debug('Order submitted successfully');
    }, errorMessage: 'failed_to_submit_order'.tr);
  }

  Future<void> applyPromoCode() async {
    final code = promoCodeController.text.trim();
    _rideService.ride.promoCode = code;

    if (code.isEmpty) return;
    promoLoading.value = true;
    try {
      PromoCodeModel promoModel = await _receiptService.applyPromoCode(_rideService.ride);
      if (promoModel.cost != 0) {
        promoResult.value = promoModel;
      }
    } catch (e) {
      promoResult.value = null;
    } finally {
      promoLoading.value = false;
    }
  }

}
