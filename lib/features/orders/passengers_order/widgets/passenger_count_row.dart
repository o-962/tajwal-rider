import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/stepper_button.dart';

/// One passenger category row: title + per-seat price on the left,
/// a decrement / value / increment stepper on the right.
class PassengerCountRow extends StatelessWidget {
  const PassengerCountRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String title;
  final String subtitle;
  final int value;

  /// Null disables the respective stepper button.
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: OrderTokens.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: OrderTokens.muted),
                ),
              ],
            ),
          ),
          StepperButton(icon: Icons.remove, onTap: onDecrement),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: OrderTokens.ink,
              ),
            ),
          ),
          StepperButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}
