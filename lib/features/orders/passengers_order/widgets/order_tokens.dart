import 'package:flutter/material.dart';

/// Design tokens for the passengers-order screen, mirroring the
/// reference mock-up palette and spacing one-to-one.
class OrderTokens {
  OrderTokens._();

  // ── Palette ────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0F5A4E);
  static const Color accent = Color(0xFFE8853A);
  static const Color accentSoft = Color(0xFFFBEEE1);
  static const Color accentBorder = Color(0xFFF1D9C4);
  static const Color ink = Color(0xFF1B2B26);
  static const Color muted = Color(0xFF7C8884);
  static const Color line = Color(0xFFE3E9E6);
  static const Color surface = Colors.white;
  static const Color page = Colors.white;

  // ── Radii ──────────────────────────────────────────────────────────────
  static const BorderRadius rField = BorderRadius.all(Radius.circular(12));
  static const BorderRadius rCard = BorderRadius.all(Radius.circular(16));
  static const BorderRadius rMap = BorderRadius.all(Radius.circular(14));

  // ── Text styles ────────────────────────────────────────────────────────
  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: muted,
    letterSpacing: 0.6,
  );
}
