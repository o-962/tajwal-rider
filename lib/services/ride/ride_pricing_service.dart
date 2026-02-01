part of 'ride_services.dart';

extension RidePricingService on RideService {

  num calcCosts() {
    final routeCosts = _resolveRouteCosts();
    if (routeCosts == null) {
      ride.cost = 0;
      return 0;
    }

    final total = ride.deliveryType == DeliveryType.gifts
        ? _calcGiftCost(routeCosts)
        : _calcRideCost(routeCosts);

    ride.cost = total;
    validate();
    return total;
  }

  Map<String, dynamic>? _resolveRouteCosts() {
    final pickup = ride.pickupLocation?.toLowerCase();
    final dropoff = ride.dropoffLocation?.toLowerCase();

    if (pickup == null || dropoff == null) return null;
    if (!costs.containsKey(pickup)) return null;
    if (!costs[pickup].containsKey(dropoff)) return null;

    return costs[pickup][dropoff];
  }

  num _calcGiftCost(Map<String, dynamic> routeCosts) {
    switch (ride.giftType) {
      case GiftType.fast:
        return routeCosts['gift_fast'] ?? 0;
      case GiftType.normal:
        return routeCosts['gift_normal'] ?? 0;
      default:
        return 0;
    }
  }

  num _calcRideCost(Map<String, dynamic> routeCosts) {
    num total = 0;

    total += _calcDriverCost(routeCosts);
    total += _calcPassengerCost(routeCosts);

    return total;
  }

  num _calcDriverCost(Map<String, dynamic> routeCosts) {
    switch (ride.driverGender) {
      case Gender.male:
        return routeCosts['driver_male'] ?? 0;
      case Gender.female:
        return routeCosts['driver_female'] ?? 0;
      default:
        return 0;
    }
  }

  num _calcPassengerCost(Map<String, dynamic> routeCosts) {
    final maleCost   = routeCosts['male'] ?? 0;
    final femaleCost = routeCosts['female'] ?? 0;

    return (ride.male * maleCost) + (ride.female * femaleCost);
  }
}
