import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:tajwal_rider/features/home/widgets/home_active_order_card.dart';
import 'package:tajwal_rider/features/home/widgets/home_book_ride_card.dart';
import 'package:tajwal_rider/features/home/widgets/home_feature_strip.dart';
import 'package:tajwal_rider/features/home/widgets/home_greeting.dart';
import 'package:tajwal_rider/features/home/widgets/home_quick_actions.dart';
import 'package:tajwal_rider/features/orders/current_order/controller/current_order_controller.dart';

/// Composition only — every widget lives under features/home/widgets/.
///
/// Two states:
///  - no active order → hero CTA + quick actions + feature strip.
///  - active order    → a full, informative order card (route, driver, track).
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final CurrentOrderController controller = Get.find<CurrentOrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Obx(() {
          final order = controller.currentOrder.value;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeGreeting(),
                const SizedBox(height: 22),
                if (order != null)
                  HomeActiveOrderCard(order: order)
                else ...[
                  const HomeBookRideCard(),
                  const SizedBox(height: 16),
                  const HomeQuickActions(),
                  const SizedBox(height: 22),
                  const HomeFeatureStrip(),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
