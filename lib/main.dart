import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Utils/app_style.dart';
import 'constants/routes/app_route.dart';
import 'controller/auth_controller.dart';


void main() {
  Get.put(AuthController());
  runApp(
    SafeArea(child: GetMaterialApp(  debugShowCheckedModeBanner: false,
      getPages: AppRoutes.appRoutes(),
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
