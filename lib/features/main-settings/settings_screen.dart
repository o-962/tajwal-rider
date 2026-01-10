import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/services/shared_data.dart';
import 'package:tajwal_rider/common/routes.dart';
import 'package:shared/utils/app_utils.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(onPressed: () => changeLanguage(), child: const Text('Change Language')),
            TextButton(onPressed: () => Get.toNamed(AppRoutes.changePassword), child: const Text('Change password')),
            TextButton(onPressed: () => Get.toNamed(AppRoutes.updateAccount), child: const Text('Update account')),
            TextButton(onPressed: () {}, child: const Text('Change change phone number')),
            TextButton(onPressed: () {}, child: const Text('Contact us')),
            TextButton(onPressed: () => SharedData.clearAll(), child: const Text('Log out')),
            TextButton(onPressed: () {}, child: const Text('History')),
          ],
        ),
      ),
    );
  }
}
