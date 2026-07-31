import 'package:shared/shared/enums/global.dart';
import 'package:shared/shared/fields/interfaces/fields.dart';

class PassengersOrderModel {
  // pickup location
  double pickupLat = 32.341794534443714;
  double pickupLng = 36.193570706623845;

  // dropoff location
  double dropLat = 31.988561609496085;
  double dropLng = 35.943894973424925;

  // passenger details
  int maleCount = 1;
  int femaleCount = 1;

  PreferredGender driverGender = PreferredGender.ANY;

  PreferredGender coPassengerGender = PreferredGender.ANY;

  /// Chosen departure date & time, picked from the slot sheet.
  DateTime? scheduledAt;

  /// Body for both `POST /orders/passengers` and its `/summary` twin — they take
  /// the same fields, so the quote can't be priced off a different payload than
  /// the one that gets submitted.
  toJson({String? discountCode}) {
    return {
      FieldInputType.PICKUP_LAT.value: pickupLat,
      FieldInputType.PICKUP_LNG.value: pickupLng,
      FieldInputType.DROPOFF_LAT.value: dropLat,
      FieldInputType.DROPOFF_LNG.value: dropLng,
      FieldInputType.MALE_COUNT.value: maleCount,
      FieldInputType.FEMALE_COUNT.value: femaleCount,
      FieldInputType.DRIVER_GENDER.value: driverGender.value,
      FieldInputType.CO_PASSENGERS_GENDER.value: coPassengerGender.value,
      FieldInputType.SCHEDULED_AT.value: scheduledAt?.toIso8601String(),
      if (discountCode != null) FieldInputType.DISCOUNT_CODE.value: discountCode,
    };
  }
}