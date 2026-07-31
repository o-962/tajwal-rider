import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:shared/index.dart';
import 'package:tajwal_rider/common/pages.dart';
import 'package:tajwal_rider/features/config/config_controller.dart';
import 'package:tajwal_rider/features/splash_screen/dto/splash_screen_dto.dart';

typedef AppInitializationResult = ({bool isAuthenticated, String redirectTo});

class SplashScreenController extends GetxController {
  AuthService get sharedToken => Get.find<AuthService>();
  TranslationService get translationService => Get.find<TranslationService>();
  AppConfigController get appConfigController => Get.find<AppConfigController>();
  final RxDouble loadingProgress = 0.0.obs;
  final RxString loadingStatus = ''.tr.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _smoothProgress(double target, {int durationMs = 100}) async {
    final start = loadingProgress.value;
    final steps = 50;
    final increment = (target - start) / steps;
    final delay = durationMs ~/ steps;

    for (int i = 0; i < steps; i++) {
      loadingProgress.value = start + (increment * (i + 1));
      await Future.delayed(Duration(milliseconds: delay));
    }
    loadingProgress.value = target;
  }

  _init() async {
    try {
      AppConfig.isInitialized = true;
      loadingStatus.value = 'loading_credentials'.tr;
      await _smoothProgress(0.2, durationMs: 800);
      await sharedToken.hydrateToken();

      if (sharedToken.isLoggedIn()) {
        AppInitializationResult socketConnection = await connectToWebSocket();
        print(socketConnection);
        if (socketConnection.redirectTo == CommonRoutes.error) {
          Get.offAllNamed(socketConnection.redirectTo);
          return;
        }
      }

      await _smoothProgress(0.5, durationMs: 800);

      final appInitResult = await _appInit();
      await _smoothProgress(1, durationMs: 800);
      Get.offAllNamed(appInitResult.redirectTo);
    } catch (e, stackTrace) {
      Crashlytics().logError(e, stackTrace: stackTrace);
    }
  }

  Future<AppInitializationResult> connectToWebSocket() async {
    try {
      await SocketClient.connect();
      if (!SocketClient.isConnected) {
        return (isAuthenticated: false, redirectTo: CommonRoutes.error);
      }
      return (isAuthenticated: true, redirectTo: AppRoutes.shell);
    } catch (e, stackTrace) {
      Crashlytics().logError(e, stackTrace: stackTrace);
      return (isAuthenticated: false, redirectTo: CommonRoutes.error);
    }
  }

  Future<AppInitializationResult> _appInit() async {
    try {
      
      final response = await ApiServices.dio.get(
        ApiEndpoints.userInit,
        queryParameters: await _fcmTokenQuery(),
      );
      AppInitializationResult appInitResult = await _applyInit(response.parsed);
      print(
        'App Initialization Result: isAuthenticated=${appInitResult.isAuthenticated}, redirectTo=${appInitResult.redirectTo}',
      );

      return (isAuthenticated: appInitResult.isAuthenticated, redirectTo: appInitResult.redirectTo);
    } catch (e, stackTrace) {
      print('Error during app initialization: $e');
      Crashlytics().logError(e, stackTrace: stackTrace);
      return (isAuthenticated: false, redirectTo: CommonRoutes.error);
    }
  }

  /// The device's current FCM token, shaped as init query params.
  ///
  /// Sent on every startup because tokens rotate (reinstall, restore, Firebase's
  /// own rotation) and `/init/user` is the one call every launch makes — the
  /// backend replaces the stored token whenever this key is present.
  ///
  /// Returns an EMPTY map when the token can't be read (notifications denied, no
  /// Play services) rather than a null or '' value: the DTO field is
  /// `@IsOptional()`, so it must see no key at all instead of an empty one, which
  /// would overwrite a good stored token with nothing.
  Future<Map<String, dynamic>> _fcmTokenQuery() async {
    try {
      final token = await NotificationService.getFCMToken();
      if (token == null || token.isEmpty) return const <String, dynamic>{};
      return {FieldInputType.FCM_TOKEN.value: token};
    } catch (e, stackTrace) {
      // Never let a push-token problem block startup — init must still run.
      Crashlytics().logError(e, stackTrace: stackTrace);
      return const <String, dynamic>{};
    }
  }

  Future<AppInitializationResult> _applyInit(ApiDto response) async {
    try {
      if (response.statusCode == HttpStatus.serviceUnavailable) {
        return (isAuthenticated: false, redirectTo: CommonRoutes.maintenance);
      }
      if (response.statusCode == HttpStatus.unauthorized) {
        sharedToken.logout();
        return (isAuthenticated: false, redirectTo: CommonRoutes.welcome);
      }
      if (response.statusCode != HttpStatus.ok) {
        return (isAuthenticated: false, redirectTo: CommonRoutes.error);
      }
      Map<String, dynamic>? data = response.data;
      
      if (response.statusCode == HttpStatus.ok && data != null) {
        AppConfigDto configs = AppConfigDto.fromJson(data);
        translationService.addTranslations(configs.translations);
        loadingStatus.value = 'loading_account'.tr;
        isLoading.value = false;
        await _smoothProgress(0.2, durationMs: 800);
        if (configs.inMaintenance) {
          loadingStatus.value = 'maintenance_mode'.tr;
          await _smoothProgress(0.9, durationMs: 1500);
          return (isAuthenticated: false, redirectTo: CommonRoutes.maintenance);
        }
        if (configs.forceLogout) {
          loadingStatus.value = 'logging_out'.tr;
          await _smoothProgress(0.9, durationMs: 1500);
          sharedToken.logout();
          return (isAuthenticated: false, redirectTo: CommonRoutes.welcome);
        }

        appConfigController.setConfig(configs);
        if (configs.authId != null && configs.authId!.isNotEmpty) {
          loadingStatus.value = 'setting_user_id'.tr;
          await _smoothProgress(0.9, durationMs: 500);
          Crashlytics().setUserId(configs.authId!);
        }
        return (isAuthenticated: configs.auth, redirectTo: configs.auth ? AppRoutes.shell : CommonRoutes.welcome);
      }
      return (isAuthenticated: false, redirectTo: CommonRoutes.error);
    } catch (e, stackTrace) {
      Crashlytics().logError(e, stackTrace: stackTrace);
      print(e);
      return (isAuthenticated: false, redirectTo: CommonRoutes.error);
    }
  }
}
