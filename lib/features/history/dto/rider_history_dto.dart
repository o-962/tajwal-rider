import 'package:intl/intl.dart';
import 'package:shared/utils/parsing.dart';
import 'package:shared/utils/backend_date.dart';

/// Passenger seats on a past order.
class RiderHistoryPassengers {
  final int maleCount;
  final int femaleCount;
  final int totalCount;

  const RiderHistoryPassengers({
    required this.maleCount,
    required this.femaleCount,
    required this.totalCount,
  });

  static RiderHistoryPassengers fromJson(Map<String, dynamic> json) {
    return RiderHistoryPassengers(
      maleCount: toInt(json['male_count']),
      femaleCount: toInt(json['female_count']),
      totalCount: toInt(json['total_count']),
    );
  }
}

/// Gift details on a past order.
class RiderHistoryGift {
  final String type;
  final String size;
  final String recipientName;
  final String recipientPhone;
  final String imageUrl;

  const RiderHistoryGift({
    required this.type,
    required this.size,
    required this.recipientName,
    required this.recipientPhone,
    required this.imageUrl,
  });

  static RiderHistoryGift fromJson(Map<String, dynamic> json) {
    return RiderHistoryGift(
      type: (json['type'] ?? '').toString(),
      size: (json['size'] ?? '').toString(),
      recipientName: (json['recipient_name'] ?? '').toString(),
      recipientPhone: (json['recipient_phone'] ?? '').toString(),
      imageUrl: (json['image_url'] ?? '').toString(),
    );
  }
}

/// One past order the rider placed, as returned by `GET /orders/rider/history`.
class RiderHistoryOrderDto {
  final String orderId;
  final String orderType;
  final String status;

  final String pickupArea;
  final String dropoffArea;

  /// Full fare before any discount.
  final double cost;

  /// What the rider actually owed after a discount (equals [cost] if none).
  final double paid;
  final double discountAmount;
  final String? discountCode;
  final String currency;

  final String scheduledAt;
  final String createdAt;

  final RiderHistoryPassengers? passengers;
  final RiderHistoryGift? gift;

  /// The driver who took it, once assigned.
  final String? driverName;

  const RiderHistoryOrderDto({
    required this.orderId,
    required this.orderType,
    required this.status,
    required this.pickupArea,
    required this.dropoffArea,
    required this.cost,
    required this.paid,
    required this.discountAmount,
    required this.discountCode,
    required this.currency,
    required this.scheduledAt,
    required this.createdAt,
    required this.passengers,
    required this.gift,
    required this.driverName,
  });

  bool get isGift => orderType == 'gift';
  bool get hasDiscount => discountAmount > 0;
  bool get hasDriver => (driverName ?? '').trim().isNotEmpty;

  String get routeLabel => '${_area(pickupArea)} → ${_area(dropoffArea)}';
  String get statusLabel => _statusLabel(status);
  String get scheduledLabel => _fmt(scheduledAt);
  String get createdLabel => _fmt(createdAt);
  String price(double value) => '${_trim(value)} $currency';

  static RiderHistoryOrderDto fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> obj(dynamic v) =>
        v is Map ? Map<String, dynamic>.from(v) : const <String, dynamic>{};

    final passengers = json['passengers'];
    final gift = json['gift'];
    final driver = json['driver'];
    final code = json['discount_code'];

    return RiderHistoryOrderDto(
      orderId: (json['order_id'] ?? '').toString(),
      orderType: (json['order_type'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      pickupArea: (json['pickup_area'] ?? '').toString(),
      dropoffArea: (json['dropoff_area'] ?? '').toString(),
      cost: toDouble(json['cost']),
      paid: toDouble(json['paid']),
      discountAmount: toDouble(json['discount_amount']),
      discountCode: code == null || code.toString().isEmpty ? null : code.toString(),
      currency: (json['currency'] ?? 'JOD').toString(),
      scheduledAt: (json['scheduled_at'] ?? '').toString(),
      createdAt: (json['created_at'] ?? '').toString(),
      passengers: passengers is Map ? RiderHistoryPassengers.fromJson(obj(passengers)) : null,
      gift: gift is Map ? RiderHistoryGift.fromJson(obj(gift)) : null,
      driverName: driver is Map ? (driver['name'] ?? '').toString() : null,
    );
  }

  static String _area(String raw) =>
      raw.isEmpty ? '—' : raw[0].toUpperCase() + raw.substring(1);

  static String _statusLabel(String raw) {
    if (raw.isEmpty) return '—';
    final spaced = raw.replaceAll('_', ' ');
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  static String _trim(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  /// Formats a wire date (ISO or a JS `Date.toString()`) for display.
  static String _fmt(String raw) => formatBackendDate(raw);
}
