import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/history/dto/rider_history_dto.dart';
import 'package:tajwal_rider/features/history/widgets/rider_history_status_chip.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:get/get.dart';

/// One past order: type + status, route, what it was, and what it cost.
class RiderHistoryCard extends StatelessWidget {
  const RiderHistoryCard({super.key, required this.order});

  final RiderHistoryOrderDto order;

  @override
  Widget build(BuildContext context) {
    final gift = order.gift;
    final passengers = order.passengers;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OrderTokens.surface,
        borderRadius: OrderTokens.rCard,
        border: Border.all(color: OrderTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                order.isGift ? Icons.card_giftcard : Icons.directions_car,
                size: 18,
                color: OrderTokens.muted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.isGift ? 'gift_delivery'.tr : 'passenger_ride'.tr,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: OrderTokens.ink),
                ),
              ),
              RiderHistoryStatusChip(status: order.status, label: order.statusLabel),
            ],
          ),
          const SizedBox(height: 12),

          _row(Icons.route_outlined, order.routeLabel, emphasize: true),
          const SizedBox(height: 6),
          _row(Icons.schedule, order.scheduledLabel),

          if (order.isGift && gift != null) ...[
            const SizedBox(height: 6),
            _row(Icons.inventory_2_outlined, '${_title(gift.type)} · ${_title(gift.size)}'),
            if (gift.recipientName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: _row(Icons.person_outline, gift.recipientName),
              ),
          ] else if (passengers != null) ...[
            const SizedBox(height: 6),
            _row(
              Icons.event_seat_outlined,
              '${passengers.totalCount} ${passengers.totalCount == 1 ? 'seat'.tr : 'seats_lower'.tr}'
              ' · ${passengers.maleCount}M / ${passengers.femaleCount}F',
            ),
          ],

          if (order.hasDriver) ...[
            const SizedBox(height: 6),
            _row(Icons.badge_outlined, '${'driver'.tr}: ${order.driverName}'),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: OrderTokens.line),
          ),

          // Price. When a discount applied, show the fare struck through beside
          // what was actually paid.
          Row(
            children: [
              Text('paid'.tr, style: TextStyle(fontSize: 13, color: OrderTokens.muted)),
              const Spacer(),
              if (order.hasDiscount) ...[
                Text(
                  order.price(order.cost),
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: OrderTokens.muted,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                order.price(order.paid),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: OrderTokens.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text, {bool emphasize = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: OrderTokens.muted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: emphasize ? 14 : 12.5,
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
              color: emphasize ? OrderTokens.ink : OrderTokens.muted,
            ),
          ),
        ),
      ],
    );
  }

  static String _title(String raw) =>
      raw.isEmpty ? '—' : raw[0].toUpperCase() + raw.substring(1).toLowerCase();
}
