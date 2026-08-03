import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/passengers_order/controller/passengers_order_controller.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/confirm_order_button.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/departure_slot_button.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/departure_slot_sheet.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/estimated_total_bar.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/gender_preference_selector.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/info_note.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/location_picker_button.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/route_swap_button.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/passenger_count_card.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/passenger_count_row.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/seats_header.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/section_label.dart';

class PassengersOrderScreen extends StatelessWidget {
  PassengersOrderScreen({super.key});

  final PassengersOrderController controller = Get.find<PassengersOrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrderTokens.page,
      appBar: AppBar(
        elevation: 0,
        title: Text('passengers_order'.tr),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        children: [
          // ── Pickup & dropoff ───────────────────────────────────────────
          SectionLabel('pickup_and_dropoff'.tr),
          const SizedBox(height: 6),
          Obx(
            () => LocationPickerButton(
              dotColor: OrderTokens.primary,
              label: controller.pickupLabel.value,
              onTap: () => controller.openPickup(),
            ),
          ),
          const SizedBox(height: 6),
          // The only way to reverse a trip in place — each picker hides the
          // other leg's area, so a return trip is otherwise unbuildable.
          Obx(
            () => RouteSwapButton(
              enabled: controller.routeReady,
              onTap: controller.swapRoute,
            ),
          ),
          const SizedBox(height: 6),
          // Dropoff unlocks only once a pickup point is chosen.
          Obx(
            () => _gate(
              enabled: controller.hasPickup,
              child: LocationPickerButton(
                dotColor: OrderTokens.accent,
                label: controller.dropLabel.value,
                onTap: () => controller.openDropoff(),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Seats ──────────────────────────────────────────────────────
          Obx(
            () => SeatsHeader(
              selected: controller.totalSeats,
              max: controller.maxSeats,
            ),
          ),
          const SizedBox(height: 6),
          // Everything below stays disabled until pickup + dropoff are set.
          Obx(() => _gate(enabled: controller.routeReady, child: _passengerCard())),
          const SizedBox(height: 14),

          // ── Gender preferences ─────────────────────────────────────────
          // Each row is a platform feature flag: when it's off the backend
          // ignores that preference when matching, so offering the choice would
          // be a promise the server doesn't keep.
          if (controller.showDriverGender) ...[
            SectionLabel('preferred_driver'.tr),
            const SizedBox(height: 6),
            Obx(
              () => _gate(
                enabled: controller.routeReady,
                child: GenderPreferenceSelector(
                  selected: controller.driverGender.value,
                  sameGender: controller.sameGenderOption,
                  onChanged: controller.setDriverGender,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (controller.showCoPassengersGender) ...[
            SectionLabel('preferred_co_passengers'.tr),
            const SizedBox(height: 6),
            Obx(
              () => _gate(
                enabled: controller.routeReady,
                child: GenderPreferenceSelector(
                  selected: controller.coPassengersGender.value,
                  sameGender: controller.sameGenderOption,
                  onChanged: controller.setCoPassengersGender,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (controller.showDriverGender || controller.showCoPassengersGender) ...[
            InfoNote('gender_request_note'.tr),
            const SizedBox(height: 14),
          ],

          // ── Departure slot ─────────────────────────────────────────────
          Obx(
            () => _gate(
              enabled: controller.routeReady,
              child: DepartureSlotButton(
                title: 'choose_departure_slot'.tr,
                subtitle: controller.hasSlot.value
                    ? '${'departs_at'.tr} ${controller.slotLabel}'
                    : 'tap_to_pick_time_slot'.tr,
                onTap: _openSlotSheet,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Total + confirm ────────────────────────────────────────────
          Obx(
            () => EstimatedTotalBar(
              seats: controller.totalSeats,
              total: controller.total,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            // Goes to the summary page, not straight to the server — the order
            // is only created once the rider confirms the backend's figures.
            () => ConfirmOrderButton(
              enabled: controller.canConfirm,
              label: 'review_order'.tr,
              caption: controller.canConfirm ? null : _confirmHint(),
              onTap: controller.openSummary,
            ),
          ),
        ],
      ),
    );
  }

  /// Dims and blocks taps on [child] while [enabled] is false.
  Widget _gate({required bool enabled, required Widget child}) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: AbsorbPointer(absorbing: !enabled, child: child),
    );
  }

  void _openSlotSheet() {
    Get.bottomSheet(
      DepartureSlotSheet(
        days: controller.slotDays,
        selected: controller.order.scheduledAt,
        formatHour: controller.formatHour,
        onPick: controller.selectSlot,
      ),
      isScrollControlled: true,
    );
  }

  String _confirmHint() {
    if (controller.rideCost == null) return 'pick_pickup_dropoff_to_continue'.tr;
    if (controller.totalSeats == 0) return 'add_passenger_to_continue'.tr;
    return 'pick_departure_slot_to_continue'.tr;
  }

  Widget _passengerCard() {
    final order = controller.order;
    final bool canAdd = controller.totalSeats < controller.maxSeats;

    return PassengerCountCard(
      rows: [
        PassengerCountRow(
          title: 'male_passengers'.tr,
          subtitle: '${controller.maleCost} ${'jod_each'.tr}',
          value: order.maleCount,
          onDecrement:
              order.maleCount > 0 ? () => controller.setMaleCount(order.maleCount - 1) : null,
          onIncrement: canAdd ? () => controller.setMaleCount(order.maleCount + 1) : null,
        ),
        PassengerCountRow(
          title: 'female_passengers'.tr,
          subtitle: '${controller.femaleCost} ${'jod_each'.tr}',
          value: order.femaleCount,
          onDecrement:
              order.femaleCount > 0 ? () => controller.setFemaleCount(order.femaleCount - 1) : null,
          onIncrement: canAdd ? () => controller.setFemaleCount(order.femaleCount + 1) : null,
        ),
      ],
    );
  }
}
