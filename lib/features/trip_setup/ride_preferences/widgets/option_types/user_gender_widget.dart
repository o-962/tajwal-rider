import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/widgets/text_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/ride_box_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class UserGenderWidget extends StatelessWidget {
  UserGenderWidget({super.key});

  final RideService rideService = Get.find<RideService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            rideBoxWidget(
              onClick: () {},
              text: 'females',
              image: 'woman (2).webp',
              underElement: () => Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => rideService.incrementFemale(),
                  ),
                  textWidget(
                    "${rideService.ride.female}",
                    translate: false,
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    
                    onPressed: () => rideService.decrementFemale(),
                  ),
                ],
              ),
            ),
            rideBoxWidget(
              onClick: () {},
              text: 'males',
              image: 'both.webp',
              underElement: () => Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => rideService.incrementMale(),
                  ),
                  textWidget(
                    "${rideService.ride.male}",
                    translate: false,
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => rideService.decrementMale(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
