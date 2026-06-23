import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/layout.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:tajwal_rider/common/navigation/navigation_service.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/option_types/delivery_type_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/section_header_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/sections/gifts_section_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/widgets/sections/taxi_section_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class OptionsScreen extends StatelessWidget {
  OptionsScreen({super.key});
  final RideService controller = Get.find<RideService>();
  final NavigationService _nav = Get.find<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('options'.tr)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              constraints: BoxConstraints(minHeight: AppSize.height - AppSize.buttonWidgetHeight),
              child: Column(
                children: [
                  SectionHeaderWidget(title: 'delivery_type'.tr, child: DeliveryTypeWidget()),
                  TaxiSectionWidget(),
                  GiftsSectionWidget(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Obx(
              () => buttonWidget(
                text: '${'cost'.tr} | ${controller.ride.cost} ${'jod'.tr}',
                onTap: () => _nav.toReceipt(),
                disabled: !controller.canSubmit.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
