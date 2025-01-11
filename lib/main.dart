import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/constants/routes/app_route.dart';
import 'package:raithan_serviceapp/controller/auth_controller.dart';

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
