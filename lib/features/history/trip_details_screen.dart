import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/utils/index.dart';
import 'package:tajwal_rider/features/history/models/history_model.dart';
import 'package:tajwal_rider/features/history/widgets/detail_card_widget.dart';
import 'package:tajwal_rider/features/history/widgets/detail_row_widget.dart';
import 'package:tajwal_rider/features/history/widgets/format_utils.dart';
import 'package:tajwal_rider/features/history/widgets/map_link_row_widget.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    if (args == null || args is! RiderHistoryOrderModel) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('trip_details'.tr),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'trip_load_error'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final order = args;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('trip_details'.tr),

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero header — clearly marks this as full details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.primary,
                    AppColor.primary.withOpacity(0.85),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'trip_full_details'.tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.pickupLocation,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Icon(Icons.arrow_downward, size: 18, color: Colors.white.withOpacity(0.8)),
                  ),
                  Text(
                    order.dropoffLocation,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.costDiscounted != null ? 'discounted'.tr : 'cost'.tr,
                          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9)),
                        ),
                        Text(
                          order.costDiscounted != null
                              ? formatMoney(order.costDiscounted!)
                              : formatMoney(order.cost),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailCardWidget(
                    icon: Icons.receipt_long,
                    title: 'cost'.tr,
                    children: [
                      DetailRowWidget('cost'.tr, formatMoney(order.cost)),
                      if (order.costDiscounted != null)
                        DetailRowWidget('discounted'.tr, formatMoney(order.costDiscounted!), highlighted: true),
                      if (order.group.isNotEmpty) DetailRowWidget('group'.tr, order.group),
                    ],
                  ),

                  const SizedBox(height: 12),

                  DetailCardWidget(
                    icon: Icons.person_outline,
                    title: 'driver'.tr,
                    children: [
                      DetailRowWidget('name'.tr, order.driverName),
                      if (order.driverPhoneNumber.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'phone_label'.tr,
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    order.driverPhoneNumber,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () => makePhoneCall(order.driverPhoneNumber),
                              icon: const Icon(Icons.phone, size: 18),
                              label: Text('call_driver'.tr),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColor.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (order.driverVehicle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: DetailRowWidget('vehicle'.tr, order.driverVehicle),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  DetailCardWidget(
                    icon: Icons.map_outlined,
                    title: 'locations'.tr,
                    children: [
                      MapLinkRowWidget(
                        label: 'pickup_location'.tr,
                        lat: order.pickUpLat,
                        lng: order.pickUpLng,
                        address: order.pickupLocation,
                      ),
                      const SizedBox(height: 8),
                      MapLinkRowWidget(
                        label: 'dropoff_location'.tr,
                        lat: order.dropOffLat,
                        lng: order.dropOffLng,
                        address: order.dropoffLocation,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
