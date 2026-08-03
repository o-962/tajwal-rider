import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/core/routing/endpoints.dart';
import 'package:shared/models/api_dto.dart';
import 'package:tajwal_rider/features/orders/order_summary/dto/order_summary_dto.dart';
import 'package:tajwal_rider/features/orders/shared/base/order_summary_target.dart';

/// Final-confirmation state for whichever order flow registered itself as the
/// [OrderSummaryTarget].
///
/// This controller never prices anything: it asks the backend for the quote and
/// renders what comes back, so the figure the rider confirms is the figure the
/// create charges. Applying a discount code just re-requests the quote — the
/// server stays the only thing that decides the total.
class OrderSummaryController extends GetxController {
  OrderSummaryTarget get _target => Get.find<OrderSummaryTarget>();

  final Rxn<OrderSummaryDto> summary = Rxn<OrderSummaryDto>();

  /// True while the quote is being (re)fetched.
  final RxBool loading = false.obs;

  /// True while the real order is being created.
  final RxBool submitting = false.obs;

  /// Set when the quote couldn't be produced (bad route, existing order, …).
  final RxnString error = RxnString();

  final TextEditingController discountInput = TextEditingController();

  /// True while `/discounts/validate` is in flight.
  final RxBool validating = false.obs;

  /// Verdict on the last code checked — copy to show under the input.
  final RxnString discountMessage = RxnString();

  /// Whether that verdict was a success, so the message can be styled for it.
  final RxBool discountApplied = false.obs;

  bool get hasSummary => summary.value != null;
  bool get canConfirm => hasSummary && !loading.value && !submitting.value;

  @override
  void onInit() {
    super.onInit();
    loadSummary();
  }

  @override
  void onClose() {
    discountInput.dispose();
    super.onClose();
  }

  String? get _discountCode {
    final value = discountInput.text.trim();
    return value.isEmpty ? null : value;
  }

  /// Apply the typed code.
  ///
  /// The code is checked against the dedicated `/discounts/validate` endpoint
  /// first. A bad code stops there — no point re-pricing an order that isn't
  /// going to change — and only a code that actually applies triggers a re-quote,
  /// so the totals still come from the summary endpoint and nothing is priced
  /// on the device.
  Future<void> applyDiscount() async {
    final code = _discountCode;

    // Cleared the field: drop the feedback and re-quote at full price.
    if (code == null) {
      discountMessage.value = null;
      discountApplied.value = false;
      await loadSummary();
      return;
    }

    final draft = summary.value;
    if (draft == null || validating.value) return;

    validating.value = true;
    try {
      final response = await ApiServices.dio.post(
        ApiEndpoints.validateDiscount,
        data: {
          'code': code,
          'order_type': draft.orderType,
          'cost': draft.baseCost,
          'pickup_area': draft.pickupArea,
          'dropoff_area': draft.dropoffArea,
        },
      );
      final ApiDto parsed = response.parsed;
      final data = parsed.data;

      final applied = data?['applied'] == true;
      discountApplied.value = applied;
      discountMessage.value = discountReasonMessage(
        (data?['reason'] ?? parsed.toastBody)?.toString(),
      );

      if (applied) await loadSummary();
    } catch (_) {
      discountApplied.value = false;
      discountMessage.value = 'could_not_check_code'.tr;
    } finally {
      validating.value = false;
    }
  }

  /// Remove an applied code: clear the field, drop the feedback, and re-quote at
  /// full price. Wired to the input's ✕ once a code is locked in.
  Future<void> clearDiscount() async {
    discountInput.clear();
    discountApplied.value = false;
    discountMessage.value = null;
    await loadSummary();
  }

  /// Ask the backend to price the draft. Also re-run whenever the rider applies
  /// a discount code, so the code genuinely round-trips through the server.
  Future<void> loadSummary() async {
    if (loading.value) return;
    loading.value = true;
    error.value = null;
    try {
      final response = await _target.requestSummary(discountCode: _discountCode);
      final data = response.data;
      final raw = data?['summary'];
      if (raw is Map) {
        summary.value = OrderSummaryDto.fromJson(Map<String, dynamic>.from(raw));
      } else {
        // The backend rejected the draft (invalid route, an order already
        // active, …). Its toast_body carries the reason.
        error.value = response.toastBody ?? response.message ?? 'could_not_price_order'.tr;
      }
    } catch (_) {
      // A timeout or dropped connection still throws (validateStatus only
      // covers status codes). Without this the page would spin forever and the
      // rider could never place the order at all.
      error.value = 'could_not_reach_server_retry'.tr;
    } finally {
      loading.value = false;
    }
  }

  /// Hand off to the flow's real create. The flow owns the navigation that
  /// follows, so nothing here assumes where the rider lands.
  Future<void> confirm() async {
    if (!canConfirm) return;
    submitting.value = true;
    try {
      await _target.submitOrder(discountCode: _discountCode);
    } finally {
      submitting.value = false;
    }
  }
}
