import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/core/bootstrap/app_bootstrap.dart';
import 'package:shared/shared/constants/colors.dart';
import 'package:shared/shared/services/translation_service.dart';
import 'package:tajwal_rider/common/routes.dart';
import 'package:tajwal_rider/core/firebase/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('BG msg: ${message.messageId} | ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform, );
  FirebaseMessaging.onBackgroundMessage( firebaseMessagingBackgroundHandler, );
  await AppBootstrap.start();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tajwal',
      translations: TranslationService(),
      // locale: Locale(lang.language),
      // textDirection: lang.textDirection,
      fallbackLocale: const Locale('en'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
        fontFamily: 'Rubik',
      ),
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 100),
      popGesture: true,
      debugShowCheckedModeBanner: false,
      getPages: routes,
      routingCallback: (routing) {},
      initialRoute: AppRoutes.splashScreen
    );
  }
}
