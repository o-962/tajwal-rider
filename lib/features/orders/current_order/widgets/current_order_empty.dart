import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// Shown when the rider has no active order at all.
class CurrentOrderEmpty extends StatelessWidget {
  const CurrentOrderEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'You have no active order',
        style: TextStyle(color: OrderTokens.muted, fontSize: 15),
      ),
    );
  }
}
