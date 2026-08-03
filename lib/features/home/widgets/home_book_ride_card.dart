import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:tajwal_rider/common/pages.dart';

/// Primary call-to-action hero: start a passenger booking.
class HomeBookRideCard extends StatelessWidget {
  const HomeBookRideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.passengersOrder),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.primary, Color(0xFF0A6E5B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withValues(alpha: 0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              top: -8,
              child: Icon(
                Icons.directions_car_filled,
                size: 86,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'city_to_city_caps'.tr,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.4, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  'where_to_today'.tr,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'book_ride_between_cities'.tr,
                  style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.85)),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('book_a_ride'.tr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColor.primary)),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 16, color: AppColor.primary),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
