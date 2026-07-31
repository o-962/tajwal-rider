import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:shared/shared/fields/index.dart';
import 'package:shared/shared/fields/interfaces/fields.dart';
import 'package:tajwal_rider/features/orders/gifts_order/controller/gifts_order_controller.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/confirm_order_button.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/departure_slot_button.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/departure_slot_sheet.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/location_picker_button.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/section_label.dart';

class GiftsOrderScreen extends StatelessWidget {
  GiftsOrderScreen({super.key});

  final GiftsOrderController controller = Get.find<GiftsOrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrderTokens.page,
      appBar: AppBar(elevation: 0, title: const Text('Gift Order')),
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

          // ── Gift type ──────────────────────────────────────────────────
          const SectionLabel('Gift type'),
          const SizedBox(height: 6),
          Obx(
            () => _gate(
              enabled: controller.routeReady,
              child: Row(
                children: [
                  Expanded(child: _typeChip(GiftType.NORMAL, 'Normal')),
                  const SizedBox(width: 10),
                  Expanded(child: _typeChip(GiftType.FAST, 'Fast')),
                ],
              ),
            ),
          ),
          FieldInput(field: controller.form.get(FieldInputType.TYPE)),
          const SizedBox(height: 14),

          // ── Gift size ──────────────────────────────────────────────────
          const SectionLabel('Gift size'),
          const SizedBox(height: 6),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _gate(
                  enabled: controller.routeReady,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _sizeChip(GiftSize.SMALL, 'Small'),
                      _sizeChip(GiftSize.MEDIUM, 'Medium'),
                      _sizeChip(GiftSize.LARGE, 'Large'),
                      _sizeChip(GiftSize.VERY_LARGE, 'Very large'),
                    ],
                  ),
                ),
                FieldInput(field: controller.form.get(FieldInputType.SIZE)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Recipient ──────────────────────────────────────────────────
          const SectionLabel('Recipient'),
          const SizedBox(height: 6),
          _gate(
            enabled: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(
                  hint: 'Recipient name',
                  keyboardType: TextInputType.name,
                  onChanged: controller.setRecipientName,
                ),
                FieldInput(field: controller.form.get(FieldInputType.RECIPIENT_NAME)),
                const SizedBox(height: 10),
                _field(
                  hint: 'Recipient phone',
                  keyboardType: TextInputType.phone,
                  onChanged: controller.setRecipientPhone,
                ),
                FieldInput(field: controller.form.get(FieldInputType.RECIPIENT_PHONE)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Gift photo ─────────────────────────────────────────────────
          const SectionLabel('Gift photo'),
          const SizedBox(height: 6),
          Obx(() => _imagePicker()),
          FieldInput(field: controller.form.get(FieldInputType.IMAGE)),
          const SizedBox(height: 14),

          // ── Departure slot ─────────────────────────────────────────────
          Obx(
            () => _gate(
              enabled: controller.routeReady,
              child: DepartureSlotButton(
                title: 'Choose a departure slot',
                subtitle: controller.hasSlot.value ? 'Departs at ${controller.slotLabel}' : 'Tap to pick a time slot',
                onTap: _openSlotSheet,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Total + confirm ────────────────────────────────────────────
          Obx(() => _totalBar()),
          const SizedBox(height: 12),
          Obx(
            // Goes to the summary page, not straight to the server — the order
            // is only created once the rider confirms the backend's figures.
            () => ConfirmOrderButton(
              enabled: controller.canConfirm,
              label: 'Review gift',
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

  Widget _typeChip(GiftType type, String label) {
    final selected = controller.order.type == type;
    return InkWell(
      onTap: () => controller.setType(type),
      borderRadius: OrderTokens.rField,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? OrderTokens.primary : OrderTokens.surface,
          border: Border.all(color: selected ? OrderTokens.primary : OrderTokens.line, width: 1.5),
          borderRadius: OrderTokens.rField,
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: selected ? Colors.white : OrderTokens.ink),
        ),
      ),
    );
  }

  Widget _sizeChip(GiftSize size, String label) {
    final selected = controller.order.size == size;
    return InkWell(
      onTap: () => controller.setSize(size),
      borderRadius: OrderTokens.rField,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? OrderTokens.primary : OrderTokens.surface,
          border: Border.all(color: selected ? OrderTokens.primary : OrderTokens.line, width: 1.5),
          borderRadius: OrderTokens.rField,
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? Colors.white : OrderTokens.ink),
        ),
      ),
    );
  }

  Widget _field({required String hint, required ValueChanged<String> onChanged, TextInputType? keyboardType}) {
    return TextField(
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: OrderTokens.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: OrderTokens.muted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        filled: true,
        fillColor: OrderTokens.surface,
        border: OutlineInputBorder(
          borderRadius: OrderTokens.rField,
          borderSide: const BorderSide(color: OrderTokens.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: OrderTokens.rField,
          borderSide: const BorderSide(color: OrderTokens.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: OrderTokens.rField,
          borderSide: const BorderSide(color: OrderTokens.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _imagePicker() {
    final image = controller.order.image;
    return InkWell(
      onTap: controller.pickImage,
      borderRadius: OrderTokens.rMap,
      child: Container(
        height: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: OrderTokens.accentSoft,
          border: Border.all(color: OrderTokens.accentBorder),
          borderRadius: OrderTokens.rMap,
        ),
        child: image == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: OrderTokens.accent, size: 28),
                  SizedBox(height: 8),
                  Text('Tap to upload a photo of the gift', style: TextStyle(fontSize: 13, color: OrderTokens.muted)),
                ],
              )
            : Image.file(image, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }

  Widget _totalBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: OrderTokens.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Estimated total · ${controller.order.type.value} gift',
            style: const TextStyle(fontSize: 14, color: OrderTokens.muted),
          ),
          Text(
            '${controller.total} JOD',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: OrderTokens.ink),
          ),
        ],
      ),
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
    if (!controller.routeReady) return 'Pick a pickup and dropoff to continue';
    if (!controller.hasRecipient) return 'Add the recipient name and phone to continue';
    if (!controller.hasImage) return 'Upload a photo of the gift to continue';
    return 'Pick a departure slot to continue';
  }
}
