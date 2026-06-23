import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/base/base_screen.dart';
import 'package:shared/widgets/history/empty_history_widget.dart';
import 'package:tajwal_rider/features/history/trip_details_screen.dart';
import 'package:tajwal_rider/features/history/widgets/format_utils.dart';
import 'package:tajwal_rider/features/history/widgets/stat_card_widget.dart';
import 'package:tajwal_rider/features/history/widgets/trip_card_widget.dart';

import 'controllers/history_controller.dart';

class HistoryScreen extends BaseScreen<HistoryController> {
  const HistoryScreen({super.key})
  : super(title: 'trip_history', showLoading: true);

  @override
  Widget builder(HistoryController controller) {
    return Obx(() {
      final h = controller.history.value;
      if (h == null || h.orders.isEmpty) {
        return EmptyHistoryWidget(
          title: 'no_history'.tr,
          subtitle: 'history_empty'.tr,
        );
      }

      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: StatCardWidget(
                      icon: Icons.route,
                      label: 'trips'.tr,
                      value: h.totalOrders.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCardWidget(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'total'.tr,
                      value: formatMoney(h.totalCosts),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverList.separated(
              itemCount: h.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final o = h.orders[i];
                return TripCardWidget(
                  order: o,
                  onTap: () => Get.to(() => const TripDetailsScreen(), arguments: o),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
