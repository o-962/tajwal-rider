import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/shared/enums/order_status.dart';
import 'package:tajwal_rider/common/pages.dart';
import 'package:tajwal_rider/features/orders/current_order/model/current_order_model.dart';
import 'package:shared/utils/area_label.dart';

/// The rider's active order, shown prominently on home so the screen stays full
/// and informative while an order is in progress: status, route, key details,
/// the driver (or "finding one"), and a button to track it live.
class HomeActiveOrderCard extends StatelessWidget {
  const HomeActiveOrderCard({super.key, required this.order});

  final CurrentOrderModel order;

  @override
  Widget build(BuildContext context) {
    final status = _rideState(order);
    final details = order.details;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coloured status header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              children: [
                Container(width: 9, height: 9, decoration: BoxDecoration(color: status.color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(status.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: status.color)),
                const Spacer(),
                _TypeBadge(isGift: order.isGift),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route timeline
                _RouteRow(icon: Icons.trip_origin, color: AppColor.primary, label: 'pickup'.tr, area: _area(details.pickupArea)),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 2,
                  height: 22,
                  color: AppColor.secondary,
                ),
                _RouteRow(icon: Icons.location_on, color: AppColor.warning, label: 'dropoff'.tr, area: _area(details.dropoffArea)),
                const SizedBox(height: 18),
                // Key details
                Row(
                  children: [
                    Expanded(child: _Meta(icon: Icons.schedule, value: details.scheduledLabel)),
                    Expanded(
                      child: _Meta(
                        icon: order.isGift ? Icons.card_giftcard : Icons.people_alt,
                        value: order.isGift ? _giftLabel(details) : '${details.totalPassengers} ${'seats_lower'.tr}',
                      ),
                    ),
                    Expanded(child: _Meta(icon: Icons.payments, value: _cost(details.cost))),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFEDEFEC)),
                const SizedBox(height: 14),
                // Driver
                if (order.hasDriver) _DriverStrip(driver: order.driver!) else _HoldingDriver(availableAt: details.detailsAvailableLabel),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.currentOrder),
                    icon: const Icon(Icons.navigation, size: 18),
                    label: Text('track_order'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _area(String value) => areaLabel(value);
  static String _cost(String value) => value.isEmpty ? '—' : '$value JOD';
  static String _giftLabel(CurrentOrderDetails d) =>
      d.recipientName.isNotEmpty ? d.recipientName : (d.giftType.isNotEmpty ? d.giftType : 'gift'.tr);
}

// An order reads as an "active ride" as soon as driver data is available, not
// from the status enum (mobile values don't match the backend's).
({Color color, String label}) _rideState(CurrentOrderModel order) {
  switch (order.status) {
    case OrderStatus.CANCELLED:
      return (color: AppColor.alert, label: 'cancelled'.tr);
    case OrderStatus.COMPLETED:
      return (color: AppColor.primary, label: 'completed'.tr);
    default:
      return order.hasDriver
          ? (color: AppColor.primary, label: 'active_ride'.tr)
          : (color: AppColor.warning, label: 'finding_a_driver'.tr);
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.isGift});

  final bool isGift;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isGift ? Icons.card_giftcard : Icons.directions_car, size: 14, color: AppColor.primary),
          const SizedBox(width: 5),
          Text(isGift ? 'gift'.tr : 'ride'.tr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColor.primary)),
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.icon, required this.color, required this.label, required this.area});

  final IconData icon;
  final Color color;
  final String label;
  final String area;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black45)),
            Text(area, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColor.black)),
          ],
        ),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColor.primary),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.black),
        ),
      ],
    );
  }
}

class _DriverStrip extends StatelessWidget {
  const _DriverStrip({required this.driver});

  final CurrentOrderDriver driver;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(radius: 22, backgroundColor: AppColor.secondary, child: Icon(Icons.person, color: AppColor.primary)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driver.name.isEmpty ? 'your_driver'.tr : driver.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColor.black),
              ),
              if (driver.vehicleLabel.isNotEmpty)
                Text(driver.vehicleLabel, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
        if (driver.vehiclePlate.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColor.background, borderRadius: BorderRadius.circular(8)),
            child: Text(driver.vehiclePlate, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColor.black)),
          ),
      ],
    );
  }
}

/// No driver details yet — the order is held on the driver board; the assigned
/// driver's details become available at [availableAt].
class _HoldingDriver extends StatelessWidget {
  const _HoldingDriver({required this.availableAt});

  final String availableAt;

  @override
  Widget build(BuildContext context) {
    final hasTime = availableAt.isNotEmpty && availableAt != '—';
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: AppColor.warning.withValues(alpha: 0.15), shape: BoxShape.circle),
          child: const Icon(Icons.hourglass_top, color: AppColor.warning),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('in_holding'.tr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColor.black)),
              const SizedBox(height: 2),
              Text(
                hasTime ? '${'driver_details_available_at'.tr} $availableAt' : 'driver_details_available_soon'.tr,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
