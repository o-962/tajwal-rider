import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:get/get.dart';

/// Shown when the rider has no active order at all.
class CurrentOrderEmpty extends StatelessWidget {
  const CurrentOrderEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'no_active_order'.tr,
        style: TextStyle(color: OrderTokens.muted, fontSize: 15),
      ),
    );
  }
}
