import 'package:flutter/material.dart';
import 'package:tajwal_rider/features/orders/order_summary/dto/order_summary_dto.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_card.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_row.dart';
import 'package:get/get.dart';

/// The half of the summary that differs by order type: seats for a passenger
/// ride, type + size for a gift. The backend sends exactly one of the two.
class SummaryDetailsCard extends StatelessWidget {
  const SummaryDetailsCard({super.key, required this.summary});

  final OrderSummaryDto summary;

  @override
  Widget build(BuildContext context) {
    final gift = summary.gift;
    final passengers = summary.passengers;

    if (summary.isGift && gift != null) {
      return SummaryCard(
        title: 'gift'.tr,
        children: [
          SummaryRow(label: 'delivery'.tr, value: _titleCase(gift.type), emphasize: true),
          SummaryRow(label: 'size'.tr, value: _titleCase(gift.size)),
        ],
      );
    }

    if (passengers == null) return const SizedBox.shrink();

    return SummaryCard(
      title: 'seats'.tr,
      children: [
        SummaryRow(
          label: 'total'.tr,
          value: '${passengers.totalCount} ${passengers.totalCount == 1 ? 'seat'.tr : 'seats_lower'.tr}',
          emphasize: true,
        ),
        if (passengers.maleCount > 0)
          SummaryRow(label: 'male'.tr, value: passengers.maleCount.toString()),
        if (passengers.femaleCount > 0)
          SummaryRow(label: 'female'.tr, value: passengers.femaleCount.toString()),
      ],
    );
  }

  static String _titleCase(String raw) {
    if (raw.isEmpty) return '—';
    return raw[0].toUpperCase() + raw.substring(1).toLowerCase();
  }
}
