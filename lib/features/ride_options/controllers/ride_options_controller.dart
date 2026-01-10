import 'package:get/get.dart';
import 'package:shared/common/enums.dart';
import 'package:tajwal_rider/services/ride_services.dart';

class RideOptionsController extends GetxController {
  static final Rx<num> cost = Rx<num>(0);

  void addGender(String type) {
    final ride = RideServices.ride;
    int total = ride.male + ride.female;
    if (total >= 5) return;

    if (type == 'male' && ride.male < 5) {
      ride.male += 1;
    } else if (type == 'female' && ride.female < 5) {
      ride.female += 1;
    }
    calcCosts();
    RideServices.canSubmit();
  }

  void removeGender(String type) {
    final ride = RideServices.ride;

    if (type == 'male' && ride.male > 0) {
      ride.male -= 1;
    } else if (type == 'female' && ride.female > 0) {
      ride.female -= 1;
    }
    calcCosts();
    RideServices.canSubmit();
  }

  num calcCosts() {
    
    final costs = RideServices.costs;
    final ride = RideServices.ride;
    final pickup = ride.pickupLocation?.toLowerCase();
    final dropoff = ride.dropoffLocation?.toLowerCase();

    if (pickup == null || dropoff == null || !costs.containsKey(pickup) || !costs[pickup].containsKey(dropoff)) {
      return 0;
    }

    final routeCosts = costs[pickup][dropoff];
    num totalCost = 0;
    if (ride.deliveryType == DeliveryType.gifts) {
      if (ride.giftType == GiftType.fast) {
        totalCost += routeCosts['gift_fast'];
      } else {
        totalCost += routeCosts['gift_normal'];
      }
      cost.value = totalCost;
      return totalCost;
    }

    if (ride.driverGender == Gender.male) {
      totalCost += routeCosts['driver_male'];
    } else if (ride.driverGender == Gender.female) {
      totalCost += routeCosts['driver_female'];
    }
    
    totalCost += ride.male * routeCosts['male'];
    totalCost += ride.female * routeCosts['female'];
    cost.value = totalCost;
    return totalCost;
  }

  
}
