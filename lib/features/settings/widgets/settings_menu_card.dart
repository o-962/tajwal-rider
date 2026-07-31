import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// One tappable row: icon tile, title + subtitle, chevron.
class SettingsMenuCard extends StatelessWidget {
  const SettingsMenuCard({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: OrderTokens.rCard,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: OrderTokens.surface,
          borderRadius: OrderTokens.rCard,
          border: Border.all(color: OrderTokens.line),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: OrderTokens.ink)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: OrderTokens.muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: OrderTokens.muted),
          ],
        ),
      ),
    );
  }
}
