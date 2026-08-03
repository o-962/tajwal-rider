import 'package:flutter/material.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/shared/enums/order_status.dart';
import 'package:tajwal_rider/features/orders/current_order/model/current_order_model.dart';
import 'package:tajwal_rider/features/orders/current_order/widgets/current_order_cancel_button.dart';
import 'package:tajwal_rider/features/orders/current_order/widgets/current_order_driver_card.dart';
import 'package:get/get.dart';
import 'package:shared/utils/area_label.dart';

/// The draggable details sheet over the map: status, driver (call / WhatsApp /
/// car), the pickup window, the route and cost, and cancel.
class CurrentOrderSheet extends StatelessWidget {
  const CurrentOrderSheet({
    super.key,
    required this.order,
    required this.scrollController,
    required this.onCancel,
  });

  final CurrentOrderModel order;
  final ScrollController scrollController;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final d = order.details;
    final state = _rideState(order);

    return Container(
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 18, offset: Offset(0, -4))],
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(color: const Color(0xFFDDE2DE), borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  order.isGift ? 'gift_delivery'.tr : 'passenger_ride'.tr,
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColor.black),
                ),
              ),
              _StatusPill(color: state.color, label: state.label),
            ],
          ),
          const SizedBox(height: 18),

          if (order.hasDriver)
            CurrentOrderDriverCard(driver: order.driver!)
          else
            _HoldingDriver(availableAt: d.detailsAvailableLabel),
          const SizedBox(height: 14),

          if (d.hasPickupWindow) ...[
            _PickupWindowCard(from: d.detailsAvailableLabel, to: d.scheduledLabel),
            const SizedBox(height: 14),
          ],

          _RouteCard(pickup: _area(d.pickupArea), dropoff: _area(d.dropoffArea)),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  icon: Icons.payments,
                  label: 'cost'.tr,
                  value: d.cost.isEmpty ? '—' : '${d.cost} JOD',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: order.isGift
                    ? _InfoTile(
                        icon: Icons.card_giftcard,
                        label: 'recipient'.tr,
                        value: d.recipientName.isEmpty ? (d.giftType.isEmpty ? 'gift'.tr : d.giftType) : d.recipientName,
                      )
                    : _InfoTile(icon: Icons.people_alt, label: 'seats'.tr, value: '${d.totalPassengers}'),
              ),
            ],
          ),
          const SizedBox(height: 22),

          CurrentOrderCancelButton(onCancel: onCancel),
        ],
      ),
    );
  }

  static String _area(String a) => areaLabel(a);
}

// On the rider side an order becomes an "active ride" the moment driver data is
// available — not based on the status enum (whose mobile values don't line up
// with the backend's), so "Finding a driver" only shows while truly unassigned.
({Color color, String label}) _rideState(CurrentOrderModel order) {
  switch (order.status) {
    case OrderStatus.CANCELLED:
      return (color: AppColor.alert, label: 'cancelled'.tr);
    case OrderStatus.COMPLETED:
      return (color: AppColor.primary, label: 'completed'.tr);
    default:
      return order.hasDriver
          ? (color: AppColor.primary, label: 'active_ride'.tr)
          : (color: AppColor.warning, label: 'in_holding'.tr);
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 7),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

/// Shown while no driver details are available yet — the order is held on the
/// driver board; the assigned driver's details become available at
/// [availableAt] (the order's details-available time).
class _HoldingDriver extends StatelessWidget {
  const _HoldingDriver({required this.availableAt});

  final String availableAt;

  @override
  Widget build(BuildContext context) {
    final hasTime = availableAt.isNotEmpty && availableAt != '—';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEFEC)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: AppColor.warning.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: const Icon(Icons.hourglass_top, color: AppColor.warning),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('in_holding'.tr, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColor.black)),
                const SizedBox(height: 2),
                Text(
                  hasTime ? '${'driver_details_available_at'.tr} $availableAt' : 'driver_details_available_soon'.tr,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PickupWindowCard extends StatelessWidget {
  const _PickupWindowCard({required this.from, required this.to});

  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.secondary.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: AppColor.primary),
              const SizedBox(width: 8),
              Text('pickup_window'.tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColor.primary)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'youll_be_picked_up_between'.tr,
            style: TextStyle(fontSize: 12, color: AppColor.primary.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 8),
          _WindowRow(label: 'from'.tr, value: from),
          const SizedBox(height: 6),
          _WindowRow(label: 'by'.tr, value: to),
        ],
      ),
    );
  }
}

class _WindowRow extends StatelessWidget {
  const _WindowRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 42,
          child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black54)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColor.black)),
        ),
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.pickup, required this.dropoff});

  final String pickup;
  final String dropoff;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEFEC)),
      ),
      child: Column(
        children: [
          _RouteRow(icon: Icons.trip_origin, color: AppColor.primary, label: 'pickup'.tr, value: pickup),
          Container(margin: const EdgeInsets.only(left: 10), width: 2, height: 20, color: AppColor.secondary),
          _RouteRow(icon: Icons.location_on, color: AppColor.warning, label: 'dropoff'.tr, value: dropoff),
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.icon, required this.color, required this.label, required this.value});

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black45)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColor.black)),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEFEC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColor.primary),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColor.black),
          ),
        ],
      ),
    );
  }
}
