import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// A 32×32 rounded square +/- control used by the passenger steppers.
class StepperButton extends StatelessWidget {
  const StepperButton({super.key, required this.icon, this.onTap});

  final IconData icon;

  /// When null the button reads as disabled (dimmed, non-interactive).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: OrderTokens.surface,
            border: Border.all(color: OrderTokens.line),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 18, color: OrderTokens.primary),
        ),
      ),
    );
  }
}
