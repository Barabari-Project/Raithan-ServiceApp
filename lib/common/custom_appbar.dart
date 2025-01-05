
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/constants/routes/route_name.dart';
import 'package:raithan_serviceapp/controller/profile_controller.dart';


PreferredSizeWidget customAppBar(String title, BuildContext context,{TabBar? tabBar}  ) {
  // String userStatus = Storage.readData(StorageEnums.status.name);
  String currentRoute = Get.currentRoute;

  return AppBar(
    iconTheme: const IconThemeData(
        color: white
    ),
    bottom: tabBar,
    title: Text(
      title,
      style: const TextStyle(color: white),
    ),
    backgroundColor: Colors.cyan,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: currentRoute==RouteName.profile ? GestureDetector(
          onTap: () {
            ProfileController profileController = Get.find();
            profileController.allowEditProfileDetails();
          },
          child: const Icon(
            Icons.edit,
            color: white,
          ),
        ) : PopupMenuButton(
            child: const Icon(
              Icons.more_vert_sharp,
              color: white,
            ),
            itemBuilder: (context) => [
              // replace all routes with actual routes
              PopupMenuItem(
                enabled: true,
                onTap: () {
                  Get.toNamed(RouteName.profile);
                },
                child: const Text("View Profile"),
              ),

              PopupMenuItem(
                onTap: () {
                  print("logout");
                },
                child: const Text("Sign Out"),
              ),
            ]),
      )
    ],
  );
}
