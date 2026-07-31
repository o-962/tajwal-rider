import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/order_summary/dto/order_summary_dto.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_card.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_row.dart';

/// Route + pickup window. The window is the pair the driver collects between,
/// so both ends are shown rather than just the departure time.
class SummaryTripCard extends StatelessWidget {
  const SummaryTripCard({super.key, required this.summary});

  final OrderSummaryDto summary;

  @override
  Widget build(BuildContext context) {
    return SummaryCard(
      title: 'Trip',
      children: [
        SummaryRow(label: 'Route', value: summary.routeLabel, emphasize: true),
        SummaryRow(label: 'Departure', value: summary.scheduledLabel),
        if (summary.hasPickupWindow)
          SummaryRow(label: 'Details available', value: summary.detailsAvailableLabel),
      ],
    );
  }
}
