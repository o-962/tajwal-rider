import 'package:intl/intl.dart';
import 'package:shared/shared/enums/order_status.dart';
import 'package:shared/utils/parsing.dart';

/// Whether the rider's current order is a passenger ride or a gift delivery.
enum CurrentOrderType {
  passenger('passenger'),
  gift('gift');

  const CurrentOrderType(this.value);
  final String value;
}

/// The rider's single active order, as pushed by the server on `rider:refresh`.
class CurrentOrderModel {
  final String orderId;
  final CurrentOrderType type;
  final OrderStatus status;

  /// Null until a driver has been assigned (the wire sends `''` before that).
  final CurrentOrderDriver? driver;

  final CurrentOrderDetails details;

  const CurrentOrderModel({
    required this.orderId,
    required this.type,
    required this.status,
    required this.driver,
    required this.details,
  });

  bool get isGift => type == CurrentOrderType.gift;
  bool get isPassenger => type == CurrentOrderType.passenger;
  bool get hasDriver => driver != null;

  factory CurrentOrderModel.fromJson(Map<String, dynamic> json) {
    // Two shapes reach this event depending on which backend handler fires:
    //  - flat:   { order: OrderSnapShot, driver: DriverSnapshot | null }
    //  - nested: { order: { order: OrderSnapShot, driver: DriverSnapshot | null } }
    final rawOrder = json['order'];
    var order = rawOrder is Map ? Map<String, dynamic>.from(rawOrder) : const <String, dynamic>{};
    var driverJson = json['driver'];
    if (order['orderId'] == null && order['order'] is Map) {
      driverJson ??= order['driver'];
      order = Map<String, dynamic>.from(order['order']);
    }
    final isPassenger =
        order['isPassengerOrder'] == true || order['isPassengerOrder']?.toString() == 'true';
    return CurrentOrderModel(
      orderId: (order['orderId'] ?? '').toString(),
      type: isPassenger ? CurrentOrderType.passenger : CurrentOrderType.gift,
      status: parseEnum(OrderStatus.values, order['status']?.toString()) ?? OrderStatus.PENDING,
      driver: CurrentOrderDriver.tryFromJson(driverJson),
      details: CurrentOrderDetails.fromJson(order),
    );
  }
}

/// The driver assigned to the order, once one exists. `lat`/`lng` are the live
/// location the backend keeps refreshing on `rider:refresh`.
class CurrentOrderDriver {
  final String name;
  final String phoneNumber;
  final String vehicleName;
  final String vehicleModel;
  final String vehicleColor;
  final String vehiclePlate;
  final String seatCount;
  final double? lat;
  final double? lng;

  const CurrentOrderDriver({
    required this.name,
    required this.phoneNumber,
    required this.vehicleName,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.vehiclePlate,
    required this.seatCount,
    required this.lat,
    required this.lng,
  });

  bool get hasLocation => lat != null && lng != null && !(lat == 0 && lng == 0);

  /// e.g. "White Toyota Corolla" — skips the parts the driver didn't set.
  String get vehicleLabel =>
      [vehicleColor, vehicleName, vehicleModel].where((p) => p.trim().isNotEmpty).join(' ');

  static CurrentOrderDriver? tryFromJson(dynamic raw) {
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    final name = (map['name'] ?? '').toString();
    final phone = (map['phoneNumber'] ?? '').toString();
    if (name.isEmpty && phone.isEmpty) return null;
    return CurrentOrderDriver(
      name: name,
      phoneNumber: phone,
      vehicleName: (map['vehicleName'] ?? '').toString(),
      vehicleModel: (map['vehicleModel'] ?? '').toString(),
      vehicleColor: (map['vehicleColor'] ?? '').toString(),
      vehiclePlate: (map['vehiclePlate'] ?? '').toString(),
      seatCount: (map['seatCount'] ?? '').toString(),
      lat: _toNullableDouble(map['lat']),
      lng: _toNullableDouble(map['lng']),
    );
  }
}

/// The order body — a superset of the passenger and gift snapshots.
///
/// IMPORTANT: pickup/drop-off arrive NESTED on the backend snapshot as
/// `pickUp: { lat, lng, area }` / `dropOff: { lat, lng, area }` — not flat keys.
class CurrentOrderDetails {
  final String orderId;
  final String cost;

  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final String pickupArea;
  final String dropoffArea;

  /// Raw wire values (long JS date strings); use the *Label getters to display.
  final String scheduledAt;

  /// Earliest the order's details/pickup become available. The driver picks the
  /// rider up between [detailsAvailableAt] and [scheduledAt].
  final String detailsAvailableAt;

  // passenger-only
  final int maleCount;
  final int femaleCount;
  final String coPassengersGender;

  // gift-only
  final String giftType;
  final String size;
  final String recipientName;
  final String recipientPhone;
  final String imageUrl;

  const CurrentOrderDetails({
    required this.orderId,
    required this.cost,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.pickupArea,
    required this.dropoffArea,
    required this.scheduledAt,
    required this.detailsAvailableAt,
    required this.maleCount,
    required this.femaleCount,
    required this.coPassengersGender,
    required this.giftType,
    required this.size,
    required this.recipientName,
    required this.recipientPhone,
    required this.imageUrl,
  });

  int get totalPassengers => maleCount + femaleCount;
  bool get hasPickup => pickupLat != 0 && pickupLng != 0;
  bool get hasDropoff => dropoffLat != 0 && dropoffLng != 0;

  String get scheduledLabel => _fmt(scheduledAt);
  String get detailsAvailableLabel => _fmt(detailsAvailableAt);
  bool get hasPickupWindow => detailsAvailableAt.isNotEmpty && scheduledAt.isNotEmpty;

  factory CurrentOrderDetails.fromJson(Map<String, dynamic> json) {
    String s(dynamic v) => (v ?? '').toString();
    Map<String, dynamic> obj(dynamic v) =>
        v is Map ? Map<String, dynamic>.from(v) : const <String, dynamic>{};

    final pickUp = obj(json['pickUp']);
    final dropOff = obj(json['dropOff']);
    final passenger = obj(json['passenger']);
    final gift = obj(json['gift']);

    return CurrentOrderDetails(
      orderId: s(json['orderId']),
      cost: s(json['cost']),
      pickupLat: toDouble(pickUp['lat']),
      pickupLng: toDouble(pickUp['lng']),
      dropoffLat: toDouble(dropOff['lat']),
      dropoffLng: toDouble(dropOff['lng']),
      pickupArea: s(pickUp['area']),
      dropoffArea: s(dropOff['area']),
      scheduledAt: s(json['scheduledAt']),
      detailsAvailableAt: s(json['detailsAvailableAt']),
      maleCount: toInt(passenger['maleCount']),
      femaleCount: toInt(passenger['femaleCount']),
      coPassengersGender: s(passenger['coPassengersGender']),
      giftType: s(gift['giftType']),
      size: s(gift['size']),
      recipientName: s(gift['recipientName']),
      recipientPhone: s(gift['recipientPhone']),
      imageUrl: s(gift['imageUrl']),
    );
  }

  /// Formats a wire date string (ISO or a JS `Date.toString()`) for display.
  static String _fmt(String raw) {
    if (raw.isEmpty) return '—';
    final dt = DateTime.tryParse(raw);
    if (dt != null) return DateFormat('EEE, MMM d · h:mm a').format(dt.toLocal());
    // JS Date, e.g. "Sat Jul 04 2026 20:00:00 GMT+0300 (…)" — trim the tz tail.
    final gmt = raw.indexOf(' GMT');
    return gmt > 0 ? raw.substring(0, gmt) : raw;
  }
}

double? _toNullableDouble(dynamic v) {
  final s = (v ?? '').toString();
  if (s.isEmpty) return null;
  return double.tryParse(s);
}
