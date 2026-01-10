import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared/common/enums.dart';
import 'package:shared/models/ride_model.dart';

class RideServices extends GetxService {
  static RideServices get to => Get.find<RideServices>();
  static RxBool canSubmitState = false.obs;
  static RxMap costs = {}.obs;
  static Map<String, List<LatLng>> polygons = {};

  static RidePreferences ride = RidePreferences();

  static void setPickupLocation(String name, double lat, double lng) {
    ride.pickupLocation = name;
    ride.pickupLat = lat;
    ride.pickupLng = lng;
  }

  static void setDropoffLocation(String name, double lat, double lng) {
    ride.dropoffLocation = name;
    ride.dropoffLat = lat;
    ride.dropoffLng = lng;
  }

  static void canSubmit({bool message = true}) {
    
    if (ride.pickupLocation == null || ride.dropoffLocation == null) {
      canSubmitState.value = false;
    }
    if (ride.deliveryType == DeliveryType.gifts) {
      if (ride.giftType == null) {
        canSubmitState.value = false;
      } else {
        canSubmitState.value = true;
      }
    }

    if (ride.deliveryType == DeliveryType.taxi) {
      if (ride.female == 0 && ride.male == 0) {
        canSubmitState.value = false;
      }
      if (ride.male != 0) {
        canSubmitState.value = true;
      }
      if (ride.male == 0 && ride.female != 0) {
        if (ride.driverGender != null && ride.passengersGender != null) {
          canSubmitState.value = true;
        } else {
          canSubmitState.value = false;
        }
      }
    }
  }
}
