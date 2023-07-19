import 'dart:developer';

import 'package:dio/dio.dart' as dd;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/features/splash/view.dart';
import 'package:you_learnt/utils/dismiss_keyboard.dart';
import 'binding.dart';
import 'constants/colors.dart';
import 'constants/env.dart';
import 'data/hive/hive_constant.dart';
import 'localization/en.dart';
import 'localization/translations.dart';
import 'utils/error_handler/error_handler.dart';

bool isArabicLanguage = true;
String? notificationUrl;

void main() async {
  Get.put(Translation());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(HiveConstant.generalBox);

  isArabicLanguage = HiveController.getIsArabicLanguage();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  OneSignal.shared.setAppId(oneSignalAppId);

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    log("Accepted permission: $accepted");
  });
  OneSignal.shared.setNotificationOpenedHandler(_handleNotificationOpened);

  await translateMap();
  Binding().dependencies();

  runApp(const MyApp());
}

Future<void> translateMap() async {
  try {
    Map<String, String> newMap = {};
    int index = 0;
    en.forEach((key, value) {
      newMap['lang[$index]'] = key;
      index++;
    });
    var res = await dd.Dio(dd.BaseOptions(baseUrl: baseUrl, headers: {
      'Accept-Language': HiveController.getLanguageCode() ?? 'en',
      'lang': HiveController.getLanguageCode() ?? 'en'
    })).post('translate', data: dd.FormData.fromMap(newMap));
    // log(json.encode(res.data));
    List list = (res.data['object'] as List).map((e) => e).toList();
    Map<String, String> local = {};
    for (var element in list) {
      if (element.keys.first != '' || element.values != null) {
        local[element.keys.first] = element.values.first;
      }
    }
    Get.find<Translation>().map = {
      'en': en,
      HiveController.getLanguageCode() ?? 'en': local
    };
  } catch (e) {
    ErrorHandler.handleError(e);
  }
}

void _handleNotificationOpened(OSNotificationOpenedResult result) {
  var additionalData = result.notification.additionalData;
  if (additionalData != null) {
    if (additionalData.containsKey("url")) {
      notificationUrl = result.notification.additionalData?['url'];
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: ScreenUtilInit(
        designSize: const Size(390, 938),
        builder: (context, widget) => GetMaterialApp(
          builder: (context, widget) {
            ScreenUtil.init(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          debugShowCheckedModeBanner: false,
          title: appName,
          locale: Locale(HiveController.getLanguageCode() ?? 'en'),
          fallbackLocale: Locale(HiveController.getLanguageCode() ?? 'en'),
          initialBinding: Binding(),
          translations: Get.find<Translation>(),
          translationsKeys: Get.find<Translation>().keys,
          theme: ThemeData(
              fontFamily: fontName,
              primarySwatch: mainColor,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
              )),
          home: SplashPage(),
        ),
      ),
    );
  }
}
