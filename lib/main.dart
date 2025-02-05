import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jacobia/view_model/AuthGetX/AuthController.dart';
import 'package:jacobia/core/localization/app_localization.dart';
import 'package:jacobia/view_model/database/local/cache_helper.dart';
import 'view/pages/authentication/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();

  // Load translations
  await AppLocalization.loadTranslations();

  // Set language based on saved preference
  String languageCode = AppLocalization.getSavedLanguage();
  Get.updateLocale(Locale(languageCode));

  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      // Enable GetX Localization
      translations: AppLocalization(),
      locale: Get.locale ?? const Locale('ar'),  // Default to 'ar'
      fallbackLocale: const Locale('en'),
      theme: ThemeData(
        fontFamily: Get.locale?.languageCode == 'ar' ? 'Cairo' : 'italic',
      ),
      home: SignIn(),
    );
  }
}
