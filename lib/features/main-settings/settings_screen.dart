import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/core/routing/route.dart';
import 'package:shared/shared/constants/index.dart';
import 'package:shared/shared/storage/language_storage.dart';
import 'package:shared/shared/storage/storage_facade.dart';
import 'package:tajwal_rider/common/routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: AppColor.secondary,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Update Account'),
              onTap: () => Get.toNamed(AppRoutes.updateAccount),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () => Get.toNamed(CommonRoutes.changePassword),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Change Phone Number'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Change Language'),
              onTap: () => LanguageService().toggleLanguage(),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () => Get.toNamed(AppRoutes.history),
            ),
            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text('Contact Us'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out'),
              onTap: () => StorageFacade.clearAll(),
            ),
          ],
        ),
      ),
    );
  }
}
