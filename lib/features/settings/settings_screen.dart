import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/core/routing/route.dart';
import 'package:shared/widgets/language_picker_widget.dart';
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
                title: 'account_details'.tr,
                subtitle: 'view_profile_information'.tr,
                onTap: () => Get.toNamed(AppRoutes.account),
              ),
              SettingsMenuCard(
                icon: '🧾',
                iconBackground: OrderTokens.accentSoft,
                title: 'order_history'.tr,
                subtitle: 'your_past_rides_gifts'.tr,
                onTap: () => Get.toNamed(AppRoutes.orderHistory),
              ),
              SettingsMenuCard(
                icon: '🛟',
                iconBackground: OrderTokens.accentSoft,
                title: 'help_and_support'.tr,
                subtitle: 'faq_contact_us'.tr,
                onTap: () => _comingSoon(),
              ),
              SettingsMenuCard(
                icon: '🔑',
                iconBackground: OrderTokens.accentSoft,
                title: 'change_password_title'.tr,
                subtitle: 'update_login_password'.tr,
                onTap: () => Get.toNamed(CommonRoutes.changePassword),
              ),
              SettingsMenuCard(
                icon: '❌',
                iconBackground: OrderTokens.accentSoft,
                title: 'remove_account_title'.tr,
                subtitle: 'permanently_delete_account'.tr,
                onTap: () => Get.toNamed(CommonRoutes.removeAccount),
              ),
              SettingsMenuCard(
                icon: '📱',
                iconBackground: OrderTokens.accentSoft,
                title: 'change_phone_number_title'.tr,
                subtitle: 'update_contact_number'.tr,
                onTap: () => Get.toNamed(CommonRoutes.changePhoneNumber),
              ),
              // Same picker the welcome screen uses — `LanguagePickerWidget.open`
              // is the one entry point, so the sheet, the tick on the current
              // language and the persistence all stay identical in both places.
              //
              // Uses the build `context`, not `Get.context`: the sheet is a
              // route on this navigator, and a stale global context is how a
              // bottom sheet ends up attached to the wrong screen.
              SettingsMenuCard(
                icon: '🌐',
                iconBackground: OrderTokens.accentSoft,
                title: 'language'.tr,
                subtitle: 'change_app_language'.tr,
                onTap: () => LanguagePickerWidget.open(context),
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
    Get.snackbar('coming_soon'.tr, 'feature_not_available_yet'.tr);
  }
}
