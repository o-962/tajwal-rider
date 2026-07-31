import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/order_summary/controller/order_summary_controller.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_details_card.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_discount_field.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_error_banner.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_error_view.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_price_card.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_trip_card.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_wallet_card.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/confirm_order_button.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// The last stop before an order exists: the backend's own calculation of what
/// the rider is about to book. Composition only — every widget lives under
/// features/orders/order_summary/widgets/.
class OrderSummaryScreen extends GetView<OrderSummaryController> {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrderTokens.page,
      appBar: AppBar(
        title: const Text('Order summary'),
        backgroundColor: OrderTokens.page,
        surfaceTintColor: OrderTokens.page,
        elevation: 0,
      ),
      body: Obx(() {
        final summary = controller.summary.value;
        final error = controller.error.value;

        if (summary == null) {
          if (error != null) {
            return SummaryErrorView(message: error, onRetry: controller.loadSummary);
          }
          return const Center(child: CircularProgressIndicator());
        }
  
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  children: [
                    if (error != null) SummaryErrorBanner(message: error),
                    SummaryTripCard(summary: summary),
                    SummaryDetailsCard(summary: summary),
                    SummaryWalletCard(summary: summary),
                    SummaryDiscountField(
                      input: controller.discountInput,
                      applying: controller.validating.value || controller.loading.value,
                      onApply: controller.applyDiscount,
                      onClear: controller.clearDiscount,
                      message: controller.discountMessage.value,
                      applied: controller.discountApplied.value,
                    ),
                    SummaryPriceCard(summary: summary),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: ConfirmOrderButton(
                  enabled: controller.canConfirm,
                  label: controller.submitting.value
                      ? 'Placing order…'
                      : 'Confirm & place order',
                  caption: 'You are charged ${summary.price(summary.totalCost)}',
                  onTap: controller.confirm,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
