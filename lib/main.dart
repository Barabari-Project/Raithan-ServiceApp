import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/storage.dart';
import 'package:raithan_serviceapp/constants/enums/language_enum.dart';
import 'package:raithan_serviceapp/constants/storage_keys.dart';
import 'package:raithan_serviceapp/getx_localization/languages.dart';

import 'Utils/app_style.dart';
import 'constants/routes/app_route.dart';
import 'controller/auth_controller.dart';


void main() async {
  Get.put(AuthController());
  String language = await Storage.getValue(StorageKeys.LANGUAGE) ?? "en";
  runApp(
    SafeArea(child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(language),
      fallbackLocale: Locale(LanguageEnum.en.name),
      getPages: AppRoutes.appRoutes(),
      translations: Languages(),
      theme: ThemeData(
          fontFamily: "Poppins",
          colorScheme:
          ColorScheme.fromSeed(seedColor: black),
          appBarTheme:
          const AppBarTheme(backgroundColor: black),
          useMaterial3: true),
    ),
    )
  );
}
