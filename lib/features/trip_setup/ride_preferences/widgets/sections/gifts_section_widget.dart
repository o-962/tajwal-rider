import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/option_types/gift_type_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/section_header_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class GiftsSectionWidget extends StatelessWidget {
  GiftsSectionWidget({super.key});
  final RideService rideService = Get.find<RideService>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ride = rideService.ride;

      if (ride.deliveryType != DeliveryType.GIFTS) {
        return const SizedBox.shrink();
      }

      return SectionHeaderWidget(
        title: 'fast_gifts',
        subtitle: 'choose_your_gift_type',
        child: GiftTypeWidget(),
      );
    });
  }
}
