import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:get/get.dart';

/// Shown when the rider has no past orders, and for load failures.
class RiderHistoryEmpty extends StatelessWidget {
  const RiderHistoryEmpty({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;

  /// Omitted for the genuinely-empty case — there's nothing to retry.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 44, color: OrderTokens.muted),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: OrderTokens.muted),
            ),
            if (onRetry != null) ...[
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
          ],
        ),
      ),
    );
  }
}
