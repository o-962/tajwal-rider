import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/common/enums.dart';
import 'package:tajwal_rider/features/ride_options/widgets/ride_box_widget.dart';
import 'package:tajwal_rider/services/ride_services.dart';

class PassengerGenderWidget extends StatelessWidget {
  const PassengerGenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedType = RideServices.ride.passengersGender;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 20,
          children: [
            rideBoxWidget(
              onClick: () => RideServices.ride.passengersGender = Gender.any,
              text: 'Any',
              image: 'both.webp',
              isSelected: selectedType == Gender.any,
            ),
            rideBoxWidget(
              onClick: () => RideServices.ride.passengersGender = Gender.male,
              text: 'Male',
              image: 'man (1).webp',
              isSelected: selectedType == Gender.male,
            ),
            rideBoxWidget(
              onClick: () => RideServices.ride.passengersGender = Gender.female,
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

