import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/order_summary/dto/order_summary_dto.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_card.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:get/get.dart';

/// The rider's balance, fetched with the quote when this page opens.
///
/// Display only for now — nothing spends it yet.
class SummaryWalletCard extends StatelessWidget {
  const SummaryWalletCard({super.key, required this.summary});

  final OrderSummaryDto summary;

  @override
  Widget build(BuildContext context) {
    return SummaryCard(
      title: 'your_balance'.tr,
      children: [
        Row(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 20,
              color: summary.hasWallet ? OrderTokens.primary : OrderTokens.muted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                summary.price(summary.walletBalance),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: summary.hasWallet ? OrderTokens.ink : OrderTokens.muted,
                ),
              ),
            ),
          ],
        ),
        if (!summary.hasWallet) ...[
          const SizedBox(height: 6),
          Text(
            'no_balance_for_order'.tr,
            style: TextStyle(fontSize: 12.5, color: OrderTokens.muted),
          ),
        ],
      ],
    );
  }
}
