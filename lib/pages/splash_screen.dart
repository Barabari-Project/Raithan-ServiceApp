import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/constants/routes/app_route.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';
import 'package:raithan_serviceapp/constants/storage_keys.dart';
import 'package:raithan_serviceapp/controller/auth_controller.dart';
import 'package:raithan_serviceapp/controller/splash_screen_controller.dart';
import 'package:raithan_serviceapp/pages/Presentation/Pages/provider_home.dart';
import 'package:raithan_serviceapp/pages/Presentation/registration.dart';

import '../Utils/app_dimensions.dart';
import '../utils/storage.dart';

class SplashScreen extends GetView<SplashScreenController> {

  SplashScreen({Key? key}) : super(key: key) {
    Future.delayed(Duration(seconds: 3), () {
      loadNextScreen();
    });;
  }
  //
  Future<void> loadNextScreen() async {
   String? userRole = await Storage.getValue(StorageKeys.USER_ROLE);
   String? currentPhase = await Storage.getValue(StorageKeys.CURRENT_PHASE);
   String? jwtToken = await Storage.getValue(StorageKeys.JWT_TOKEN);

   AuthController authController = Get.find();

    if(jwtToken == null || jwtToken.isEmpty)
      {
         Get.offNamed(RouteName.provider_home);
         return;
      }

    if(jwtToken != null && jwtToken.isNotEmpty)
      {
          authController.activeSession.value = true;

          if(userRole != null && userRole == "PROVIDER")
            {
               if(currentPhase == null)
                 {
                   authController.userRole.value = "PROVIDER";
                   Get.offNamed(RouteName.provider_home);
                   return;
                 }
               else{
                 Get.offNamed(RouteName.registration);
                 return;
               }
            }
          else{
            authController.userRole.value = "SEEKER";
            Get.offNamed(RouteName.provider_home);
            return;
          }
      }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: AppDimensions.splashScreenImageWidth,
                width: AppDimensions.splashScreenImageWidth,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/logo/ic_launcher_foreground.png'),
                    fit: BoxFit.cover,
                  ) ,
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
          const Text(
          'Raithan',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ],

      )

    );

  }
}
