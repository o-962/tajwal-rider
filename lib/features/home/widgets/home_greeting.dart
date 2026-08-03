import 'package:flutter/material.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:get/get.dart';

/// Time-of-day greeting + the rider's first name + avatar.
class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'good_morning'.tr
        : hour < 18
            ? 'good_afternoon'.tr
            : 'good_evening'.tr;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$greeting 👋', style: const TextStyle(fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 2),
              Text(
                'welcome'.tr,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColor.black),
              ),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(color: AppColor.secondary, shape: BoxShape.circle),
          child: const Icon(Icons.person, color: AppColor.primary),
        ),
      ],
    );
  }
}
