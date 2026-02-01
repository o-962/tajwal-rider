part of 'ride_services.dart';

extension LocationRideService on RideService {
  void setPickup(String name, double lat, double lng) {
    ride.setPickup(name, lat, lng);
    validate();
  }
  void setDropoff(String name, double lat, double lng) {
    ride.setDropoff(name, lat, lng);
    validate();
  }
}