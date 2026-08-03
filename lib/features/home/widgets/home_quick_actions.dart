import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:tajwal_rider/common/pages.dart';
import 'package:tajwal_rider/features/home/widgets/home_quick_action_card.dart';

/// Secondary actions row: send a gift, schedule a ride.
class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HomeQuickActionCard(
            icon: Icons.card_giftcard,
            title: 'send_a_gift'.tr,
            subtitle: 'fast_or_normal'.tr,
            background: AppColor.warning,
            foreground: AppColor.black,
            onTap: () => Get.toNamed(AppRoutes.giftsOrder),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: HomeQuickActionCard(
            icon: Icons.schedule,
            title: 'schedule'.tr,
            subtitle: 'pick_a_time_slot'.tr,
            background: AppColor.secondary,
            foreground: AppColor.primary,
            onTap: () => Get.toNamed(AppRoutes.passengersOrder),
          ),
        ),
      ],
    );
  }
}
