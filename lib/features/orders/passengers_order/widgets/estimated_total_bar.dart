import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/dashed_divider.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:get/get.dart';

/// The dashed-topped summary row: "Estimated total · N seats" and the price.
class EstimatedTotalBar extends StatelessWidget {
  const EstimatedTotalBar({
    super.key,
    required this.seats,
    required this.total,
  });

  final int seats;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashedDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'estimated_total'.tr} · $seats ${'seats_lower'.tr}',
                style: const TextStyle(fontSize: 14, color: OrderTokens.muted),
              ),
              Text(
                '$total JOD',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: OrderTokens.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
