import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/core/routing/route.dart';
import 'package:tajwal_rider/common/pages.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:tajwal_rider/features/settings/widgets/settings_danger_button.dart';
import 'package:tajwal_rider/features/settings/widgets/settings_menu_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrderTokens.page,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SettingsHeader(),
              // const SizedBox(height: 16),
              // const SettingsProfileCard(),
              const SizedBox(height: 20),
              SettingsMenuCard(
                icon: '👤',
                iconBackground: OrderTokens.accentSoft,
                title: 'Account details',
                subtitle: 'View your profile information',
                onTap: () => Get.toNamed(AppRoutes.account),
              ),
              SettingsMenuCard(
                icon: '🧾',
                iconBackground: OrderTokens.accentSoft,
                title: 'Order history',
                subtitle: 'Your past rides & gifts',
                onTap: () => Get.toNamed(AppRoutes.orderHistory),
              ),
              SettingsMenuCard(
                icon: '🛟',
                iconBackground: OrderTokens.accentSoft,
                title: 'Help & support',
                subtitle: 'FAQ, contact us',
                onTap: () => _comingSoon(),
              ),
              SettingsMenuCard(
                icon: '🔑',
                iconBackground: OrderTokens.accentSoft,
                title: 'Change password',
                subtitle: 'Update your login password',
                onTap: () => Get.toNamed(CommonRoutes.changePassword),
              ),
              SettingsMenuCard(
                icon: '❌',
                iconBackground: OrderTokens.accentSoft,
                title: 'Remove account',
                subtitle: 'Permanently delete your account',
                onTap: () => Get.toNamed(CommonRoutes.removeAccount),
              ),
              SettingsMenuCard(
                icon: '📱',
                iconBackground: OrderTokens.accentSoft,
                title: 'Change phone number',
                subtitle: 'Update your contact number',
                onTap: () => Get.toNamed(CommonRoutes.changePhoneNumber),
              ),
              const SizedBox(height: 8),
              const SettingsDangerButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _comingSoon() {
    Get.snackbar('Coming soon', 'This feature isn\'t available yet.');
  }
}
