
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Utils/storage.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';
import 'package:raithan_serviceapp/controller/auth_controller.dart';
import 'package:raithan_serviceapp/controller/profile_controller.dart';


PreferredSizeWidget customAppBar(String title, BuildContext context,{TabBar? tabBar, bool options = true}  ) {

  AuthController authController = Get.find();

  return AppBar(
    iconTheme: const IconThemeData(
        color: white,
    ),
    bottom: tabBar,
    title: Text(
      title,
      style: const TextStyle(color: white),
    ),
    backgroundColor: Color.fromRGBO(18, 130, 105,1),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: options ? PopupMenuButton(
            child: const Icon(
              Icons.more_vert_sharp,
              color: white,
            ),
            itemBuilder: (context) => [
              // replace all routes with actual routes
              if(authController.userRole == "PROVIDER" && authController.activeSession.value)
              PopupMenuItem(
                enabled: true,
                onTap: () {
                  Get.toNamed(RouteName.profile);
                },
                child: const Text("Profile"),
              ),

              if(authController.userRole == "PROVIDER" && authController.activeSession.value)
              PopupMenuItem(
                enabled: true,
                onTap: () {
                  Get.toNamed(RouteName.business);
                },
                child: const Text("Business"),
              ),

              if(!authController.activeSession.value)
              PopupMenuItem(
                enabled: true,
                onTap: () {
                  Get.offAllNamed(RouteName.login);
                },
                child: const Text("Sign In"),
              ),

              if(authController.activeSession.value)
              PopupMenuItem(
                onTap: () {
                  Storage.removeAll();
                  authController.userRole.value = "";
                  authController.activeSession.value = false;
                  Get.offAllNamed(RouteName.provider_home);
                },
                child: const Text("Sign Out"),
              ),
            ]) : SizedBox() ,
      )
    ],
  );
}
