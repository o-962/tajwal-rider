import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/section_label.dart';

/// "SEATS" heading with the selected / max seat count.
class SeatsHeader extends StatelessWidget {
  const SeatsHeader({
    super.key,
    required this.selected,
    required this.max,
  });

  final int selected;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SectionLabel('Seats'),
        Text(
          '$selected / $max',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: OrderTokens.muted,
          ),
        ),
      ],
    );
  }
}
