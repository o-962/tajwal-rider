import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:shared/shared/services/config_service.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/ride_box_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class DeliveryTypeWidget extends StatelessWidget {

  DeliveryTypeWidget({super.key});
  final RideService rideService = Get.find<RideService>();
  final ConfigService configService = Get.find<ConfigService>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedType = rideService.ride.deliveryType;
      final cfg = configService.config;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            rideBoxWidget(
              onClick: () {
                rideService.ride.deliveryType = DeliveryType.TAXI;
                rideService.calcCosts();
              },
              text: 'people',
              image: 'both.webp',
              isSelected: selectedType == DeliveryType.TAXI,
              disabled: !cfg.enableOrders,
            ),
            rideBoxWidget(
              onClick: () {
                rideService.ride.deliveryType = DeliveryType.GIFTS;
                rideService.calcCosts();
              },
              text: 'gift',
              image: 'gift.webp',
              isSelected: selectedType == DeliveryType.GIFTS,
              disabled: !cfg.enableGifts,
            ),
          ],
        ),
      );
    });
  }
}
