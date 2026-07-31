import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// The white rounded card that groups the passenger-count rows,
/// inserting a hairline divider between them.
class PassengerCountCard extends StatelessWidget {
  const PassengerCountCard({super.key, required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    for (var i = 0; i < rows.length; i++) {
      children.add(rows[i]);
      if (i != rows.length - 1) {
        children.add(const Divider(height: 1, thickness: 1, color: OrderTokens.line));
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: OrderTokens.surface,
        border: Border.all(color: OrderTokens.line),
        borderRadius: OrderTokens.rCard,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D142823),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
