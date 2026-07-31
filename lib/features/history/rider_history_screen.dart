import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/features/history/controller/rider_history_controller.dart';
import 'package:tajwal_rider/features/history/widgets/rider_history_card.dart';
import 'package:tajwal_rider/features/history/widgets/rider_history_empty.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// The rider's past orders, newest first. Composition only — every widget lives
/// under features/history/widgets/.
class RiderHistoryScreen extends GetView<RiderHistoryController> {
  const RiderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrderTokens.page,
      appBar: AppBar(
        title: const Text('Order history'),
        backgroundColor: OrderTokens.page,
        surfaceTintColor: OrderTokens.page,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final error = controller.error.value;
          if (error != null && controller.orders.isEmpty) {
            return RiderHistoryEmpty(message: error, onRetry: controller.fetchHistory);
          }

          if (controller.isEmpty) {
            return const RiderHistoryEmpty(
              message: "You haven't placed any orders yet.\nYour past rides and gifts appear here.",
            );
          }

          // Read the RxList inside the builder (toList()) so Obx tracks it.
          final orders = controller.orders.toList();
          return RefreshIndicator(
            onRefresh: controller.fetchHistory,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: orders.length,
              itemBuilder: (context, index) => RiderHistoryCard(order: orders[index]),
            ),
          );
        }),
      ),
    );
  }
}
