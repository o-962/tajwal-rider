import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared/core/bootstrap/app_bootstrap.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/shared/constants/layout.dart';
import 'package:shared/shared/services/translation_service.dart';
import 'package:tajwal_rider/common/pages.dart';
import 'package:tajwal_rider/common/routes.dart';
import 'package:tajwal_rider/core/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppBootstrap.start();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  TranslationService get _translationService => Get.find<TranslationService>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'app_name'.tr,

      translations: _translationService,
      locale: Locale(_translationService.lang),
      textDirection: _translationService.textDirection,
      fallbackLocale: const Locale('en'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
        fontFamily: 'Rubik',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColor.primary,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
      popGesture: true,

      debugShowCheckedModeBanner: false,
      getPages: routes,
      initialRoute: AppRoutes.splashScreen,
      onReady: () => AppSize.init(context),
    );
  }
}
