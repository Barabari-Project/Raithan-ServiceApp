import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/utils.dart';
import 'package:raithan_serviceapp/common/custom_appbar.dart';
import 'package:raithan_serviceapp/common/custom_button.dart';
import 'package:raithan_serviceapp/controller/profile_controller.dart';

import '../../../Utils/app_colors.dart';
import '../../../constants/regex_constant.dart';

class Profile extends GetView<ProfileController> {
  Profile({super.key}) {
    Get.lazyPut(() => ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Profile".tr, context, options: false),
      body: Obx(
        () => SingleChildScrollView(
          controller: controller.scrollController,
          child: controller.isLoading.value
              ? Utils.getLoadingWidget()
              : Column(
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
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            // borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/farm-background.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ), // Profile image
                        Positioned(
                            bottom: -AppDimensions.width * 0.2,
                            // Adjust this value for the overlap
                            child: CircleAvatar(
                              radius: AppDimensions.width * 0.2,
                              backgroundColor: Colors.white,
                              child: controller.isImageUpdated.value
                                  ? CircleAvatar(
                                      radius: AppDimensions.width * 0.2 - 4,
                                      // Adjust for border thickness
                                      backgroundImage: FileImage(File(controller
                                          .profileImage
                                          .value)), // Local file image
                                    )
                                  : Utils.getCachedNetworkImageForProfile(
                                      controller.profileImage.value,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                            radius:
                                                AppDimensions.width * 0.2 - 4,
                                            // Adjust for border thickness
                                            backgroundImage:
                                                imageProvider, // The loaded network image
                                          )),
                            )),

                        controller.isEditAllowed.value
                            ? Positioned(
                                right: AppDimensions.width *
                                    0.27, // Position the edit icon
                                bottom: -15,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.pickImage();
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
                              )
                            : SizedBox()
                      ],
                    )),
                    Padding(
                      padding: EdgeInsets.only(
                          top: AppDimensions.width * 0.25,
                          left: AppDimensions.formFieldPadding,
                          right: AppDimensions.formFieldPadding,
                          bottom: AppDimensions.formFieldPadding),
                      child: Container(
                        child: Form(
                          key: controller.profileDetailsFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'First Name'.tr,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                readOnly: !controller.isEditAllowed.value,
                                controller: controller.firstNameController,
                                focusNode: controller.firstNameFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'First Name'.tr,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name'.tr;
                                  }
                                  if (!RegExp(RegexConstant.nameValidationRegex)
                                      .hasMatch(value)) {
                                    return 'First Name should contain only letter and space'.tr;
                                  } else if (value.length <= 2) {
                                    return "First Name length must be greater than 2".tr;
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  Utils.changeNodeFocus(
                                      context,
                                      controller.firstNameFocusNode,
                                      controller.lastNameFocusNode);
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Last Name'.tr,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                readOnly: !controller.isEditAllowed.value,
                                controller: controller.lastNameController,
                                focusNode: controller.lastNameFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'Last Name'.tr,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Last name'.tr;
                                  }
                                  if (!RegExp(RegexConstant.nameValidationRegex)
                                      .hasMatch(value)) {
                                    return 'Last Name should contain only letter and space'.tr;
                                  } else if (value.length <= 2) {
                                    return "Last Name length must be greater than 2".tr;
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  Utils.changeNodeFocus(
                                      context,
                                      controller.lastNameFocusNode,
                                      controller.dobFocusNode);
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Birth Year'.tr,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                // enabled: controller.isEditAllowed.value,
                                controller: controller.dobController,
                                focusNode: controller.dobFocusNode,
                                readOnly: true,
                                onTap: () {
                                  if (controller.isEditAllowed.value) {
                                    controller.showYearPicker(context);
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Birth Year'.tr,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  Utils.changeNodeFocus(
                                      context,
                                      controller.dobFocusNode,
                                      controller.genderFocusNode);
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Gender'.tr,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              DropdownMenu(
                                // errorText: errorText,
                                // initialSelection: initialValue,
                                trailingIcon: controller.isEditAllowed.value
                                    ? Icon(Icons.arrow_drop_down_outlined)
                                    : SizedBox.shrink(),
                                enabled: controller.isEditAllowed.value,
                                focusNode: controller.genderFocusNode,
                                initialSelection:
                                    controller.genderController.text,
                                inputDecorationTheme: InputDecorationTheme(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                                requestFocusOnTap: false,
                                width: AppDimensions.width * 0.9,

                                onSelected: (value) {
                                  print(controller.genderController.text);
                                  controller.genderController.value =
                                      TextEditingValue(text: value!);
                                },
                                dropdownMenuEntries: ["Male", "Female", "Other"]
                                    .map<DropdownMenuEntry<String>>(
                                        (String gender) {
                                  return DropdownMenuEntry<String>(
                                    label: gender.tr,
                                    value: gender,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: AppDimensions.width * 0.05,
                          left: AppDimensions.formFieldPadding,
                          right: AppDimensions.formFieldPadding,
                          bottom: AppDimensions.formFieldPadding),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: controller.isEditAllowed.value
                            ? [
                                CustomButton(
                                  isPrimary: false,
                                  width: 100,
                                  onPressed: () {
                                    controller.isEditAllowed.value = false;
                                  },
                                  child: Text("Cancel".tr),
                                ),
                                SizedBox(
                                  width: AppDimensions.width * 0.03,
                                ),
                                CustomButton(
                                  isPrimary: true,
                                  width: 200,
                                  onPressed: () {
                                    controller.saveUserProfilDetails(context);
                                  },
                                  isLoading:
                                      controller.savingProfileDetails.value,
                                  child: Text("Apply For Verification".tr),
                                )
                              ]
                            : [
                                FilledButton(
                                    onPressed: () {
                                      controller.isEditAllowed.value = true;
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all<Color>(AppColors.appBarColor), // Set your custom background color
                                      padding: WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Adjust padding if needed
                                      ),
                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12), // Add rounded corners
                                        ),
                                      ),
                                    ),
                                    child:  Row(
                                      children: [
                                        const Icon(
                                          Icons.edit,
                                          color: AppColors.whiteColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Edit".tr,
                                          style: const TextStyle(
                                              color: AppColors.whiteColor),
                                        ),
                                      ],
                                    ))
                              ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
