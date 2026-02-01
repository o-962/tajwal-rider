import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/features/ride_options/widgets/ride_box_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class GiftTypeWidget extends StatelessWidget {
  GiftTypeWidget({super.key});
  RideService rideService = Get.find<RideService>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedType = rideService.ride.giftType;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            rideBoxWidget(
              onClick: () => rideService.ride.giftType = GiftType.fast,
              text: 'Fast delivery\nSame day',
              image: 'woman (26).webp',
              isSelected: selectedType == GiftType.fast,
            ),
            rideBoxWidget(
              onClick: () => rideService.ride.giftType = GiftType.normal,
              text: 'Normal delivery\nSame day',
              image: 'woman (26).webp',
              isSelected: selectedType == GiftType.normal,
            ),
          ],
        ),
      );
    });
  }
}
