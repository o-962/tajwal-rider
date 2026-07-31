import 'package:flutter/material.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/utils/contact_utils.dart';
import 'package:tajwal_rider/features/orders/current_order/model/current_order_model.dart';

/// The assigned driver: name, car details, and quick call / WhatsApp actions.
class CurrentOrderDriverCard extends StatelessWidget {
  const CurrentOrderDriverCard({super.key, required this.driver});

  final CurrentOrderDriver driver;

  static const Color _whatsapp = Color(0xFF25D366);

  @override
  Widget build(BuildContext context) {
    final hasPhone = driver.phoneNumber.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEFEC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: AppColor.secondary,
                child: Icon(Icons.person, color: AppColor.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name.isEmpty ? 'Your driver' : driver.name,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColor.black),
                    ),
                    if (driver.vehicleLabel.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.directions_car, size: 15, color: Colors.black45),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              driver.vehicleLabel,
                              style: const TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (driver.vehiclePlate.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColor.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE1E4E0)),
                  ),
                  child: Text(
                    driver.vehiclePlate,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColor.black, letterSpacing: 1),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.call,
                  label: 'Call',
                  color: AppColor.primary,
                  onTap: hasPhone ? () => makePhoneCall(driver.phoneNumber) : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: _whatsapp,
                  onTap: hasPhone ? () => openWhatsApp(driver.phoneNumber) : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
