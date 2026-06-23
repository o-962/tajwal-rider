import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/option_types/driver_gender_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/option_types/passenger_gender_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/option_types/user_gender_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/section_header_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class TaxiSectionWidget extends StatelessWidget {
  TaxiSectionWidget({super.key});
  final RideService rideService = Get.find<RideService>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ride = rideService.ride;
      if (ride.deliveryType != DeliveryType.TAXI) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderWidget(
            title: 'we_are',
            child: UserGenderWidget(),
          ),
          Obx(() {
            if (rideService.ride.male == 0) {
              return Column(
                children: [
                  SectionHeaderWidget(
                    title: 'driver_gender',
                    child: DriverGenderWidget(),
                  ),
                  SectionHeaderWidget(
                    title: 'passengers_gender',
                    child: PassengerGenderWidget(),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      );
    });
  }
}
