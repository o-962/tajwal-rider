import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:tajwal_rider/features/shell/controller/shell_controller.dart';

class ShellScreen extends StatelessWidget {
  ShellScreen({super.key});

  final ShellController controller = Get.put(ShellController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
            border: Border(top: BorderSide(color: Color(0xFFEDEFEC))),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              // The active tab sits on a filled secondary-colour pill.
              indicatorColor: AppColor.secondary,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              iconTheme: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return IconThemeData(size: 26, color: selected ? AppColor.primary : Colors.black54);
              }),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppColor.primary : Colors.black54,
                );
              }),
            ),
            child: NavigationBar(
              height: 68,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedIndex: controller.index.value,
              onDestinationSelected: controller.changeIndex,
              destinations: controller.items
                  .map((item) => NavigationDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.selectedIcon),
                        label: item.label,
                      ))
                  .toList(),
            ),
          ),
        ),
        body: IndexedStack(
          index: controller.index.value,
          children: controller.items.map((item) => item.screenBuilder()).toList(),
        ),
      ),
    );
  }
}
