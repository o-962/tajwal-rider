import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/base/base_screen.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:shared/widgets/button_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/controllers/receipt_controller.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/widgets/location_card_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/widgets/price_summary_card_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/widgets/promo_code_widget.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/widgets/ride_info_card_widget.dart';

class ReceiptScreen extends BaseScreen<ReceiptController> {
  const ReceiptScreen({super.key}) : super(title: 'ride_summary', showLoading: true);

  @override
  Widget builder(ReceiptController controller) {
    final rideService = controller.rideService;
    return Container(
      color: Colors.grey[50],
      child: Obx(() {
        final ride = rideService.ride;
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (ride.deliveryType == DeliveryType.TAXI) ...[
                    RideInfoCardWidget(
                      title: 'passenger_details'.tr,
                      icon: Icons.people,
                      items: [
                        MapEntry('delivery_type'.tr, ride.deliveryType?.value.tr),
                        MapEntry('driver_gender'.tr, ride.driverGender?.value.tr),
                        MapEntry(
                          'passengers_gender'.tr,
                          ride.passengersGender?.value.tr,
                        ),
                        MapEntry('male_passengers'.tr, ride.male.toString()),
                        MapEntry('female_passengers'.tr, ride.female.toString()),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    // Gift Order - Show gift details only
                    RideInfoCardWidget(
                      title: 'gift_details'.tr,
                      icon: Icons.card_giftcard,
                      items: [MapEntry('gift_type'.tr, ride.giftType?.value.tr)],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Pickup Location Card
                  LocationCardWidget(
                    title: 'pickup_location'.tr,
                    icon: Icons.my_location,
                    iconColor: Colors.green,
                    location: ride.pickupLocation,
                    lat: ride.pickupLat,
                    lng: ride.pickupLng,
                  ),

                  const SizedBox(height: 16),

                  // Dropoff Location Card
                  LocationCardWidget(
                    title: 'dropoff_location'.tr,
                    icon: Icons.location_on,
                    iconColor: Colors.red,
                    location: ride.dropoffLocation,
                    lat: ride.dropoffLat,
                    lng: ride.dropoffLng,
                  ),
                  const SizedBox(height: 16),
                  const PromoCodeWidget(),
                  const SizedBox(height: 16),
                  Obx(() {
                    final promo = controller.promoResult.value;
                    return PriceSummaryCardWidget(
                      price: promo?.costDiscounted ?? ride.cost ?? 0.0,
                      originalPrice: promo != null ? promo.cost : ride.cost,
                    );
                  }),
                ],
              ),
            ),
            
            // Confirm Button at the bottom
            buttonWidget(
              text: 'confirm_ride'.tr,
              onTap: controller.submit,
            ),
          ],
        );
      }),
    );
  }
}
