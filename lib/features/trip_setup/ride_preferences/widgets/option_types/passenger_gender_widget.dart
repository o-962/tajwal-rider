import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/ride_box_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class PassengerGenderWidget extends StatelessWidget {
  PassengerGenderWidget({super.key});
  final RideService rideService = Get.find<RideService>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedType = rideService.ride.passengersGender;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            rideBoxWidget(
              onClick: () {
                rideService.ride.passengersGender = Gender.ANY;
                rideService.calcCosts();
              },
              text: 'any',
              image: 'both.webp',
              isSelected: selectedType == Gender.ANY,
            ),
            rideBoxWidget(
              onClick: () {
                rideService.ride.passengersGender = Gender.MALE;
                rideService.calcCosts();
              },
              text: 'male',
              image: 'man (1).webp',
              isSelected: selectedType == Gender.MALE,
            ),
            rideBoxWidget(
              onClick: () {
                rideService.ride.passengersGender = Gender.FEMALE;
                rideService.calcCosts();
              },
              text: 'female',
              image: 'woman (1).webp',
              isSelected: selectedType == Gender.FEMALE,
            ),
          ],
        ),
      );
    });
  }
}

