import 'package:flutter/material.dart';
import 'package:shared/shared/constants/colors.dart';

/// A simple 3-item strip highlighting what the app offers — keeps the empty
/// (no active order) home from feeling bare.
class HomeFeatureStrip extends StatelessWidget {
  const HomeFeatureStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _Feature(icon: Icons.verified_user, label: 'Trusted\ndrivers')),
        Expanded(child: _Feature(icon: Icons.map_outlined, label: 'City to\ncity')),
        Expanded(child: _Feature(icon: Icons.card_giftcard, label: 'Send\ngifts')),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(color: AppColor.secondary, borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: AppColor.primary),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, height: 1.2, fontWeight: FontWeight.w600, color: AppColor.black),
        ),
      ],
    );
  }
}
