import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:get/get.dart';

/// Reverses pickup and dropoff.
///
/// Not a convenience: pickup hides the chosen dropoff area and dropoff hides the
/// chosen pickup area, so without this a rider on Amman→Irbid is offered neither
/// area they need to build Irbid→Amman and has to abandon the order. This is the
/// only in-place route reversal.
///
/// [enabled] tracks "both legs chosen", not "the reverse route exists". Whether
/// the reversed pair is actually priced is the controller's call, and it says so
/// with a toast — a silently dead button would leave the rider guessing.
class RouteSwapButton extends StatelessWidget {
  const RouteSwapButton({
    super.key,
    required this.enabled,
    required this.onTap,
  });

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? OrderTokens.primary : OrderTokens.muted;

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Tooltip(
        message: 'swap_pickup_dropoff'.tr,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: OrderTokens.surface,
              border: Border.all(color: enabled ? color : OrderTokens.line),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.swap_vert, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  'swap'.tr,
                  style: TextStyle(fontSize: 12, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
