import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/core/routing/route.dart';
import 'package:shared/shared/services/token_service.dart';
import 'package:tajwal_rider/features/orders/current_order/controller/current_order_controller.dart';

/// Logs the rider out and returns to the welcome screen.
class SettingsDangerButton extends StatelessWidget {
  const SettingsDangerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Get.find<AuthService>().logout(
          () {
            CurrentOrderController currentOrderController = Get.find<CurrentOrderController>();
            currentOrderController.clearCurrentOrder();
            Get.offAllNamed(CommonRoutes.welcome);
          },
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red.shade600,
          side: BorderSide(color: Colors.red.shade600),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          'log_out'.tr,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
