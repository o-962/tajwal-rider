import 'package:get/get.dart';
import 'package:shared/core/network/api_client.dart';
import 'package:shared/models/api_dto.dart';
import 'package:shared/models/message_dto.dart';
import 'package:shared/shared/services/notification_service.dart';
import 'package:shared/shared/enums/global.dart';
import 'package:tajwal_rider/common/pages.dart';
import 'package:tajwal_rider/features/config/config_controller.dart';
import 'package:tajwal_rider/features/orders/current_order/controller/current_order_controller.dart';
import 'package:tajwal_rider/features/orders/current_order/model/current_order_model.dart';
import 'package:tajwal_rider/features/orders/passengers_order/model/passengers_order_model.dart';
import 'package:tajwal_rider/features/orders/shared/base/order_location_target.dart';
import 'package:tajwal_rider/features/orders/shared/base/order_summary_target.dart';
import 'package:tajwal_rider/features/splash_screen/dto/splash_screen_dto.dart';
import 'package:tajwal_rider/utils/route_options.dart';

class PassengersOrderController extends GetxController
    implements OrderLocationTarget, OrderSummaryTarget {
  final AppConfigController _appConfig = Get.find<AppConfigController>();

  Rx<PassengersOrderModel> passengersOrder = PassengersOrderModel().obs;
  PassengersOrderModel get order => passengersOrder.value;
  CurrentOrderController get _currentOrderController => Get.find<CurrentOrderController>();
  // ── Route (chosen on the pickup / dropoff screens) ─────────────────────
  /// Cities the rider picked; they key the cost cell and feed the row labels.
  final RxnString pickupCity = RxnString();
  final RxnString dropCity = RxnString();

  @override
  String? get pickupCityValue => pickupCity.value;

  @override
  String? get dropCityValue => dropCity.value;

  final RxString pickupLabel = 'choose_pickup_point'.tr.obs;
  final RxString dropLabel = 'choose_dropoff_point'.tr.obs;

  /// Keyed off the city, never the coordinates: the model seeds lat/lng with
  /// real defaults, so a non-null coordinate proves nothing about whether the
  /// rider actually picked anything.
  @override
  LocationSelection? get pickupSelection => pickupCity.value == null
      ? null
      : LocationSelection(
          city: pickupCity.value!,
          lat: order.pickupLat,
          lng: order.pickupLng,
          label: pickupLabel.value,
        );

  @override
  LocationSelection? get dropSelection => dropCity.value == null
      ? null
      : LocationSelection(
          city: dropCity.value!,
          lat: order.dropLat,
          lng: order.dropLng,
          label: dropLabel.value,
        );

  /// Whether the rider has picked a departure slot yet — gates confirmation.
  final RxBool hasSlot = false.obs;

  /// The driver gender the rider asked for. Only ANY and the passengers' own
  /// gender are ever selectable — see [sameGenderOption].
  final Rx<PreferredGender> driverGender = PreferredGender.ANY.obs;

  /// The gender the rider wants the riders SHARING the car to be. Same
  /// selectable set as [driverGender].
  final Rx<PreferredGender> coPassengersGender = PreferredGender.ANY.obs;

  // ── Config-driven pricing & capacity ───────────────────────────────────
  /// Cost cell for the chosen route, or null until both ends are set.
  RideCostDto? get rideCost =>
      _appConfig.config.costFor(pickupCity.value ?? '', dropCity.value ?? '');

  /// Vehicle seat capacity comes from the app config.
  int get maxSeats => _appConfig.config.maxPassengers;

  // ── Step gating ─────────────────────────────────────────────────────────
  /// Pickup must be chosen before the dropoff row unlocks.
  bool get hasPickup => pickupCity.value != null;

  /// Dropoff must be chosen before the rest of the form unlocks.
  bool get hasDrop => dropCity.value != null;

  /// The seats, driver and slot controls stay disabled until both ends are set.
  bool get routeReady => hasPickup && hasDrop;

  int get maleCost => rideCost?.male ?? 0;
  int get femaleCost => rideCost?.female ?? 0;

  int get totalSeats => order.maleCount + order.femaleCount;

  /// A full order (every seat taken) is billed at the flat full-ride price.
  bool get isFullRide => maxSeats > 0 && totalSeats == maxSeats;

  int get total {
    final cost = rideCost;
    if (cost == null) return 0;
    if (isFullRide && cost.fullRide > 0) return cost.fullRide;
    return order.maleCount * cost.male + order.femaleCount * cost.female;
  }

  /// Mixed orders (both male & female seats) can only ride in any car.
  bool get isMixed => order.maleCount > 0 && order.femaleCount > 0;

  /// The one non-ANY driver gender this seat mix allows: an all-male order may
  /// ask for a male driver, an all-female order a female driver. Mixed seats —
  /// and an empty car — have no same-gender answer, so nothing but "Any" is
  /// offerable and this is null.
  PreferredGender? get sameGenderOption {
    if (isMixed) return null;
    if (order.maleCount > 0) return PreferredGender.MALE;
    if (order.femaleCount > 0) return PreferredGender.FEMALE;
    return null;
  }

  /// Whether each preference is offered at all. Both are platform feature flags:
  /// when one is off the backend ignores that preference when matching, so the
  /// rider must not be shown a choice that would silently do nothing.
  bool get showDriverGender => _appConfig.config.enableDriverGender;

  bool get showCoPassengersGender => _appConfig.config.enableCoPassengersGender;

  /// The values actually sent to the server. Re-clamped here as well as on every
  /// seat edit, so a preference can never outlive the seat mix that justified it.
  PreferredGender get resolvedDriverGender =>
      _clamped(driverGender.value, enabled: showDriverGender);

  PreferredGender get resolvedCoPassengersGender =>
      _clamped(coPassengersGender.value, enabled: showCoPassengersGender);

  /// A disabled feature always resolves to ANY. Otherwise ANY passes through and
  /// anything else survives only while it still matches the seat mix.
  PreferredGender _clamped(PreferredGender selection, {required bool enabled}) {
    if (!enabled || selection == PreferredGender.ANY) return PreferredGender.ANY;
    return selection == sameGenderOption ? selection : PreferredGender.ANY;
  }

  bool get canConfirm => hasSlot.value && totalSeats > 0 && rideCost != null;

  // ── Route selection (from the pickup / dropoff screens) ─────────────────
  /// Claim the shared [OrderLocationTarget] slot for THIS flow before opening
  /// the shared pickup / dropoff screens, so their writes land here and not in
  /// another order flow that ran earlier.
  void openPickup() {
    Get.put<OrderLocationTarget>(this);
    Get.toNamed(AppRoutes.pickup);
  }

  void openDropoff() {
    Get.put<OrderLocationTarget>(this);
    Get.toNamed(AppRoutes.dropoff);
  }

  @override
  void setPickup(String city, double lat, double lng, String label) {
    pickupCity.value = city;
    order.pickupLat = lat;
    order.pickupLng = lng;
    pickupLabel.value = label;
    _clearDropIfUnreachable();
    _resetSlot();
    passengersOrder.refresh();
  }

  /// Reverse the trip in place.
  ///
  /// Exists because the same-area exclusion is symmetric: pickup hides the
  /// dropoff area and dropoff hides the pickup area, so a rider on Amman→Irbid
  /// is offered neither area they need to build Irbid→Amman and would have to
  /// abandon the order. A return trip is an ordinary thing to want.
  ///
  /// Assigns the fields directly rather than calling [setPickup]/[setDrop]:
  /// those run [_clearDropIfUnreachable], which would fire against the
  /// half-swapped state and wipe the leg being moved.
  ///
  /// Gated on the REVERSE pair being priced — Amman→Irbid existing does not imply
  /// Irbid→Amman does, and an unpriced pair is rejected at submit.
  void swapRoute() {
    if (!routeReady) return;

    if (!RouteOptions.canTravel(dropCity.value!, pickupCity.value!)) {
      NotificationService.message(
        MessageDto(
          toastHead: 'location_invalid'.tr,
          toastType: ToastTypes.ALERT,
          toastBody: 'route_reverse_unavailable'.tr,
        ),
      );
      return;
    }

    final city = pickupCity.value;
    final lat = order.pickupLat;
    final lng = order.pickupLng;
    final label = pickupLabel.value;

    pickupCity.value = dropCity.value;
    order.pickupLat = order.dropLat;
    order.pickupLng = order.dropLng;
    pickupLabel.value = dropLabel.value;

    dropCity.value = city;
    order.dropLat = lat;
    order.dropLng = lng;
    dropLabel.value = label;

    // The reversed route has its own available_slots and booking windows.
    _resetSlot();
    passengersOrder.refresh();
  }

  /// Drop a dropoff that the NEW pickup can't reach.
  ///
  /// The dropoff map only ever offers reachable areas, but it filters against
  /// the pickup that was set when it opened. Going back and changing the pickup
  /// leaves the old dropoff in place — an unpriced pair that looks selected,
  /// prices as null, and is rejected at submit with
  /// `INVALID_PICKUP_OR_DROPOFF_LOCATION`. Clearing it forces a re-pick from the
  /// correctly filtered map, and `routeReady` re-locks the rest of the form.
  void _clearDropIfUnreachable() {
    final drop = dropCity.value;
    if (drop == null || RouteOptions.canTravel(pickupCity.value ?? '', drop)) return;
    dropCity.value = null;
    dropLabel.value = 'choose_dropoff_point'.tr;
  }

  @override
  void setDrop(String city, double lat, double lng, String label) {
    dropCity.value = city;
    order.dropLat = lat;
    order.dropLng = lng;
    dropLabel.value = label;
    _resetSlot();
    passengersOrder.refresh();
  }

  /// Force the departure slot to be re-picked after any route change.
  ///
  /// Slots are route-specific — [slotDays] is built from
  /// `RideCostDto.availableSlots` and the route's booking windows — but
  /// [canConfirm] only checks the `hasSlot` flag, never whether `scheduledAt` is
  /// still an offered hour. Leaving it set lets an order submit at an hour the
  /// new route doesn't run. The slot controls are gated behind `routeReady`
  /// anyway, so a slot can only ever exist after both legs are set.
  void _resetSlot() => hasSlot.value = false;

  // ── Seats ───────────────────────────────────────────────────────────────
  void setMaleCount(int value) {
    order.maleCount = value < 0 ? 0 : value;
    _clampGenderPreferences();
    passengersOrder.refresh();
  }

  void setFemaleCount(int value) {
    order.femaleCount = value < 0 ? 0 : value;
    _clampGenderPreferences();
    passengersOrder.refresh();
  }

  // ── Gender preferences ──────────────────────────────────────────────────
  /// Both setters ignore a gender the current seat mix doesn't allow — the
  /// selectors already disable those options, so this only guards a stale tap.
  void setDriverGender(PreferredGender value) {
    if (value != PreferredGender.ANY && value != sameGenderOption) return;
    driverGender.value = value;
  }

  void setCoPassengersGender(PreferredGender value) {
    if (value != PreferredGender.ANY && value != sameGenderOption) return;
    coPassengersGender.value = value;
  }

  /// A seat edit can invalidate a pick — adding a female seat to an all-male
  /// order kills "Male". Fall back to "Any" rather than leaving a dead choice
  /// highlighted and silently sending it.
  void _clampGenderPreferences() {
    driverGender.value = resolvedDriverGender;
    coPassengersGender.value = resolvedCoPassengersGender;
  }

  // ── Departure slot ──────────────────────────────────────────────────────
  /// The route's bookable departures, grouped by day (Today / Tomorrow / date).
  ///
  /// The booking window opens now and runs [bookingWindowHours] ahead, so when
  /// that exceeds 24h later days appear too. A slot is disabled when it is in
  /// the past or within [bookingWindowCloseHours] of departure (orders close
  /// that long before the trip).
  List<SlotDay> get slotDays {
    final cost = rideCost;
    if (cost == null || cost.availableSlots.isEmpty) return const [];

    final now = DateTime.now();
    final windowEnd =
        now.add(Duration(minutes: (cost.bookingWindowHoursPassengers * 60).round()));
    final closeCutoff =
        now.add(Duration(minutes: (cost.bookingWindowCloseHoursPassengers * 60).round()));

    final days = <SlotDay>[];
    var day = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(windowEnd.year, windowEnd.month, windowEnd.day);

    while (!day.isAfter(lastDay)) {
      final slots = <SlotOption>[];
      for (final hour in cost.availableSlots) {
        final dt = DateTime(day.year, day.month, day.day, hour);
        if (dt.isAfter(windowEnd)) continue; // window hasn't opened this far out
        final enabled = !dt.isBefore(closeCutoff);
        slots.add(SlotOption(dateTime: dt, enabled: enabled));
      }
      if (slots.isNotEmpty) days.add(SlotDay(label: _dayLabel(day, now), slots: slots));
      day = day.add(const Duration(days: 1));
    }
    return days;
  }

  void selectSlot(DateTime dateTime) {
    order.scheduledAt = dateTime;
    hasSlot.value = true;
    passengersOrder.refresh();
  }

  /// "Today" / "Tomorrow" / "29/7/2026" for the day [date] falls on.
  String _dayLabel(DateTime date, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final diff = DateTime(date.year, date.month, date.day).difference(today).inDays;
    if (diff == 0) return 'today'.tr;
    if (diff == 1) return 'tomorrow'.tr;
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Formats a 24h hour into a 12h label, e.g. 3 -> "3:00 AM", 21 -> "9:00 PM".
  String formatHour(int hour) {
    final period = hour < 12 ? 'am'.tr : 'pm'.tr;
    final display = hour % 12 == 0 ? 12 : hour % 12;
    return '$display:00 $period';
  }

  String get slotLabel {
    final dt = order.scheduledAt;
    if (dt == null) return '';
    return '${_dayLabel(dt, DateTime.now())} · ${formatHour(dt.hour)}';
  }

  // ── Confirmation step ───────────────────────────────────────────────────
  /// Claim the shared [OrderSummaryTarget] slot before opening the summary, so
  /// its controller quotes THIS flow and not a gift order opened earlier.
  void openSummary() {
    _applyGenderPreferences();
    Get.put<OrderSummaryTarget>(this);
    Get.toNamed(AppRoutes.orderSummary);
  }

  /// Price the draft without creating it — the summary page renders whatever
  /// comes back, so the rider confirms the server's number, not a local guess.
  @override
  Future<ApiDto> requestSummary({String? discountCode}) async {
    final response = await ApiServices.dio.post(
      '/orders/passengers/summary',
      data: order.toJson(discountCode: discountCode),
    );
    return response.parsed;
  }

  /// Writes both preferences onto the model in their clamped form. Called before
  /// the quote and again before the real submit, so the order that gets priced
  /// and the order that gets created carry identical values.
  void _applyGenderPreferences() {
    order.driverGender = resolvedDriverGender;
    order.coPassengerGender = resolvedCoPassengersGender;
  }

  @override
  Future<void> submitOrder({String? discountCode}) async {
    _applyGenderPreferences();

    final response = await ApiServices.dio.post(
      '/orders/passengers',
      data: order.toJson(discountCode: discountCode),
    );
    ApiDto apiResponse = response.parsed;
    if (apiResponse.data != null) {
      _currentOrderController.currentOrder.value = CurrentOrderModel.fromJson(apiResponse.data!);
      _currentOrderController.currentOrder.refresh();
      Get.toNamed(AppRoutes.currentOrder);
    }
  }
}

/// A single bookable departure (a specific date & time) in the slot sheet.
class SlotOption {
  const SlotOption({required this.dateTime, required this.enabled});

  final DateTime dateTime;
  final bool enabled;
}

/// One day's worth of [SlotOption]s, under a "Today / Tomorrow / date" header.
class SlotDay {
  const SlotDay({required this.label, required this.slots});

  final String label;
  final List<SlotOption> slots;
}
