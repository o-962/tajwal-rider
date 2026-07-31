import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/order_summary/dto/order_summary_dto.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_card.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_row.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/dashed_divider.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// The final calculation, straight from the backend. The discount line only
/// appears once a code actually reduces the price — until discount codes are
/// implemented the server returns 0 and this stays a single total.
class SummaryPriceCard extends StatelessWidget {
  const SummaryPriceCard({super.key, required this.summary});

  final OrderSummaryDto summary;

  @override
  Widget build(BuildContext context) {
    return SummaryCard(
      title: 'Payment',
      children: [
        SummaryRow(label: 'Subtotal', value: summary.price(summary.baseCost)),
        if (summary.hasDiscount)
          SummaryRow(
            label: 'Discount',
            value: '- ${summary.price(summary.discountAmount)}',
          ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: DashedDivider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: OrderTokens.ink,
              ),
            ),
            Text(
              summary.price(summary.totalCost),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: OrderTokens.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
