import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/common/routes.dart';

class RateScreen extends StatelessWidget {
  const RateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Single Button Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.offAllNamed(AppRoutes.pickup);
          },
          child: const Text('Click Me'),
        ),
      ),
    );
  }
}