import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared/shared/enums/index.dart';

class RidePreferences {
  final Rxn<DeliveryType> _deliveryType = Rxn<DeliveryType>(null);
  final Rxn<GiftType> _giftType = Rxn<GiftType>(null);
  
  final Rxn<Gender> _passengersGender = Rxn<Gender>(null);
  final Rxn<Gender> _driverGender = Rxn<Gender>(null);

  final RxnString _pickupLocation = RxnString(null);
  final RxnString _dropoffLocation = RxnString(null);
  final RxDouble _pickupLat = 0.0.obs;
  final RxDouble _pickupLng = 0.0.obs;
  final RxDouble _dropoffLat = 0.0.obs;
  final RxDouble _dropoffLng = 0.0.obs;
  final RxInt _male = 0.obs;
  final RxInt _female = 0.obs;
  final RxNum _cost = RxNum(0);

  num? get cost => _cost.value;
  set cost(num val) => _cost.value = val;


  DeliveryType? get deliveryType => _deliveryType.value;
  set deliveryType(DeliveryType? val) => _deliveryType.value = val;

  GiftType? get giftType => _giftType.value;
  set giftType(GiftType? val) => _giftType.value = val;

  Gender? get passengersGender => _passengersGender.value;
  set passengersGender(Gender? val) => _passengersGender.value = val;

  Gender? get driverGender => _driverGender.value;
  set driverGender(Gender? val) => _driverGender.value = val;


  String? get pickupLocation => _pickupLocation.value;
  set pickupLocation(String? val) => _pickupLocation.value = val;

  String? get dropoffLocation => _dropoffLocation.value;
  set dropoffLocation(String? val) => _dropoffLocation.value = val;

  double get pickupLat => _pickupLat.value;
  set pickupLat(double val) => _pickupLat.value = val;

  double get pickupLng => _pickupLng.value;
  set pickupLng(double val) => _pickupLng.value = val;

  double get dropoffLat => _dropoffLat.value;
  set dropoffLat(double val) => _dropoffLat.value = val;

  double get dropoffLng => _dropoffLng.value;
  set dropoffLng(double val) => _dropoffLng.value = val;

  int get male => _male.value;
  set male(int val) => _male.value = val;

  int get female => _female.value;
  set female(int val) => _female.value = val;

  void reset() {
    deliveryType = null;
    giftType = null;
    passengersGender = null;
    driverGender = null;
    pickupLocation = null;
    dropoffLocation = null;
    pickupLat = 0.0;
    pickupLng = 0.0;
    dropoffLat = 0.0;
    dropoffLng = 0.0;
    male = 0;
    female = 0;
    cost = 0;
  }

  void setPickup(String name, double lat, double lng) {
    pickupLocation = name;
    pickupLat = lat;
    pickupLng = lng;
  }

  void setDropoff(String name, double lat, double lng) {
    dropoffLocation = name;
    dropoffLat = lat;
    dropoffLng = lng;
  }

  void setGenderCounts({ int? maleCount, int? femaleCount }) {
    if (maleCount != null){
      male = maleCount;
    }
    if (femaleCount != null) {
      female = femaleCount;
    }
  }

  void setDriverGender(Gender? gender) {
    driverGender = gender;
  }


  Map<String, dynamic> toJson() => {
    'delivery_type': deliveryType?.name,
    'gift_type': giftType?.name,
    'passengers_gender': passengersGender?.name,
    'driver_gender': driverGender?.name,
    'pickup_location': pickupLocation,
    'dropoff_location': dropoffLocation,
    'pickup_lat': pickupLat,
    'pickup_lng': pickupLng,
    'dropoff_lat': dropoffLat,
    'dropoff_lng': dropoffLng,
    'male': male,
    'female': female,
  };
}
