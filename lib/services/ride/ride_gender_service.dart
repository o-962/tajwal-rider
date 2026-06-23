part of 'ride_services.dart';

extension RideGenderService on RideService {
  void incrementMale(){
    if (ride.male < configService.config.maxPassengers) {
      ride.male++;
      validate();
      calcCosts();
    }
  }
  void incrementFemale(){
    if (ride.female < configService.config.maxPassengers) {
      ride.female++;
      validate(); 
    }
    calcCosts();
  }
  void decrementMale(){
    if (ride.male > 0) {
      ride.male--;
      validate(); 
      calcCosts();
    }
  }
  void decrementFemale(){
    if (ride.female > 0) {
      ride.female--;
      validate();
      calcCosts();
    }
  }
}