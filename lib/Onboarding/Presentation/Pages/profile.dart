import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/common/custom_appbar.dart';
import 'package:raithan_serviceapp/controller/profile_controller.dart';

class Profile extends GetView<ProfileController> {
  Profile({super.key}) {
    Get.lazyPut(() => ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Profile", context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                child: Stack(
              clipBehavior: Clip.none, // Allows overflow
              alignment: Alignment.center,
              children: [
                // Main container with farm image
                Container(
                  height: 180,
                  width: AppDimensions.width,
                  decoration: BoxDecoration(
                    color: Colors
                        .green, // borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage('assets/images/farm-background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ), // Profile image
                Positioned(
                  bottom: -AppDimensions.width * 0.2,
                  // Adjust this value for the overlap
                  child: Obx(
                    () => Container(
                      height: AppDimensions.width * 0.4,
                      // Adjust size
                      width: AppDimensions.width * 0.4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white, width: 4), // Optional border
                        image: DecorationImage(
                          image: controller.isProfileImageUpdated.value
                              ? FileImage(
                                  File(controller.profileImagePath.value))
                              : NetworkImage(
                                  "https://plus.unsplash.com/premium_photo-1683865776032-07bf70b0add1?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D%27"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () {
                    if (controller.isEditAllowed.value) {
                      return Positioned(
                        right: AppDimensions.width *
                            0.27, // Position the edit icon
                        bottom: -15,
                        child: GestureDetector(
                          onTap: () {
                            // Handle edit action
                            print('Edit profile clicked!');
                            controller.showImageSourceDialog(context);
                          },
                          child: Container(
                            height: AppDimensions.width * 0.08,
                            width: AppDimensions.width * 0.08,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: AppDimensions.width * 0.05,
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox();
                  },
                ),
              ],
            )),
            Padding(
              padding: EdgeInsets.only(
                  top: AppDimensions.width * 0.25,
                  left: AppDimensions.formFieldPadding,
                  right: AppDimensions.formFieldPadding,
                  bottom: AppDimensions.formFieldPadding),
              child: Obx(
                () => Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'First Name *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        enabled: controller.isEditAllowed.value,
                        controller: controller.firstNameController,
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Last Name *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        enabled: controller.isEditAllowed.value,
                        controller: controller.lastNameController,
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Birth Year *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        enabled: controller.isEditAllowed.value,
                        controller: controller.dobController,
                        decoration: InputDecoration(
                          hintText: 'Birth Year',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Gender',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownMenu(
                        // errorText: errorText,
                        // initialSelection: initialValue,
                        inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        requestFocusOnTap: false,
                        width: AppDimensions.width * 0.9,
                        onSelected: (value) {},
                        dropdownMenuEntries: ["Male", "Female", "Other"]
                            .map<DropdownMenuEntry<String>>((String gender) {
                          return DropdownMenuEntry<String>(
                            label: gender,
                            value: gender,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () {
                if (controller.isEditAllowed.value) {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: AppDimensions.width * 0.05,
                        left: AppDimensions.formFieldPadding,
                        right: AppDimensions.formFieldPadding,
                        bottom: AppDimensions.formFieldPadding),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            controller.isEditAllowed.value = false;
                          },
                          child: Text("Cancel"),
                        ),
                        SizedBox(
                          width: AppDimensions.width * 0.03,
                        ),
                        FilledButton(
                            onPressed: () {},
                            child: Text("Apply For Verification"))
                      ],
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
