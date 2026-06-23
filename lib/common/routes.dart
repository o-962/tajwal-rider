import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared/core/routing/pages.dart';
import 'package:shared/features/error/error_screen.dart';
import 'package:shared/features/splash_screen/splash_screen.dart';
import 'package:shared/features/welcome/welcome_screen.dart';
import 'package:tajwal_rider/common/pages.dart';
import 'package:tajwal_rider/features/auth/binding/register_binding.dart';
import 'package:tajwal_rider/features/auth/register_screen.dart';
import 'package:tajwal_rider/features/history/binding/history_binding.dart';
import 'package:tajwal_rider/features/history/history_screen.dart';
import 'package:tajwal_rider/features/history/trip_details_screen.dart';
import 'package:tajwal_rider/features/main_settings/binding/settings_binding.dart';
import 'package:tajwal_rider/features/main_settings/settings_screen.dart';
import 'package:tajwal_rider/features/splash_screen/binding/splash_binding.dart';
import 'package:tajwal_rider/features/trip_active/rate/binding/rate_binding.dart';
import 'package:tajwal_rider/features/trip_active/rate/rate_screen.dart';
import 'package:tajwal_rider/features/trip_active/ride_map/binding/ride_map_binding.dart';
import 'package:tajwal_rider/features/trip_active/ride_map/ride_map_screen.dart';
import 'package:tajwal_rider/features/trip_setup/ride_preferences/options_screen.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/dropoff/binding/dropoff_binding.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/dropoff/dropoff_screen.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/pickup/binding/pickup_binding.dart';
import 'package:tajwal_rider/features/trip_setup/ride_route_selection/pickup/pickup_screen.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/binding/receipt_binding.dart';
import 'package:tajwal_rider/features/trip_setup/ride_summary/ride_summary_screen.dart';
import 'package:tajwal_rider/features/trip_waiting/ride_pending_acceptance/binding/pending_binding.dart';
import 'package:tajwal_rider/features/trip_waiting/ride_pending_acceptance/pending_screen.dart';

List<GetPage> routes = [
  GetPage(name: AppRoutes.welcome, page: () => const WelcomeScreen()),
  GetPage(
    name: AppRoutes.register,
    page: () => RegisterScreen(),
    binding: RegisterBinding(),
  ),
  GetPage(
    name: AppRoutes.pickup,
    page: () => PickupScreen(),
    binding: PickupBinding(),
  ),
  GetPage(name: AppRoutes.error, page: () => ErrorScreen()),

  GetPage(
    name: AppRoutes.dropoff,
    page: () => DropoffScreen(),
    binding: DropoffBinding(),
  ),
  GetPage(name: AppRoutes.options, page: () => OptionsScreen()),
  GetPage(
    name: AppRoutes.receipt,
    page: () => ReceiptScreen(),
    binding: ReceiptBinding(),
  ),
  GetPage(
    name: AppRoutes.pending,
    page: () => PendingScreen(),
    binding: PendingBinding(),
  ),
  GetPage(
    name: AppRoutes.rideMap,
    page: () => RideMapScreen(),
    binding: RideMapBinding(),
  ),
  GetPage(
    name: AppRoutes.rate,
    page: () => RateScreen(),
    binding: RateBinding(),
  ),
  GetPage(
    name: AppRoutes.settings,
    page: () => SettingsScreen(),
    binding: SettingsBinding(),
  ),
  GetPage(
    name: AppRoutes.history,
    page: () => HistoryScreen(),
    binding: HistoryBinding(),
  ),
  GetPage(
    name: AppRoutes.tripDetails,
    page: () => const TripDetailsScreen(),
  ),
  GetPage(
    name: AppRoutes.splashScreen,
    page: () => SplashScreen(),
    binding: SplashBinding(),
  ),
  ...commonRoutes,
];
