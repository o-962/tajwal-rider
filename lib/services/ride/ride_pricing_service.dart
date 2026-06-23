part of 'ride_services.dart';

extension RidePricingService on RideService {

  num calcCosts() {
    final routeCosts = _resolveRouteCosts();
    if (routeCosts == null) {
      ride.cost = 0;
      return 0;
    }
    final total = ride.deliveryType == DeliveryType.GIFTS ? _calcGiftCost(routeCosts) : _calcRideCost(routeCosts);
    ride.cost = total;
    validate();
    return total;
  }

  RideCost? _resolveRouteCosts() {
    final pickup = ride.pickupLocation?.toLowerCase();
    final dropoff = ride.dropoffLocation?.toLowerCase();
    if (pickup == null || dropoff == null) return null;
    if (!costs.containsKey(pickup)) return null;
    if (!costs[pickup].containsKey(dropoff)) return null;
    return costs[pickup][dropoff];
  }

  num _calcGiftCost(RideCost routeCosts) {
    switch (ride.giftType) {
      case GiftType.FAST:
        return routeCosts.giftFast;
      case GiftType.NORMAL:
        return routeCosts.giftNormal;
      default:
        return 0;
    }
  }

  num _calcRideCost(RideCost routeCosts) {
    num total = 0;
    total += _calcDriverCost(routeCosts);
    total += _calcPassengerCost(routeCosts);

    return total;
  }

  num _calcDriverCost(RideCost routeCosts) {
    switch (ride.driverGender) {
      case Gender.MALE:
        return routeCosts.driverMale;
      case Gender.FEMALE:
        return routeCosts.driverFemale;
      default:
        return 0;
    }
  }

  num _calcPassengerCost(RideCost routeCosts) {
    final maleCost   = routeCosts.male;
    final femaleCost = routeCosts.female;
    if (ride.male + ride.female == (configService.config.maxPassengers)) {
      return routeCosts.fullRide;
    }
    return (ride.male * maleCost) + (ride.female * femaleCost);
  }
}
