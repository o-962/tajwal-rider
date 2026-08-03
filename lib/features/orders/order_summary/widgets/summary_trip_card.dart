import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/order_summary/dto/order_summary_dto.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_card.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_row.dart';
import 'package:get/get.dart';

/// Route + pickup window. The window is the pair the driver collects between,
/// so both ends are shown rather than just the departure time.
class SummaryTripCard extends StatelessWidget {
  const SummaryTripCard({super.key, required this.summary});

  final OrderSummaryDto summary;

  @override
  Widget build(BuildContext context) {
    return SummaryCard(
      title: 'trip'.tr,
      children: [
        SummaryRow(label: 'route'.tr, value: summary.routeLabel, emphasize: true),
        SummaryRow(label: 'departure'.tr, value: summary.scheduledLabel),
        if (summary.hasPickupWindow)
          SummaryRow(label: 'details_available'.tr, value: summary.detailsAvailableLabel),
      ],
    );
  }
}
