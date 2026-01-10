import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/common/colors.dart';
import 'package:shared/common/media_query.dart';
import 'package:shared/models/api_response_model.dart';
import 'package:shared/services/api_services.dart';
import 'package:shared/services/shared_data.dart';
import 'package:shared/services/socket_connection_services.dart';
import 'package:shared/services/translations_services.dart';
import 'package:tajwal_rider/common/routes.dart';
import 'package:tajwal_rider/services/ride_services.dart';
import 'package:shared/utils/app_utils.dart';
import 'package:tajwal_rider/utils/init_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  Get.put(RideServices());

  String initialRoute = AppRoutes.error;
  try {
    ApiModel init = await ApiServices(role: 'user').appInit();
    String initRoute = initUtils(init);
    if (initRoute == AppRoutes.error) {
      print('error with api');
    }
    if (initRoute != AppRoutes.error) {
      await SocketConnectionServices.start();

      if (SocketConnectionServices.isConnected()) {
        print('connected to socket');
      }
      initialRoute = SocketConnectionServices.isConnected() ? initRoute : AppRoutes.error;
    }
  } catch (e) {
    print('❌ App initialization error: $e');
  }

  print(initialRoute);
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    String lang = SharedData.language;
    return GetMaterialApp(
      title: 'Tajwal',
      translations: AppTranslations(),
      locale: Locale(lang),
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
      textDirection: textDirectionality(),
      initialRoute: initialRoute,
      onReady: () {
        SharedData.isInitialized = true;
      },
    );
  }
}
