import 'package:intl/intl.dart';
import 'package:shared/utils/parsing.dart';

/// The backend's final calculation for a draft order, as returned by
/// `POST /orders/passengers/summary` and `POST /orders/gifts/summary`.
///
/// Every number here is computed server-side — the screen only displays it, so
/// what the rider confirms is exactly what the create will charge.
class OrderSummaryDto {
  final String orderType;
  final String pickupArea;
  final String dropoffArea;

  /// Raw wire values; use the *Label getters to display.
  final String scheduledAt;

  /// The driver picks the rider up between [detailsAvailableAt] and
  /// [scheduledAt].
  final String detailsAvailableAt;

  /// Set for passenger orders, null for gifts.
  final OrderSummaryPassengers? passengers;

  /// Set for gift orders, null for passenger rides.
  final OrderSummaryGift? gift;

  final double baseCost;
  final String? discountCode;
  final double discountAmount;

  /// Whether the code actually reduced the fare.
  final bool discountApplied;

  /// The server's verdict code — why it did or didn't apply. Null when the
  /// rider supplied no code at all.
  final String? discountReason;

  /// The code's own blurb, shown once it applies.
  final String? discountDescription;

  final double totalCost;
  final String currency;

  /// The rider's balance in JOD, fetched with the quote.
  final double walletBalance;

  const OrderSummaryDto({
    required this.orderType,
    required this.pickupArea,
    required this.dropoffArea,
    required this.scheduledAt,
    required this.detailsAvailableAt,
    required this.passengers,
    required this.gift,
    required this.baseCost,
    required this.discountCode,
    required this.discountAmount,
    required this.discountApplied,
    required this.discountReason,
    required this.discountDescription,
    required this.totalCost,
    required this.currency,
    required this.walletBalance,
  });

  bool get isGift => orderType == 'gift';
  bool get hasDiscount => discountAmount > 0;

  /// Whether the rider has anything in their wallet to spend.
  bool get hasWallet => walletBalance > 0;

  /// A code was entered but the server refused it.
  bool get discountRejected => discountReason != null && !discountApplied;

  /// Copy for the server's verdict on the code this quote was priced with.
  String? get discountMessage => discountReasonMessage(discountReason);
  bool get hasPickupWindow => detailsAvailableAt.isNotEmpty && scheduledAt.isNotEmpty;

  String get scheduledLabel => _fmt(scheduledAt);
  String get detailsAvailableLabel => _fmt(detailsAvailableAt);

  String get routeLabel => '${_area(pickupArea)} → ${_area(dropoffArea)}';

  String price(double value) => '${_trim(value)} $currency';

  factory OrderSummaryDto.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => (v ?? '').toString();
    Map<String, dynamic> obj(dynamic v) =>
        v is Map ? Map<String, dynamic>.from(v) : const <String, dynamic>{};

    final passengers = json['passengers'];
    final gift = json['gift'];
    final code = json['discount_code'];
    return OrderSummaryDto(
      orderType: s(json['order_type']),
      pickupArea: s(json['pickup_area']),
      dropoffArea: s(json['dropoff_area']),
      scheduledAt: s(json['scheduled_at']),
      detailsAvailableAt: s(json['details_available_at']),
      passengers: passengers is Map
          ? OrderSummaryPassengers.fromJson(obj(passengers))
          : null,
      gift: gift is Map ? OrderSummaryGift.fromJson(obj(gift)) : null,
      baseCost: toDouble(json['base_cost']),
      discountCode: code == null || s(code).isEmpty ? null : s(code),
      discountAmount: toDouble(json['discount_amount']),
      discountApplied: json['discount_applied'] == true,
      discountReason: _nullIfEmpty(s(json['discount_reason'])),
      discountDescription: _nullIfEmpty(s(json['discount_description'])),
      totalCost: toDouble(json['total_cost']),
      walletBalance: toDouble(json['wallet_balance']),
      currency: s(json['currency']).isEmpty ? 'JOD' : s(json['currency']),
    );
  }

  static String? _nullIfEmpty(String value) => value.isEmpty ? null : value;

  /// "amman" → "Amman".
  static String _area(String raw) {
    if (raw.isEmpty) return '—';
    return raw[0].toUpperCase() + raw.substring(1);
  }

  /// Drops a trailing ".0" so whole prices read "15 JOD", not "15.0 JOD".
  static String _trim(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  /// Formats a wire date string (ISO or a JS `Date.toString()`) for display.
  static String _fmt(String raw) {
    if (raw.isEmpty) return '—';
    final dt = DateTime.tryParse(raw);
    if (dt != null) return DateFormat('EEE, MMM d · h:mm a').format(dt.toLocal());
    final gmt = raw.indexOf(' GMT');
    return gmt > 0 ? raw.substring(0, gmt) : raw;
  }
}

/// Copy for a backend discount verdict code (a MessagesEnum value).
///
/// Shared by the quote and the standalone `/discounts/validate` endpoint, which
/// speak the same reason vocabulary. Falls back to the raw code de-underscored
/// so a reason added on the server still reads as something here.
String? discountReasonMessage(String? reason) {
  if (reason == null) return null;
  const messages = {
    'discount_applied': 'Code applied.',
    'success': 'Code applied.',
    'invalid_discount_code': "That code doesn't exist.",
    'discounts_not_available': 'Discount codes are turned off right now.',
    'discount_inactive': 'That code is no longer active.',
    'discount_not_started': "That code isn't active yet.",
    'discount_expired': 'That code has expired.',
    'discount_min_order_not_met': 'This order is too small for that code.',
    'discount_usage_limit_reached': 'That code has been fully used.',
    'discount_user_limit_reached': "You've already used that code.",
    'discount_not_for_this_order': "That code doesn't apply to this order type.",
    'discount_not_for_this_route': "That code doesn't apply to this route.",
    'discount_first_order_only': 'That code is for first orders only.',
    'discount_no_value': "That code doesn't reduce this order.",
  };
  return messages[reason] ?? reason.replaceAll('_', ' ');
}

/// Seat breakdown for a passenger ride.
class OrderSummaryPassengers {
  final int maleCount;
  final int femaleCount;
  final int totalCount;

  const OrderSummaryPassengers({
    required this.maleCount,
    required this.femaleCount,
    required this.totalCount,
  });

  factory OrderSummaryPassengers.fromJson(Map<String, dynamic> json) {
    return OrderSummaryPassengers(
      maleCount: toInt(json['male_count']),
      femaleCount: toInt(json['female_count']),
      totalCount: toInt(json['total_count']),
    );
  }
}

/// Type + size for a gift delivery.
class OrderSummaryGift {
  final String type;
  final String size;

  const OrderSummaryGift({required this.type, required this.size});

  factory OrderSummaryGift.fromJson(Map<String, dynamic> json) {
    return OrderSummaryGift(
      type: (json['type'] ?? '').toString(),
      size: (json['size'] ?? '').toString(),
    );
  }
}
