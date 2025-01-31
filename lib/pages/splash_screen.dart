import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/routes/route_name.dart';
import '../constants/storage_keys.dart';
import '../controller/auth_controller.dart';
import '../controller/splash_screen_controller.dart';
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

    await Firebase.initializeApp();

    AuthController authController = Get.find();

    authController.activeSession.value = false;

    if(jwtToken == null || jwtToken.isEmpty)
    {
      authController.userRole.value = "SEEKER";
      Get.offNamed(RouteName.provider_home);
      return;
    }

    if(userRole == null)
      {
        authController.userRole.value = "SEEKER";
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
        authController.activeSession.value = true;
        authController.userRole.value = "SEEKER";
        Get.offNamed(RouteName.provider_home);
        return;
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: screenWidth*0.5,
                  width: screenWidth*0.5,
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
            Text(
              'Raithan'.tr,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],

        )

    );

  }
}
