import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Onboarding/Presentation/registration.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/constants/routes/app_route.dart';

void main() {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raithan ServiceApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Registration(),
    );
  }
}
