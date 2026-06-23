// lib/common/navigation/navigation_service.dart
import 'package:get/get.dart';
import 'package:shared/core/routing/route.dart';
import 'package:tajwal_rider/common/pages.dart';

/// Centralized navigation — all route changes go through here.
class NavigationService extends GetxService {
  void toWelcome() => Get.offAllNamed(AppRoutes.welcome);

  void toRegister() => Get.toNamed(AppRoutes.register);

  void toPickup() => Get.toNamed(AppRoutes.pickup);

  void toDropoff() => Get.toNamed(AppRoutes.dropoff);

  void toOptions() => Get.toNamed(AppRoutes.options);

  void toReceipt() => Get.toNamed(AppRoutes.receipt);

  void toPending() => Get.toNamed(AppRoutes.pending);

  void toRideMap() {
    if (Get.currentRoute != AppRoutes.rideMap) {
      Get.offAllNamed(AppRoutes.rideMap);
    }
  }

  void toRate() => Get.offAllNamed(AppRoutes.rate);

  void toSettings() => Get.toNamed(AppRoutes.settings);

  void toHistory() => Get.toNamed(AppRoutes.history);

  void toTripDetails(dynamic order) =>
      Get.toNamed(AppRoutes.tripDetails, arguments: order);

  void toSplash() => Get.offAllNamed(AppRoutes.splashScreen);

  void toError() => Get.offAllNamed(CommonRoutes.error);

  void offAllTo(String route) => Get.offAllNamed(route);

  void toChangePassword() => Get.toNamed(CommonRoutes.changePassword);

  void toChangePhone() => Get.toNamed(CommonRoutes.changePhoneNumber);

  void toRemoveAccount() => Get.toNamed(CommonRoutes.removeAccount);

  void toRegisterOtpVerify(String identifier) =>
      Get.offAllNamed(CommonRoutes.registerOtpVerify, arguments: identifier);
}
