part of 'ride_services.dart';

extension RideValidationService on RideService {
  bool get hasPickup  => ride.pickupLocation != null;
  bool get hasDropoff => ride.dropoffLocation != null;

  void validate() {
    canSubmit.value = _canSubmit();
  }

  bool _canSubmit() {
    if (!hasPickup || !hasDropoff) return false;

    if (ride.deliveryType == DeliveryType.gifts) {
      return _validateGift();
    }

    if (ride.deliveryType == DeliveryType.taxi) {
      return _validTaxi();
    }

    return false;
  }

  bool _validTaxi() {
    if (ride.male > 0) return true;

    if (ride.female > 0) {
      return ride.driverGender != null && ride.passengersGender != null;
    }

    return false;
  }

  bool _validateGift() {
    return ride.giftType != null;
  }
}
