/// A point the rider already chose for one leg of the trip.
///
/// Carries the label as well as the coordinates so re-opening the pickup /
/// dropoff screen can restore the search box exactly as it was left, not just
/// drop a pin back on the map.
class LocationSelection {
  const LocationSelection({
    required this.city,
    required this.lat,
    required this.lng,
    required this.label,
  });

  final String city;
  final double lat;
  final double lng;
  final String label;
}

/// Implemented by any order controller that the shared pickup / dropoff screens
/// write the chosen coordinates back into. Decouples those screens from a
/// specific order flow (passengers, gifts, …) — each flow registers itself under
/// this type in its binding, and the pickup / dropoff controllers resolve it.
abstract class OrderLocationTarget {
  void setPickup(String city, double lat, double lng, String label);
  void setDrop(String city, double lat, double lng, String label);

  /// The chosen pickup city; dropoff hides it and won't route to it.
  String? get pickupCityValue;

  /// The chosen dropoff city; pickup hides it, so the two legs can never be the
  /// same area no matter which one the rider picks first.
  String? get dropCityValue;

  /// The existing selections, or null when that leg hasn't been chosen.
  ///
  /// These are what let a screen re-open showing the rider's pin instead of a
  /// blank map. The order models default their lat/lng to real coordinates, so
  /// "has been chosen" is keyed off the city being non-null — never off the
  /// coordinates, which are never null.
  LocationSelection? get pickupSelection;
  LocationSelection? get dropSelection;
}
