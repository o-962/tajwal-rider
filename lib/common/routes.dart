import 'package:get/get.dart';
import 'package:shared/core/routing/pages.dart';
import 'package:shared/features/error/error_screen.dart';
import 'package:shared/features/splash_screen/splash_screen.dart';
import 'package:shared/features/welcome/welcome_screen.dart';
import 'package:tajwal_rider/common/pages.dart';
import 'package:tajwal_rider/features/account/account_screen.dart';
import 'package:tajwal_rider/features/account/binding/account_binding.dart';
import 'package:tajwal_rider/features/auth/register/binding/register_binding.dart';
import 'package:tajwal_rider/features/auth/register/register_screen.dart';
import 'package:tajwal_rider/features/history/binding/rider_history_binding.dart';
import 'package:tajwal_rider/features/history/rider_history_screen.dart';
import 'package:tajwal_rider/features/home/binding/home_binding.dart';
import 'package:tajwal_rider/features/home/home_screen.dart';
import 'package:tajwal_rider/features/orders/current_order/current_order_screen.dart';
import 'package:tajwal_rider/features/orders/gifts_order/binding/gifts_order_binding.dart';
import 'package:tajwal_rider/features/orders/order_summary/binding/order_summary_binding.dart';
import 'package:tajwal_rider/features/orders/order_summary/order_summary_screen.dart';
import 'package:tajwal_rider/features/orders/gifts_order/gifts_order_screen.dart';
import 'package:tajwal_rider/features/orders/passengers_order/binding/passengers_order_binding.dart' hide GiftsOrderBinding;
import 'package:tajwal_rider/features/orders/passengers_order/passengers_order_screen.dart';
import 'package:tajwal_rider/features/orders/shared/dropoff/binding/dropoff_binding.dart';
import 'package:tajwal_rider/features/orders/shared/dropoff/dropoff_screen.dart';
import 'package:tajwal_rider/features/orders/shared/pickup/binding/pickup_binding.dart';
import 'package:tajwal_rider/features/orders/shared/pickup/pickup_screen.dart';
import 'package:tajwal_rider/features/shell/binding/shell_binding.dart';
import 'package:tajwal_rider/features/shell/shell_screen.dart';
import 'package:tajwal_rider/features/splash_screen/binding/splash_binding.dart';
import 'package:tajwal_rider/features/splash_screen/controller/splash_screen_controller.dart';

List<GetPage> routes = [
  GetPage(name: AppRoutes.welcome, page: () => const WelcomeScreen()),
  GetPage(
    name: AppRoutes.register,
    page: () => RegisterScreen(),
    binding: RegisterBinding(),
  ),
  GetPage(name: AppRoutes.error, page: () => ErrorScreen()),
  GetPage(name: AppRoutes.home, page: () => HomeScreen() , binding: HomeBinding()),
  GetPage(name: AppRoutes.giftsOrder, page: () => GiftsOrderScreen()  , binding: GiftsOrderBinding()),
  GetPage(name: AppRoutes.shell, page: () => ShellScreen() , binding: ShellBinding()),
  GetPage(name: AppRoutes.passengersOrder, page: () => PassengersOrderScreen(), binding: PassengersOrderBinding()),
  GetPage(name: AppRoutes.currentOrder, page: () => CurrentOrderScreen()),
  GetPage(
    name: AppRoutes.orderSummary,
    page: () => const OrderSummaryScreen(),
    binding: OrderSummaryBinding(),
  ),
  GetPage(
    name: AppRoutes.orderHistory,
    page: () => const RiderHistoryScreen(),
    binding: RiderHistoryBinding(),
  ),
  // View only, but fetches the profile over HTTP on open — hence a binding.
  GetPage(
    name: AppRoutes.account,
    page: () => const AccountScreen(),
    binding: AccountBinding(),
  ),
  GetPage(name: AppRoutes.pickup, page: () => const PickupScreen(), binding: PickupBinding()),
  GetPage(name: AppRoutes.dropoff, page: () => const DropoffScreen(), binding: DropoffBinding()),
  GetPage(
    name: AppRoutes.splashScreen,
    page: () {
      final controller = Get.find<SplashScreenController>();
      return Obx(
        () => SplashScreen(
          loadingProgress: controller.loadingProgress.value,
          loadingStatus: controller.loadingStatus.value,
          isLoading: controller.isLoading.value,
        ),
      );
    },
    binding: SplashBinding(),
  ),

  ...commonRoutes,
];
