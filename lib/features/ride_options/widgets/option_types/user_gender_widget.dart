import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/features/ride_options/controllers/ride_options_controller.dart';
import 'package:tajwal_rider/features/ride_options/widgets/ride_box_widget.dart';
import 'package:tajwal_rider/services/ride_services.dart';
import 'package:shared/widgets/text_widget.dart';

class UserGenderWidget extends StatelessWidget {
  const UserGenderWidget({super.key});

  

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
              text: 'Womans',
              image: 'woman (2).webp',
              underElement: () => Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => RideOptionsController().addGender('female'),
                  ),
                  textWidget(
                    "${RideServices.ride.female}",
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => RideOptionsController().removeGender('female'),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            rideBoxWidget(
              onClick: () {},
              text: 'Males',
              image: 'both.webp',
              underElement: () => Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => RideOptionsController().addGender('male'),
                  ),
                  textWidget(
                    "${RideServices.ride.male}",
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => RideOptionsController().removeGender('male'),
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
