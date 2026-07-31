import 'package:flutter/material.dart';
import 'package:shared/index.dart';
import 'package:tajwal_rider/features/orders/order_summary/widgets/summary_card.dart';
import 'package:tajwal_rider/features/orders/passengers_order/widgets/order_tokens.dart';

/// Discount code entry. Applying re-requests the quote from the backend, so the
/// code is genuinely sent and the total always comes back from the server —
/// even while the discount logic itself is still a no-op.
class SummaryDiscountField extends StatelessWidget {
  const SummaryDiscountField({
    super.key,
    required this.input,
    required this.applying,
    required this.onApply,
    required this.onClear,
    required this.message,
    required this.applied,
  });

  final TextEditingController input;
  final bool applying;
  final VoidCallback onApply;

  /// Clears an applied code and re-quotes at full price.
  final VoidCallback onClear;

  /// Verdict copy from the last validation, or null if none has run.
  final String? message;

  /// Whether that verdict was a success — drives the icon and colour.
  final bool applied;

  @override
  Widget build(BuildContext context) {
    return SummaryCard(
      title: 'Discount code',
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: input,
                // Locked once a code is applied — the ✕ button beside it is the
                // way back to editing. `readOnly` (not `enabled: false`) keeps
                // the field's own gestures alive; a fully disabled field also
                // swallows taps on anything drawn inside it.
                readOnly: applied,
                textCapitalization: TextCapitalization.characters,
                onSubmitted: (_) => onApply(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: applied ? FontWeight.w700 : FontWeight.w500,
                  color: OrderTokens.ink,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter a code',
                  hintStyle: const TextStyle(fontSize: 13.5, color: OrderTokens.muted),
                  isDense: true,
                  filled: applied,
                  fillColor: applied ? OrderTokens.primary.withValues(alpha: 0.06) : null,
                  border: OutlineInputBorder(
                    borderRadius: OrderTokens.rField,
                    borderSide: const BorderSide(color: OrderTokens.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: OrderTokens.rField,
                    borderSide: BorderSide(
                      color: applied ? OrderTokens.primary : OrderTokens.line,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: OrderTokens.rField,
                    borderSide: const BorderSide(color: OrderTokens.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Standalone action button — a real, always-tappable button. Applied:
            // a ✕ that clears the code. Not applied: Apply.
            SizedBox(
              height: 44,
              child: applied
                  ? OutlinedButton(
                      onPressed: onClear,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: OrderTokens.muted,
                        side: const BorderSide(color: OrderTokens.line),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(borderRadius: OrderTokens.rField),
                      ),
                      child: const Icon(Icons.close, size: 18),
                    )
                  : OutlinedButton(
                      onPressed: applying ? null : onApply,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: OrderTokens.primary,
                        side: const BorderSide(color: OrderTokens.primary),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(borderRadius: OrderTokens.rField),
                      ),
                      child: applying
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Apply',
                              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                            ),
                    ),
            ),
          ],
        ),

        // The server's verdict on the code. Green when it took, amber with the
        // reason when it didn't — so a refused code never silently leaves the
        // full fare showing with no explanation.
        if (message != null) ...[
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                applied ? Icons.check_circle_outline : Icons.info_outline,
                size: 16,
                color: applied ? OrderTokens.primary : AppColor.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message!,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: applied ? OrderTokens.primary : OrderTokens.ink,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
