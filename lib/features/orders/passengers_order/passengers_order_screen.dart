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
        title: const Text('Passengers Order'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        children: [
          // ── Pickup & dropoff ───────────────────────────────────────────
          const SectionLabel('Pickup & dropoff'),
          const SizedBox(height: 6),
          Obx(
            () => LocationPickerButton(
              dotColor: OrderTokens.primary,
              label: controller.pickupLabel.value,
              onTap: () => controller.openPickup(),
            ),
          ),
          const SizedBox(height: 10),
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
            const SectionLabel('Preferred driver'),
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
            const SectionLabel('Preferred co-passengers'),
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
            const InfoNote(
              'You can only request the passengers\' own gender. '
              'Mixed male & female seats ride with anyone.',
            ),
            const SizedBox(height: 14),
          ],

          // ── Departure slot ─────────────────────────────────────────────
          Obx(
            () => _gate(
              enabled: controller.routeReady,
              child: DepartureSlotButton(
                title: 'Choose a departure slot',
                subtitle: controller.hasSlot.value
                    ? 'Departs at ${controller.slotLabel}'
                    : 'Tap to pick a time slot',
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
              label: 'Review order',
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
    if (controller.rideCost == null) return 'Pick a pickup and dropoff to continue';
    if (controller.totalSeats == 0) return 'Add at least one passenger to continue';
    return 'Pick a departure slot to continue';
  }

  Widget _passengerCard() {
    final order = controller.order;
    final bool canAdd = controller.totalSeats < controller.maxSeats;

    return PassengerCountCard(
      rows: [
        PassengerCountRow(
          title: 'Male passengers',
          subtitle: '${controller.maleCost} JOD each',
          value: order.maleCount,
          onDecrement:
              order.maleCount > 0 ? () => controller.setMaleCount(order.maleCount - 1) : null,
          onIncrement: canAdd ? () => controller.setMaleCount(order.maleCount + 1) : null,
        ),
        PassengerCountRow(
          title: 'Female passengers',
          subtitle: '${controller.femaleCost} JOD each',
          value: order.femaleCount,
          onDecrement:
              order.femaleCount > 0 ? () => controller.setFemaleCount(order.femaleCount - 1) : null,
          onIncrement: canAdd ? () => controller.setFemaleCount(order.femaleCount + 1) : null,
        ),
      ],
    );
  }
}
