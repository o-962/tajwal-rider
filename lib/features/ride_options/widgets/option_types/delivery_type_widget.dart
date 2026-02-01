import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/features/ride_options/widgets/ride_box_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class DeliveryTypeWidget extends StatelessWidget {

  DeliveryTypeWidget({super.key});
  RideService rideService = Get.find<RideService>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedType = rideService.ride.deliveryType;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            rideBoxWidget(
              onClick: () {
                rideService.ride.deliveryType = DeliveryType.taxi;
              },
              text: 'People',
              image: 'both.webp',
              isSelected: selectedType == DeliveryType.taxi,
              
            ),
            rideBoxWidget(
              onClick: () => rideService.ride.deliveryType = DeliveryType.gifts,
              text: 'Gift',
              image: 'gift.webp',
              isSelected: selectedType == DeliveryType.gifts,
            ),
          ],
        ),
      );
    });
  }
}
