import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/core/routing/route.dart';
import 'package:shared/shared/services/translation_service.dart';
import 'package:shared/widgets/language_picker_widget.dart';
import 'package:shared/widgets/settings/settings_section_widget.dart';
import 'package:shared/widgets/settings/settings_tile_widget.dart';
import 'package:tajwal_rider/features/main_settings/controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final SettingsController _controller = Get.find<SettingsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),

      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SettingsSectionWidget(
              title: 'account'.tr,
              children: [
                SettingsTileWidget(
                  icon: Icons.lock,
                  title: 'change_password'.tr,
                  subtitle: 'update_password_subtitle'.tr,
                  onTap: _controller.toChangePassword,
                ),
                const Divider(height: 1),
                SettingsTileWidget(
                  icon: Icons.phone,
                  title: 'change_phone_number'.tr,
                  subtitle: 'update_phone_subtitle'.tr,
                  onTap: _controller.toChangePhone,
                ),
                const Divider(height: 1),
                SettingsTileWidget(
                  icon: Icons.person_off_outlined,
                  title: 'remove_account'.tr,
                  subtitle: 'remove_account_subtitle'.tr,
                  onTap: _controller.toRemoveAccount,
                  isDestructive: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SettingsSectionWidget(
              title: 'language'.tr,
              children: [
                Obx(() {
                  final ts = Get.find<TranslationService>();
                  final name =
                      ts.availableLanguages[ts.lang] ?? ts.lang.toUpperCase();
                  return SettingsTileWidget(
                    icon: Icons.language_outlined,
                    title: name,
                    subtitle: 'tap_to_change_language'.tr,
                    onTap: () => LanguagePickerWidget.open(context),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),
            SettingsSectionWidget(
              title: 'trips'.tr,
              children: [
                SettingsTileWidget(
                  icon: Icons.history,
                  title: 'trip_history'.tr,
                  subtitle: 'view_trip_history'.tr,
                  onTap: _controller.toHistory,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SettingsSectionWidget(
              title: 'legal'.tr,
              children: [
                SettingsTileWidget(
                  icon: Icons.privacy_tip_outlined,
                  title: 'privacy_policy'.tr,
                  subtitle: 'read_privacy_policy'.tr,
                  onTap: () => Get.toNamed(CommonRoutes.privacyPolicy),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SettingsSectionWidget(
              title: 'session'.tr,
              children: [
                SettingsTileWidget(
                  icon: Icons.logout,
                  title: 'logout'.tr,
                  subtitle: 'sign_out'.tr,
                  onTap: _controller.logout,
                  isDestructive: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
