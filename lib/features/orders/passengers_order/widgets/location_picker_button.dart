import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// A pickup / dropoff row: a coloured dot, the selected place label,
/// and a trailing chevron — tappable to open the location picker.
class LocationPickerButton extends StatelessWidget {
  const LocationPickerButton({
    super.key,
    required this.dotColor,
    required this.label,
    required this.onTap,
  });

  final Color dotColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: OrderTokens.rField,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: OrderTokens.surface,
          border: Border.all(color: OrderTokens.line),
          borderRadius: OrderTokens.rField,
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: OrderTokens.ink),
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: OrderTokens.muted),
          ],
        ),
      ),
    );
  }
}
