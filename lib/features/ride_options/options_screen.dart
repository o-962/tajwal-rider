import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/common/colors.dart';
import 'package:shared/common/enums.dart';
import 'package:shared/common/font_size.dart';
import 'package:shared/common/media_query.dart';
import 'package:tajwal_rider/common/routes.dart';
import 'package:tajwal_rider/features/ride_options/controllers/ride_options_controller.dart';
import 'package:tajwal_rider/features/ride_options/widgets/option_types/delivery_type_widget.dart';
import 'package:tajwal_rider/features/ride_options/widgets/option_types/driver_gender_widget.dart';
import 'package:tajwal_rider/features/ride_options/widgets/option_types/gift_type_widget.dart';
import 'package:tajwal_rider/features/ride_options/widgets/option_types/passenger_gender_widget.dart';
import 'package:tajwal_rider/features/ride_options/widgets/option_types/user_gender_widget.dart';
import 'package:tajwal_rider/services/ride_services.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:shared/widgets/text_widget.dart';

class OptionsScreen extends StatelessWidget {
  OptionsScreen({super.key});
  final RideOptionsController controller = Get.put(RideOptionsController());

  Widget _sectionWidget(
    String title, {
    String? subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(
          marginVertical: 10,
          title,
          align: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
            fontSize: AppFontSize.semiBig,
          ),
        ),
        if (subtitle != null)
          textWidget(
            marginVertical: 5,
            subtitle,
            align: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
              fontSize: AppFontSize.small,
            ),
          ),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: AppSize.height - AppSize.buttonWidgetHeight,
                ),
                child: Column(
                  children: [
                    _sectionWidget(
                      'Delivery type',
                      child: DeliveryTypeWidget(),
                    ),

                    // Taxi Sections
                    Obx(() {
                      final ride = RideServices.ride;
                      if (ride.deliveryType != DeliveryType.taxi) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionWidget('We are', child: UserGenderWidget()),
                          Obx(() {
                            if (RideServices.ride.male == 0) {
                              return Column(
                                children: [
                                  _sectionWidget(
                                    'Driver gender',
                                    child: DriverGenderWidget(),
                                  ),
                                  _sectionWidget(
                                    'Passengers gender',
                                    child: PassengerGenderWidget(),
                                  ),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      );
                    }),

                    // Gifts Section
                    Obx(() {
                      final ride = RideServices.ride;

                      // Access the Rx value directly
                      if (ride.deliveryType != DeliveryType.gifts) {
                        return const SizedBox.shrink();
                      }

                      return _sectionWidget(
                        'Fast gifts',
                        subtitle: 'Choose your gift type',
                        child: GiftTypeWidget(),
                      );
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              Obx(
                () => buttonWidget(
                  text: 'Test | ${RideOptionsController.cost.value}',
                  onTap: ()=> Get.toNamed(AppRoutes.receipt),
                  disabled: !RideServices.canSubmitState.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
