import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/common/enums.dart';
import 'package:tajwal_rider/features/ride_options/widgets/ride_box_widget.dart';
import 'package:tajwal_rider/services/ride_services.dart';

class GiftTypeWidget extends StatelessWidget {
  const GiftTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedType = RideServices.ride.giftType;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            rideBoxWidget(
              onClick: () => RideServices.ride.giftType = GiftType.fast,
              text: 'Fast delivery\nSame day',
              image: 'woman (26).webp',
              isSelected: selectedType == GiftType.fast,
            ),
            SizedBox(width: 20),
            rideBoxWidget(
              onClick: () => RideServices.ride.giftType = GiftType.normal,
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
