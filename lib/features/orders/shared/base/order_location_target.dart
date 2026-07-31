/// Implemented by any order controller that the shared pickup / dropoff screens
/// write the chosen coordinates back into. Decouples those screens from a
/// specific order flow (passengers, gifts, …) — each flow registers itself under
/// this type in its binding, and the pickup / dropoff controllers resolve it.
abstract class OrderLocationTarget {
  void setPickup(String city, double lat, double lng, String label);
  void setDrop(String city, double lat, double lng, String label);

  /// The currently chosen pickup city (used by dropoff to exclude that area).
  String? get pickupCityValue;
}
