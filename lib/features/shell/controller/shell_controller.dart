import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/features/home/home_screen.dart';
import 'package:tajwal_rider/features/settings/settings_screen.dart';

class ShellController extends GetxController {
  RxInt index = 0.obs;

  // screenBuilder, not a built Widget — so HomeScreen()/SettingsScreen() aren't
  // constructed here in the field initializer (which runs the moment
  // ShellController is instantiated), but later in ShellScreen.build(), by
  // which point the route's binding has already registered the controllers
  // these screens Get.find().
  final List<({
    Widget Function() screenBuilder,
    IconData icon,
    IconData selectedIcon,
    String label,
  })> items = [
    (icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home', screenBuilder: () => HomeScreen()),
    (icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: 'Settings', screenBuilder: () => SettingsScreen()),
  ];


  void changeIndex(int newIndex) {
    index.value = newIndex;
  }

  // The `rider:refresh` socket channel is owned by CurrentOrderController, which
  // the home tab puts on startup — no wiring needed here.
}