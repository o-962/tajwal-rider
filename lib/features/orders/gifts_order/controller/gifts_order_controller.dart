import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared/index.dart';
import 'package:tajwal_rider/common/pages.dart';
import 'package:tajwal_rider/features/config/config_controller.dart';
import 'package:tajwal_rider/features/orders/current_order/controller/current_order_controller.dart';
import 'package:tajwal_rider/features/orders/current_order/model/current_order_model.dart';
import 'package:tajwal_rider/features/orders/gifts_order/model/gifts_order_model.dart';
import 'package:tajwal_rider/features/orders/passengers_order/controller/passengers_order_controller.dart'
    show SlotDay, SlotOption;
import 'package:tajwal_rider/features/orders/shared/base/order_location_target.dart';
import 'package:tajwal_rider/features/orders/shared/base/order_summary_target.dart';
import 'package:tajwal_rider/features/splash_screen/dto/splash_screen_dto.dart';

class GiftsOrderController extends GetxController
    implements OrderLocationTarget, OrderSummaryTarget {
  final AppConfigController _appConfig = Get.find<AppConfigController>();
  late final FormController form;

  final Rx<GiftsOrderModel> giftOrder = GiftsOrderModel().obs;
  final CurrentOrderController _currentOrderController = Get.find<CurrentOrderController>();
  GiftsOrderModel get order => giftOrder.value;
  @override
  void onInit() {
    super.onInit();
    form = FormController(allowedFields: giftOrder.value.fields);
    form.add(FormFieldState(type: FieldInputType.PICKUP_LAT, rules: [RequiredRule('pickup_lat_required'.tr)]));
    form.add(FormFieldState(type: FieldInputType.PICKUP_LNG, rules: [RequiredRule('pickup_lng_required'.tr)]));
    form.add(FormFieldState(type: FieldInputType.DROPOFF_LAT, rules: [RequiredRule('dropoff_lat_required'.tr)]));
    form.add(FormFieldState(type: FieldInputType.DROPOFF_LNG, rules: [RequiredRule('dropoff_lng_required'.tr)]));
    form.add(FormFieldState(type: FieldInputType.SCHEDULED_AT, rules: [RequiredRule('scheduled_at_required'.tr)]));
    form.add(
      FormFieldState(type: FieldInputType.TYPE, rules: [RequiredRule('gift_type_required'.tr)], onlyValidate: true),
    );
    form.add(
      FormFieldState(type: FieldInputType.SIZE, rules: [RequiredRule('gift_size_required'.tr)], onlyValidate: true),
    );
    form.add(FormFieldState(type: FieldInputType.RECIPIENT_NAME, onlyValidate: true));
    form.add(FormFieldState(type: FieldInputType.RECIPIENT_PHONE, onlyValidate: true));
    form.add(FormFieldState(type: FieldInputType.IMAGE, onlyValidate: true));
  }

  // ── Route (chosen on the pickup / dropoff screens) ─────────────────────
  final RxnString pickupCity = RxnString();
  final RxnString dropCity = RxnString();

  @override
  String? get pickupCityValue => pickupCity.value;

  final RxString pickupLabel = 'Choose a pickup point'.obs;
  final RxString dropLabel = 'Choose a dropoff point'.obs;

  /// Whether the rider has picked a departure slot yet — gates confirmation.
  final RxBool hasSlot = false.obs;

  // ── Config-driven pricing ──────────────────────────────────────────────
  /// Cost cell for the chosen route, or null until both ends are set.
  RideCostDto? get rideCost => _appConfig.config.costFor(pickupCity.value ?? '', dropCity.value ?? '');

  // ── Step gating ─────────────────────────────────────────────────────────
  bool get hasPickup => pickupCity.value != null;
  bool get hasDrop => dropCity.value != null;

  /// The gift details + slot controls stay disabled until both ends are set.
  bool get routeReady => hasPickup && hasDrop;

  bool get hasImage => order.image != null;
  bool get hasRecipient => order.recipientName.trim().isNotEmpty && order.recipientPhone.trim().isNotEmpty;

  /// Gift price is a flat per-ride cost that depends only on fast vs normal.
  int get total {
    final cost = rideCost;
    if (cost == null) return 0;
    return order.type == GiftType.FAST ? cost.giftFast : cost.giftNormal;
  }

  bool get canConfirm => routeReady && hasSlot.value && hasImage && hasRecipient && rideCost != null;

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
    giftOrder.refresh();
  }

  @override
  void setDrop(String city, double lat, double lng, String label) {
    dropCity.value = city;
    order.dropLat = lat;
    order.dropLng = lng;
    dropLabel.value = label;
    giftOrder.refresh();
  }

  // ── Gift details ──────────────────────────────────────────────────────────
  void setType(GiftType type) {
    order.type = type;
    form.text(FieldInputType.TYPE, type.value);
    giftOrder.refresh();
  }

  void setSize(GiftSize size) {
    order.size = size;
    form.text(FieldInputType.SIZE, size.value);
    giftOrder.refresh();
  }

  void setRecipientName(String value) {
    order.recipientName = value;
    form.text(FieldInputType.RECIPIENT_NAME, value);
    giftOrder.refresh();
  }

  void setRecipientPhone(String value) {
    order.recipientPhone = value;
    form.text(FieldInputType.RECIPIENT_PHONE, value);
    giftOrder.refresh();
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    order.image = File(picked.path);
    form.text(FieldInputType.IMAGE, picked.path);
    giftOrder.refresh();
  }

  // ── Departure slot (mirrors the passenger flow, gift booking window) ───────
  List<SlotDay> get slotDays {
    final cost = rideCost;
    if (cost == null || cost.availableSlots.isEmpty) return const [];

    final now = DateTime.now();
    final windowEnd = now.add(Duration(minutes: (cost.bookingWindowHoursGifts * 60).round()));
    final closeCutoff = now.add(Duration(minutes: (cost.bookingWindowCloseHoursGifts * 60).round()));

    final days = <SlotDay>[];
    var day = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(windowEnd.year, windowEnd.month, windowEnd.day);

    while (!day.isAfter(lastDay)) {
      final slots = <SlotOption>[];
      for (final hour in cost.availableSlots) {
        final dt = DateTime(day.year, day.month, day.day, hour);
        if (dt.isAfter(windowEnd)) continue;
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
    giftOrder.refresh();
  }

  String _dayLabel(DateTime date, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final diff = DateTime(date.year, date.month, date.day).difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return '${date.day}/${date.month}/${date.year}';
  }

  String formatHour(int hour) {
    final period = hour < 12 ? 'AM' : 'PM';
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
  /// its controller quotes THIS flow and not a passenger order opened earlier.
  void openSummary() {
    Get.put<OrderSummaryTarget>(this);
    Get.toNamed(AppRoutes.orderSummary);
  }

  /// Price the draft without creating it. Sent as JSON, not multipart — the
  /// gift photo isn't part of the quote.
  @override
  Future<ApiDto> requestSummary({String? discountCode}) async {
    final apiDto = await ApiServices.dio.post(
      '/orders/gifts/summary',
      data: order.toSummaryJson(discountCode: discountCode),
    );
    return apiDto.parsed;
  }

  @override
  Future<void> submitOrder({String? discountCode}) async {
    final requestForm = await order.toFormData(discountCode: discountCode);
    final apiDto = await ApiServices.dio.post('/orders/gifts', data: requestForm);
    ApiDto parsed = apiDto.parsed;
    if (parsed.errors != null) {
      form.applyServerErrors(parsed.errors!);
    }

    if (parsed.data != null) {
      _currentOrderController.currentOrder.value = CurrentOrderModel.fromJson(parsed.data!);
      _currentOrderController.currentOrder.refresh();
      Get.toNamed(AppRoutes.currentOrder);
    }
  }
}
