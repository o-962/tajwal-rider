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
            title: 'Send a gift',
            subtitle: 'Fast or normal',
            background: AppColor.warning,
            foreground: AppColor.black,
            onTap: () => Get.toNamed(AppRoutes.giftsOrder),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: HomeQuickActionCard(
            icon: Icons.schedule,
            title: 'Schedule',
            subtitle: 'Pick a time slot',
            background: AppColor.secondary,
            foreground: AppColor.primary,
            onTap: () => Get.toNamed(AppRoutes.passengersOrder),
          ),
        ),
      ],
    );
  }
}
