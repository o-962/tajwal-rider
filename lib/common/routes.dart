import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared/features/change-password/change_password_screen.dart';
import 'package:shared/features/update-account/update_account_screen.dart';
import 'package:tajwal_rider/features/auth/screens/forget_password_screen.dart';
import 'package:tajwal_rider/features/auth/screens/login_screen.dart';
import 'package:tajwal_rider/features/auth/screens/register_screen.dart';
import 'package:tajwal_rider/features/core/error.dart';
import 'package:tajwal_rider/features/core/welcome.dart';
import 'package:tajwal_rider/features/main-settings/settings_screen.dart';
import 'package:tajwal_rider/features/pending/pending_screen.dart';
import 'package:tajwal_rider/features/rate/rate_screen.dart';
import 'package:tajwal_rider/features/ride_location/dropoff/dropoff_screen.dart';
import 'package:tajwal_rider/features/ride_location/pickup/pickup_screen.dart';
import 'package:tajwal_rider/features/ride_map/ride_map_screen.dart';
import 'package:tajwal_rider/features/ride_options/options_screen.dart';
import 'package:tajwal_rider/features/ride_receipt/receipt_screen.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String pickup = '/pickup';
  static const String dropoff = '/dropoff';
  static const String error = '/error';
  static const String forgetPassword = '/forget-password';
  static const String options = '/options';
  static const String receipt = '/receipt';
  static const String rate = '/rate';
  static const String pending = '/pending';
  // ignore: constant_identifier_names
  static const String ride_map = '/ride-map';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String updateAccount = '/update-account';
}

List<GetPage> routes = [
  GetPage(
    name: AppRoutes.welcome,
    page: () => const WelcomeScreen(),
  ),
  GetPage(
    name: AppRoutes.login,
    page: () => LoginScreen(),
  ),
  GetPage(
    name: AppRoutes.register,
    page: () => RegisterScreen(),
  ),
  GetPage(
    name: AppRoutes.pickup,
    page: ()=> PickupScreen()
  ),
  GetPage(
    name: AppRoutes.error,
    page: ()=> ErrorScreen()
  ),
  GetPage(
    name: AppRoutes.forgetPassword,
    page: ()=> ForgetPasswordScreen()
  ),
  GetPage(
    name: AppRoutes.dropoff,
    page: ()=> DropoffScreen()
  ),
  GetPage(
    name: AppRoutes.options,
    page: ()=> OptionsScreen()
  ),
  GetPage(
    name: AppRoutes.receipt,
    page: ()=> ReceiptScreen()
  ),
  GetPage(
    name: AppRoutes.pending,
    page: ()=> PendingScreen()
  ),
  GetPage(
    name: AppRoutes.ride_map,
    page: ()=> RideMapScreen()
  ),
  GetPage(
    name: AppRoutes.rate,
    page: ()=> RateScreen()
  ),
  
  GetPage(
    name: AppRoutes.settings,
    page: ()=> SettingsScreen()
  ),
  GetPage(
    name: AppRoutes.settings,
    page: ()=> SettingsScreen()
  ),
  GetPage(
    name: AppRoutes.changePassword,
    page: ()=> ChangePasswordScreen()
  ),
  GetPage(
    name: AppRoutes.updateAccount,
    page: ()=> UpdateAccountScreen()
  ),
];


Map assetsRoutes = {
  "images" : {
    "login-banner" : "assets/images/banners/login-banner.png",
    "logo-transparent" : "assets/images/logo/logo-transparent.png"
  }
};