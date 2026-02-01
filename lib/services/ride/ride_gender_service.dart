part of 'ride_services.dart';

extension RideGenderService on RideService {
  void incrementMale(){
    if (ride.male < 5) {
      ride.male++;
      validate();
    }
  }
  void incrementFemale(){
    if (ride.female < 5) {
      ride.female++;
      validate(); 
    }
  }
  void decrementMale(){
    if (ride.male > 0) {
      ride.male--;
      validate(); 
    }
  }
  void decrementFemale(){
    if (ride.female > 0) {
      ride.female--;
      validate();
    }
  }
}