import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/features/trip_active/ride_map/controllers/ride_map_controller.dart';

class MapMenuButtonWidget extends StatelessWidget {
  const MapMenuButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      top: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        shadowColor: Colors.black.withValues(alpha: 0.3),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onSelected: (value) {
              Get.find<RideMapController>().cancelOrder();
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'cancel', child: Text('cancel_ride'.tr)),
            ],
          ),
        ),
      ),
    );
  }
}
