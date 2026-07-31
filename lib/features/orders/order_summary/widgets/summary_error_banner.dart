import 'package:flutter/material.dart';
import 'package:shared/index.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// Inline notice for a re-quote that failed while a summary is already on
/// screen — e.g. applying a discount code with no connection. Without it the
/// Apply button would appear to do nothing at all.
class SummaryErrorBanner extends StatelessWidget {
  const SummaryErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.warning.withValues(alpha: 0.12),
        borderRadius: OrderTokens.rField,
        border: Border.all(color: AppColor.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColor.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: OrderTokens.ink),
            ),
          ),
        ],
      ),
    );
  }
}
