import 'package:shared/shared/fields/interfaces/fields.dart';
import 'package:shared/utils/index.dart';

class AppConfigDto {
  bool auth = false;
  String? authId = '';
  String? firstName = 'undefined';
  String? lastName = 'undefined';
  String? email = 'undefined';
  String? phoneNumber = 'undefined';
  String? userName = 'undefined';
  Map<String, dynamic> map = {};
  Map<String, dynamic> translations = {};
  int minPassengers = 1;
  int maxPassengers = 3;
  bool inMaintenance = false;
  bool enableLogin = false;
  bool enableRegistration = false;
  bool enableFemaleDrivers = false;
  bool enableMaleDrivers = false;
  bool enableOrders = false;
  bool enableGifts = false;
  bool enableNormalGifts = false;
  bool enableFastGifts = false;
  bool enableDiscounts = false;

  // Gender-preference feature flags. When either is false the matching ignores
  // that preference entirely, so the rider must not be offered the choice —
  // see PassengersOrderController.showDriverGender / showCoPassengersGender.
  bool enableDriverGender = false;
  bool enableCoPassengersGender = false;
  bool forceLogout = false;
  Map<String, Map<String, RideCostDto>> costs = {};

  AppConfigDto();

  factory AppConfigDto.fromJson(Map<String, dynamic> json) {
    final dto = AppConfigDto();
    dto.auth = json[FieldInputType.AUTH.value];
    dto.authId = json[FieldInputType.AUTH_ID.value];
    dto.firstName = json[FieldInputType.FIRST_NAME.value];
    dto.translations = (json[FieldInputType.TRANSLATIONS.value]);
    dto.lastName = json[FieldInputType.LAST_NAME.value];
    dto.email = json[FieldInputType.EMAIL.value];
    dto.phoneNumber = json[FieldInputType.PHONE_NUMBER.value];
    dto.userName = json[FieldInputType.USER_NAME.value];
    _parseAreas(json[FieldInputType.AREAS.value], dto);
    dto.minPassengers = toInt(json[FieldInputType.MIN_PASSENGERS.value] ?? 1);
    dto.maxPassengers = toInt(json[FieldInputType.MAX_PASSENGERS.value] ?? 3);
    dto.inMaintenance = json[FieldInputType.IN_MAINTENANCE.value] ?? false;
    dto.enableLogin = json[FieldInputType.ENABLE_LOGIN.value] ?? false;
    dto.enableRegistration = json[FieldInputType.ENABLE_REGISTRATION.value] ?? false;
    dto.enableFemaleDrivers = json[FieldInputType.ENABLE_FEMALE_DRIVERS.value] ?? false;
    dto.enableMaleDrivers = json[FieldInputType.ENABLE_MALE_DRIVERS.value] ?? false;
    dto.enableOrders = json[FieldInputType.ENABLE_ORDERS.value] ?? false;
    dto.enableGifts = json[FieldInputType.ENABLE_GIFTS.value] ?? false;
    dto.enableNormalGifts = json[FieldInputType.ENABLE_NORMAL_GIFTS.value] ?? false;
    dto.enableFastGifts = json[FieldInputType.ENABLE_FAST_GIFTS.value] ?? false;
    dto.enableDiscounts = json[FieldInputType.ENABLE_DISCOUNTS.value] ?? false;
    dto.enableDriverGender = json[FieldInputType.ENABLE_DRIVER_GENDER.value] ?? false;
    dto.enableCoPassengersGender =
        json[FieldInputType.ENABLE_CO_PASSENGERS_GENDER.value] ?? false;
    dto.forceLogout = json[FieldInputType.FORCE_LOGOUT.value] ?? false;
    return dto;
  }

  /// Convenience lookup for a single origin -> destination cost cell.
  RideCostDto? costFor(String from, String to) => costs[from]?[to];

  /// Parses the backend `areas` list into the flat lookups the app uses:
  /// `map` (area_key -> polygon points) and `costs` (from -> to -> [RideCostDto]).
  static void _parseAreas(dynamic raw, AppConfigDto dto) {
    final map = <String, dynamic>{};
    final costs = <String, Map<String, RideCostDto>>{};
    if (raw is! List) {
      dto.map = map;
      dto.costs = costs;
      return;
    }
    for (final area in raw) {
      if (area is! Map) continue;
      final areaKey = area['area_key']?.toString();
      if (areaKey == null) continue;

      map[areaKey] = area['polygon'] ?? const [];

      final inner = <String, RideCostDto>{};
      final pricing = area['pricing'];
      if (pricing is List) {
        for (final entry in pricing) {
          if (entry is! Map) continue;
          final to = entry['to_area_key']?.toString();
          if (to == null) continue;
          inner[to] = RideCostDto.fromPricing(Map<String, dynamic>.from(entry));
        }
      }
      costs[areaKey] = inner;
    }
    dto.map = map;
    dto.costs = costs;
  }

  static void toJson(Map<String, dynamic> json, AppConfigDto dto) {
    json[FieldInputType.AUTH.value] = dto.auth;
    json[FieldInputType.AUTH_ID.value] = dto.authId;
    json[FieldInputType.FIRST_NAME.value] = dto.firstName;
    json[FieldInputType.LAST_NAME.value] = dto.lastName;
    json[FieldInputType.EMAIL.value] = dto.email;
    json[FieldInputType.PHONE_NUMBER.value] = dto.phoneNumber;
    json[FieldInputType.USER_NAME.value] = dto.userName;
    json[FieldInputType.MAP.value] = dto.map;
    json[FieldInputType.MIN_PASSENGERS.value] = dto.minPassengers;
    json[FieldInputType.MAX_PASSENGERS.value] = dto.maxPassengers;
    json[FieldInputType.IN_MAINTENANCE.value] = dto.inMaintenance;
    json[FieldInputType.ENABLE_LOGIN.value] = dto.enableLogin;
    json[FieldInputType.ENABLE_REGISTRATION.value] = dto.enableRegistration;
    json[FieldInputType.ENABLE_FEMALE_DRIVERS.value] = dto.enableFemaleDrivers;
    json[FieldInputType.ENABLE_MALE_DRIVERS.value] = dto.enableMaleDrivers;
    json[FieldInputType.ENABLE_ORDERS.value] = dto.enableOrders;
    json[FieldInputType.ENABLE_GIFTS.value] = dto.enableGifts;
    json[FieldInputType.ENABLE_NORMAL_GIFTS.value] = dto.enableNormalGifts;
    json[FieldInputType.ENABLE_FAST_GIFTS.value] = dto.enableFastGifts;
    json[FieldInputType.ENABLE_DISCOUNTS.value] = dto.enableDiscounts;
    json[FieldInputType.ENABLE_DRIVER_GENDER.value] = dto.enableDriverGender;
    json[FieldInputType.ENABLE_CO_PASSENGERS_GENDER.value] = dto.enableCoPassengersGender;
    json[FieldInputType.FORCE_LOGOUT.value] = dto.forceLogout;
  }
}

/// A single origin -> destination ride cost cell (`costs[from][to]`).
///
/// Flattens one backend `pricing[]` entry (`{ cost, booking_setting }`) so the
/// order controllers can read fares and booking windows off a single object.
class RideCostDto {
  int driverMale = 0;
  int driverFemale = 0;
  int male = 0;
  int female = 0;
  int giftFast = 0;
  int giftNormal = 0;
  int fullRide = 0;
  List<int> availableSlots = const [];
  double bookingWindowHoursPassengers = 0;
  double bookingWindowCloseHoursGifts = 0;
  double bookingWindowHoursGifts = 0;
  double bookingWindowCloseHoursPassengers = 0;
  RideCostDto();

  /// Builds from a single `pricing[]` entry: `{ to_area_key, cost, booking_setting }`.
  factory RideCostDto.fromPricing(Map<String, dynamic> json) {
    final cost = json['cost'] is Map
        ? Map<String, dynamic>.from(json['cost'])
        : <String, dynamic>{};
    final booking = json['booking_setting'] is Map
        ? Map<String, dynamic>.from(json['booking_setting'])
        : <String, dynamic>{};

    final dto = RideCostDto();
    dto.driverMale = toInt(cost['driver_male']);
    dto.driverFemale = toInt(cost['driver_female']);
    dto.male = toInt(cost['passenger_male']);
    dto.female = toInt(cost['passenger_female']);
    dto.giftFast = toInt(cost['gift_fast']);
    dto.giftNormal = toInt(cost['gift_normal']);
    dto.fullRide = toInt(cost['full_ride']);

    dto.availableSlots =
        (booking['available_slots'] as List?)?.map(toInt).toList() ?? const [];
    dto.bookingWindowHoursPassengers =
        toDouble(booking['booking_window_hours_passengers']);
    dto.bookingWindowCloseHoursPassengers =
        toDouble(booking['booking_window_close_hours_passengers']);
    dto.bookingWindowHoursGifts = toDouble(booking['booking_window_hours_gifts']);
    dto.bookingWindowCloseHoursGifts =
        toDouble(booking['booking_window_close_hours_gifts']);
    return dto;
  }
}
