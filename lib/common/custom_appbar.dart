
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Utils/storage.dart';
import 'package:raithan_serviceapp/constants/enums/language_enum.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';
import 'package:raithan_serviceapp/constants/storage_keys.dart';
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
              if(authController.userRole.value == "PROVIDER" && authController.activeSession.value)
              PopupMenuItem(
                enabled: true,
                onTap: () {
                  Get.toNamed(RouteName.profile);
                },
                child: Text("Profile".tr),
              ),

              if(authController.userRole == "PROVIDER" && authController.activeSession.value)
              PopupMenuItem(
                enabled: true,
                onTap: () {
                  Get.toNamed(RouteName.business);
                },
                child: Text("Business".tr),
              ),

              if(!authController.activeSession.value)
              PopupMenuItem(
                enabled: true,
                onTap: () {
                  Get.offAllNamed(RouteName.login);
                },
                child: Text("Sign In".tr),
              ),

              if(authController.activeSession.value)
              PopupMenuItem(
                onTap: () {
                  Storage.removeAll();
                  authController.userRole.value = "SEEKER";
                  authController.activeSession.value = false;
                  Get.offAllNamed(RouteName.provider_home);
                },
                child: Text("Sign Out".tr),
              ),
              PopupMenuItem(
                onTap: () {
                  Get.updateLocale(Locale(LanguageEnum.hi.name));
                   Storage.saveValue(StorageKeys.LANGUAGE, LanguageEnum.hi.name);
                },
                child: const Text("हिन्दी"),
              ),
              PopupMenuItem(
                onTap: () {
                  Get.updateLocale(Locale(LanguageEnum.en.name));
                  Storage.saveValue(StorageKeys.LANGUAGE, LanguageEnum.en.name);
                },
                child: const Text("English"),
              ),
              PopupMenuItem(
                onTap: () {
                  Get.updateLocale(Locale(LanguageEnum.te.name));
                  Storage.saveValue(StorageKeys.LANGUAGE, LanguageEnum.te.name);
                },
                child: const Text("తెలుగు"),
              ),

            ]) : SizedBox() ,
      )
    ],
  );
}
