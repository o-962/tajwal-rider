import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/features/config/config_controller.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// Avatar, name and phone number, read from the rider's app config.
class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Get.find<AppConfigController>().config;
    final firstName = config.firstName ?? '';
    final lastInitial = (config.lastName?.isNotEmpty ?? false) ? '${config.lastName![0]}.' : '';

    // Full width so the centered avatar / name / phone sit in the middle of the
    // screen, not left-aligned inside the parent column.
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: OrderTokens.accentSoft, shape: BoxShape.circle),
            child: const Center(child: Text('👩', style: TextStyle(fontSize: 40))),
          ),
          const SizedBox(height: 12),
          Text(
            '$firstName $lastInitial'.trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: OrderTokens.ink),
          ),
          const SizedBox(height: 4),
          Text(
            config.phoneNumber ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: OrderTokens.muted),
          ),
        ],
      ),
    );
  }
}
