import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// A small coloured pill for an order's status — green when completed, red when
/// cancelled, accent for anything mid-flight.
class RiderHistoryStatusChip extends StatelessWidget {
  const RiderHistoryStatusChip({
    super.key,
    required this.status,
    required this.label,
  });

  final String status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = _color(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }

  static Color _color(String status) {
    switch (status) {
      case 'completed':
        return OrderTokens.primary;
      case 'cancelled':
        return const Color(0xFFC0392B);
      default:
        return OrderTokens.accent;
    }
  }
}
