import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:shared/shared/services/config_service.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/ride_box_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class DriverGenderWidget extends StatelessWidget {
  DriverGenderWidget({super.key});
  final RideService rideService = Get.find<RideService>();
  final ConfigService configService = Get.find<ConfigService>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedType = rideService.ride.driverGender;
      final cfg = configService.config;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,

        child: Row(
          children: [
            rideBoxWidget(
              onClick: () {
                rideService.ride.driverGender = Gender.ANY;
                rideService.calcCosts();
              },
              text: 'any',
              image: 'both.webp',
              isSelected: selectedType == Gender.ANY,
            ),
            rideBoxWidget(
              onClick: () {
                rideService.ride.driverGender = Gender.MALE;
                rideService.calcCosts();
              },
              text: 'male',
              image: 'man (1).webp',
              isSelected: selectedType == Gender.MALE,
              disabled: !cfg.enableMaleDrivers,
            ),
            rideBoxWidget(
              onClick: () {
                rideService.ride.driverGender = Gender.FEMALE;
                rideService.calcCosts();
              },
              text: 'female',
              image: 'woman (1).webp',
              isSelected: selectedType == Gender.FEMALE,
              disabled: !cfg.enableFemaleDrivers,
            ),
          ],
        ),
      );
    });
  }
}
