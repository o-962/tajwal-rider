import 'package:flutter/material.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';
import 'package:get/get.dart';

/// An "Any / Male / Female" gender-preference selector, used for both the
/// preferred driver and the preferred co-passengers.
///
/// A rider may only ask for the passengers' own gender: an all-male order can
/// request male, an all-female order female. Mixed orders (and an empty car)
/// have no same-gender answer, so [sameGender] is null and only "Any" stays
/// selectable.
///
/// The backend enforces both choices when matching — an order asking for a
/// female driver never reaches a male driver's pending list, and one asking for
/// female co-passengers is never offered alongside male seats in the same slot.
class GenderPreferenceSelector extends StatelessWidget {
  const GenderPreferenceSelector({
    super.key,
    required this.selected,
    required this.sameGender,
    required this.onChanged,
  });

  /// The currently requested gender.
  final PreferredGender selected;

  /// The one non-ANY option this seat mix allows, or null when there is none
  /// (mixed seats, or no passengers picked yet).
  final PreferredGender? sameGender;

  final ValueChanged<PreferredGender> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _option(PreferredGender.ANY, 'any'.tr)),
        const SizedBox(width: 8),
        Expanded(child: _option(PreferredGender.MALE, 'male'.tr)),
        const SizedBox(width: 8),
        Expanded(child: _option(PreferredGender.FEMALE, 'female'.tr)),
      ],
    );
  }

  Widget _option(PreferredGender gender, String label) {
    // "Any" is always available; a specific gender only when the passengers
    // share it.
    final bool enabled = gender == PreferredGender.ANY || gender == sameGender;
    return _Option(
      label: label,
      selected: selected == gender && enabled,
      onTap: enabled ? () => onChanged(gender) : null,
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({required this.label, required this.selected, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: OrderTokens.rField,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
          alignment: Alignment.center,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : OrderTokens.ink,
            ),
          ),
        ),
      ),
    );
  }
}
