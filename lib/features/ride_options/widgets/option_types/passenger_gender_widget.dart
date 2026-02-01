import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/features/ride_options/widgets/ride_box_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class PassengerGenderWidget extends StatelessWidget {
  PassengerGenderWidget({super.key});
  RideService rideService = Get.find<RideService>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedType = rideService.ride.passengersGender;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            rideBoxWidget(
              onClick: () => rideService.ride.passengersGender = Gender.any,
              text: 'Any',
              image: 'both.webp',
              isSelected: selectedType == Gender.any,
            ),
            rideBoxWidget(
              onClick: () => rideService.ride.passengersGender = Gender.male,
              text: 'Male',
              image: 'man (1).webp',
              isSelected: selectedType == Gender.male,
            ),
            rideBoxWidget(
              onClick: () => rideService.ride.passengersGender = Gender.female,
              text: 'Female',
              image: 'woman (1).webp',
              isSelected: selectedType == Gender.female,
            ),
          ],
        ),
      );
    });
  }
}

