import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// A single read-only account field: label above a disabled, boxed value.
///
/// Deliberately not a TextField — there is nothing to edit here, so this renders
/// the value in a permanently-disabled container rather than a focusable input.
class AccountField extends StatelessWidget {
  const AccountField({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final display = value.trim().isEmpty ? '—' : value.trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: OrderTokens.label),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              // Muted fill signals "disabled" at a glance.
              color: const Color(0xFFF4F6F5),
              borderRadius: OrderTokens.rField,
              border: Border.all(color: OrderTokens.line),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: OrderTokens.muted),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    display,
                    style: const TextStyle(fontSize: 14.5, color: OrderTokens.ink),
                  ),
                ),
                const Icon(Icons.lock_outline, size: 15, color: OrderTokens.muted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
