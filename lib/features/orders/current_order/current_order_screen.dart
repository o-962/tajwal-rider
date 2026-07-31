import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:tajwal_rider/features/orders/current_order/controller/current_order_controller.dart';
import 'package:tajwal_rider/features/orders/current_order/widgets/current_order_empty.dart';
import 'package:tajwal_rider/features/orders/current_order/widgets/current_order_map.dart';
import 'package:tajwal_rider/features/orders/current_order/widgets/current_order_sheet.dart';

/// A full-screen draggable map with the driver's live location, and a draggable
/// details sheet over it (status, driver, pickup window, route, cost, cancel).
class CurrentOrderScreen extends StatelessWidget {
  CurrentOrderScreen({super.key});

  final CurrentOrderController controller = Get.find<CurrentOrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Obx(() {
        final order = controller.currentOrder.value;
        if (order == null) return const SafeArea(child: CurrentOrderEmpty());

        return Stack(
          children: [
            // Full-screen, freely draggable map (driver marker updates live).
            Positioned.fill(child: CurrentOrderMap(order: order)),

            // Back button over the map.
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _CircleButton(icon: Icons.arrow_back, onTap: Get.back),
              ),
            ),

            // Draggable details sheet. Its drag extent is held in its own State,
            // so live order updates refresh the content without snapping it back.
            DraggableScrollableSheet(
              initialChildSize: 0.42,
              minChildSize: 0.16,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return CurrentOrderSheet(
                  order: order,
                  scrollController: scrollController,
                  onCancel: controller.cancel,
                );
              },
            ),
          ],
        );
      }),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: AppColor.black, size: 22),
        ),
      ),
    );
  }
}
