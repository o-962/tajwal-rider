import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// A titled block on the summary page. Every section shares this frame so the
/// page reads as one list rather than a pile of differently-styled boxes.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OrderTokens.surface,
        borderRadius: OrderTokens.rCard,
        border: Border.all(color: OrderTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: OrderTokens.label),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
