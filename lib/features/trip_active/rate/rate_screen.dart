import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/features/trip_active/rate/controller/rate_controller.dart';

class RateScreen extends StatelessWidget {
  RateScreen({super.key});

  final RateController _controller = Get.find<RateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('single_button_page'.tr)),
      body: Center(
        child: ElevatedButton(
          onPressed: _controller.done,
          child: Text('click_me'.tr),
        ),
      ),
    );
  }
}