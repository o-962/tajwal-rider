import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/driver_model.dart';
import 'package:shared/shared/constants/colors.dart';

class DriverStatsWidget extends StatelessWidget {
  final DriverModel driver;

  const DriverStatsWidget({
    super.key,
    required this.driver,
  });

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              icon: Icons.star,
              label: 'rating'.tr,
              value: driver.rating.toString(),
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              icon: Icons.event_seat,
              label: 'available'.tr,
              value: '${driver.carSeats}/${driver.maxSeats}',
              color: AppColor.primary,
            ),
          ),
        ],
      ),
    );
  }
}
