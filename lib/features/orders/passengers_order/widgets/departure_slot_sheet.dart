import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajwal_rider/features/orders/passengers_order/controller/passengers_order_controller.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// Bottom sheet listing the route's bookable departures, grouped by day
/// (Today / Tomorrow / date). Slots in the past or inside the booking-close
/// window are shown disabled.
///
/// Controller-agnostic: any order flow passes in its computed [days], the
/// currently [selected] departure, an [formatHour] formatter and an [onPick].
class DepartureSlotSheet extends StatelessWidget {
  const DepartureSlotSheet({
    super.key,
    required this.days,
    required this.selected,
    required this.formatHour,
    required this.onPick,
  });

  final List<SlotDay> days;
  final DateTime? selected;
  final String Function(int hour) formatHour;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: OrderTokens.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: OrderTokens.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose a departure slot',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: OrderTokens.ink,
            ),
          ),
          const SizedBox(height: 14),
          if (days.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No departure slots available for this route.',
                style: TextStyle(fontSize: 13, color: OrderTokens.muted),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: days.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (_, i) => _DaySection(
                  day: days[i],
                  selected: selected,
                  formatHour: formatHour,
                  onPick: (dt) {
                    onPick(dt);
                    Get.back();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.day,
    required this.selected,
    required this.formatHour,
    required this.onPick,
  });

  final SlotDay day;
  final DateTime? selected;
  final String Function(int hour) formatHour;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          day.label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: OrderTokens.ink,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final slot in day.slots)
              _SlotChip(
                label: formatHour(slot.dateTime.hour),
                enabled: slot.enabled,
                selected: selected == slot.dateTime,
                onTap: () => onPick(slot.dateTime),
              ),
          ],
        ),
      ],
    );
  }
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({
    required this.label,
    required this.enabled,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: OrderTokens.rField,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? OrderTokens.primary : OrderTokens.surface,
            border: Border.all(
              color: selected ? OrderTokens.primary : OrderTokens.line,
              width: 1.5,
            ),
            borderRadius: OrderTokens.rField,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : OrderTokens.ink,
            ),
          ),
        ),
      ),
    );
  }
}
