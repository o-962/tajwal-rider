import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/features/ride_options/widgets/option_types/gift_type_widget.dart';
import 'package:tajwal_rider/features/ride_options/widgets/section_header_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class GiftsSectionWidget extends StatelessWidget {
  GiftsSectionWidget({super.key});
  RideService rideService = Get.find<RideService>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ride = rideService.ride;

      if (ride.deliveryType != DeliveryType.gifts) {
        return const SizedBox.shrink();
      }

      return SectionHeaderWidget(
        title: 'Fast gifts',
        subtitle: 'Choose your gift type',
        child: GiftTypeWidget(),
      );
    });
  }
}
