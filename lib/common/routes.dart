import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared/core/routing/pages.dart';
import 'package:shared/core/routing/route.dart';
import 'package:shared/features/error/error_screen.dart';
import 'package:shared/features/splash_screen/splash_screen.dart';
import 'package:shared/features/welcome/welcome_screen.dart';
import 'package:tajwal_rider/features/auth/binding/login_binding.dart';
import 'package:tajwal_rider/features/auth/login_screen.dart';
import 'package:tajwal_rider/features/auth/register_screen.dart';
import 'package:tajwal_rider/features/history/history_screen.dart';
import 'package:tajwal_rider/features/main-settings/settings_screen.dart';
import 'package:tajwal_rider/features/pending/pending_screen.dart';
import 'package:tajwal_rider/features/rate/rate_screen.dart';
import 'package:tajwal_rider/features/ride_location/dropoff/dropoff_screen.dart';
import 'package:tajwal_rider/features/ride_location/pickup/pickup_screen.dart';
import 'package:tajwal_rider/features/ride_map/ride_map_screen.dart';
import 'package:tajwal_rider/features/ride_options/options_screen.dart';
import 'package:tajwal_rider/features/ride_receipt/receipt_screen.dart';
import 'package:tajwal_rider/features/splash_screen/binding/splash_binding.dart';

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
  static const String rideMap = '/ride-map';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String updateAccount = '/update-account';
  static const String history = '/history';
  static const String splashScreen = '/splash-screen';
}

List<GetPage> routes = [
  GetPage(name: AppRoutes.welcome, page: () => const WelcomeScreen()),
  GetPage(
    name: AppRoutes.login,
    page: () => LoginScreen(),
    binding: LoginBinding(),
  ),
  GetPage(name: AppRoutes.register, page: () => RegisterScreen()),
  GetPage(name: AppRoutes.pickup, page: () => PickupScreen()),
  GetPage(name: AppRoutes.error, page: () => ErrorScreen()),

  GetPage(name: AppRoutes.dropoff, page: () => DropoffScreen()),
  GetPage(name: AppRoutes.options, page: () => OptionsScreen()),
  GetPage(name: AppRoutes.receipt, page: () => ReceiptScreen()),
  GetPage(name: AppRoutes.pending, page: () => PendingScreen()),
  GetPage(name: AppRoutes.rideMap, page: () => RideMapScreen()),
  GetPage(name: AppRoutes.rate, page: () => RateScreen()),

  GetPage(name: AppRoutes.settings, page: () => SettingsScreen()),

  GetPage(name: AppRoutes.history, page: () => HistoryScreen()),
  GetPage(name: CommonRoutes.splashScreen, page: () => SplashScreen() , binding: SplashBinding()),
  ...commonRoutes,
];
