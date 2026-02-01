import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/layout.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:tajwal_rider/common/routes.dart';
import 'package:tajwal_rider/features/ride_options/widgets/option_types/delivery_type_widget.dart';
import 'package:tajwal_rider/features/ride_options/widgets/section_header_widget.dart';
import 'package:tajwal_rider/features/ride_options/widgets/sections/gifts_section_widget.dart';
import 'package:tajwal_rider/features/ride_options/widgets/sections/taxi_section_widget.dart';
import 'package:tajwal_rider/services/ride/ride_services.dart';

class OptionsScreen extends StatelessWidget {
  OptionsScreen({super.key});
  final RideService controller = Get.find<RideService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                constraints: BoxConstraints(
                  minHeight: AppSize.height - AppSize.buttonWidgetHeight,
                ),
                child: Column(
                  children: [
                    SectionHeaderWidget(
                      title: 'Delivery type',
                      child: DeliveryTypeWidget(),
                    ),
                    TaxiSectionWidget(),
                    GiftsSectionWidget(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Obx(
                () => buttonWidget(
                  text: '${'cost'.tr} | ${controller.ride.cost}',
                  onTap: () => Get.toNamed(AppRoutes.receipt),
                  disabled: !controller.canSubmit.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
