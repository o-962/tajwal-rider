import 'package:get/get.dart';
import 'package:tajwal_rider/features/config/config_controller.dart';
import 'package:tajwal_rider/features/splash_screen/dto/splash_screen_dto.dart';

/// Which areas may be an origin, and which may be a destination for a given
/// origin — derived from the fare table (`AppConfigDto.costs[from][to]`).
///
/// **The single source of truth for route availability.** The pickup map, the
/// dropoff map, and the guard that drops a now-unreachable dropoff all read from
/// here, so the UI can never offer a pair the fare table has no cell for.
///
/// Why it matters: an area existing is not the same as an area being *reachable*.
/// `costs` only holds the origin→destination pairs an admin actually priced, and
/// the backend treats a missing cell as fatal — `findRoutePricing` returns null
/// and `PassengersService` rejects the order with
/// `INVALID_PICKUP_OR_DROPOFF_LOCATION`. Every unpriced pair the map lets a rider
/// tap is therefore a guaranteed failure several screens later, after they have
/// already picked seats and a departure slot.
class RouteOptions {
  const RouteOptions._();

  static Map<String, Map<String, RideCostDto>> get _costs =>
      Get.find<AppConfigController>().config.costs;

  /// True when [city] has at least one priced outgoing route, i.e. it is a
  /// usable pickup. An area with no routes out is a dead end: the rider would
  /// choose it and then find an empty dropoff map.
  static bool canDepartFrom(String city) =>
      city.isNotEmpty && (_costs[city]?.isNotEmpty ?? false);

  /// True when a trip [from] → [to] is priced.
  ///
  /// Same-area trips are excluded: the product treats pickup and dropoff as
  /// different areas, and this is what used to be the dropoff screen's separate
  /// "hide the pickup city" rule.
  static bool canTravel(String from, String to) =>
      from.isNotEmpty && to.isNotEmpty && from != to && _costs[from]?[to] != null;
}
