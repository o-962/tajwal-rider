import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:get/get.dart';

/// Shown when the backend refuses to quote the draft — an unserviceable route,
/// an order already active, and so on. The rider retries or goes back and edits.
class SummaryErrorView extends StatelessWidget {
  const SummaryErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: OrderTokens.muted),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: OrderTokens.ink),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: OrderTokens.primary,
                side: const BorderSide(color: OrderTokens.primary),
                shape: RoundedRectangleBorder(borderRadius: OrderTokens.rField),
              ),
              child: Text('try_again'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
