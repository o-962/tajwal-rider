import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/common/enums.dart';
import 'package:tajwal_rider/features/ride_options/widgets/ride_box_widget.dart';
import 'package:tajwal_rider/services/ride_services.dart';

class DeliveryTypeWidget extends StatelessWidget {

  const DeliveryTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedType = RideServices.ride.deliveryType;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 20,
          children: [
            rideBoxWidget(
              onClick: () {
                RideServices.ride.deliveryType = DeliveryType.taxi;
              },
              text: 'People',
              image: 'both.webp',
              isSelected: selectedType == DeliveryType.taxi,
              
            ),
            rideBoxWidget(
              onClick: () => RideServices.ride.deliveryType = DeliveryType.gifts,
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
