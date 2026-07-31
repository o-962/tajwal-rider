import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// The full-width primary action with an optional helper caption below it.
/// Dimmed and non-interactive while [enabled] is false.
class ConfirmOrderButton extends StatelessWidget {
  const ConfirmOrderButton({
    super.key,
    required this.enabled,
    required this.label,
    required this.caption,
    required this.onTap,
  });

  final bool enabled;
  final String label;
  final String? caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: enabled ? 1 : 0.4,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: enabled ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: OrderTokens.primary,
                disabledBackgroundColor: OrderTokens.primary,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: 8),
          Text(
            caption!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: OrderTokens.muted),
          ),
        ],
      ],
    );
  }
}
