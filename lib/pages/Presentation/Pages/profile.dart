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
      appBar: customAppBar("Profile", context, options: false),
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
                          child: Container(
                            height: AppDimensions.width * 0.4,
                            // Adjust size
                            width: AppDimensions.width * 0.4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              // Optional border
                              image: controller.profileImage.value.isNotEmpty
                                  ? DecorationImage(
                                      image: controller.isImageUpdated.value
                                          ? FileImage(File(
                                              controller.profileImage.value))
                                          : NetworkImage(
                                              controller.profileImage.value),
                                      fit: BoxFit.cover)
                                  : null,
                            ),
                          ),
                        ),

                        controller.isEditAllowed.value
                            ? Positioned(
                                right: AppDimensions.width *
                                    0.27, // Position the edit icon
                                bottom: -15,
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle edit action
                                    print('Edit profile clicked!');
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
                              const Text(
                                'First Name *',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                readOnly: !controller.isEditAllowed.value,
                                controller: controller.firstNameController,
                                focusNode: controller.firstNameFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'First Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  if(!RegExp(RegexConstant.nameValidationRegex).hasMatch(value))
                                  {
                                    return 'First Name should contain only letter and space';
                                  }
                                  else if(value.length <= 2)
                                  {
                                    return "First Name length must be greater than 2";
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
                              const Text(
                                'Last Name *',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                readOnly: !controller.isEditAllowed.value,
                                controller: controller.lastNameController,
                                focusNode: controller.lastNameFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  if(!RegExp(RegexConstant.nameValidationRegex).hasMatch(value))
                                  {
                                    return 'First Name should contain only letter and space';
                                  }
                                  else if(value.length <= 2)
                                  {
                                    return "First Name length must be greater than 2";
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
                              const Text(
                                'Birth Year *',
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
                                  hintText: 'Birth Year',
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
                              const Text(
                                'Gender',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                    Padding(
                            padding: EdgeInsets.only(
                                top: AppDimensions.width * 0.05,
                                left: AppDimensions.formFieldPadding,
                                right: AppDimensions.formFieldPadding,
                                bottom: AppDimensions.formFieldPadding),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: controller.isEditAllowed.value ? [
                                CustomButton(
                                  child: Text("Cancel"),
                                  isPrimary: false,
                                  width: 100,
                                  onPressed: () {
                                    controller.isEditAllowed.value = false;
                                  },
                                ),
                                SizedBox(
                                  width: AppDimensions.width * 0.03,
                                ),
                                CustomButton(
                                  child: Text("Apply For Verification"),
                                  isPrimary: true,
                                  width: 200,
                                  onPressed: () {
                                    controller.saveUserProfilDetails();
                                  },
                                  isLoading:
                                      controller.savingProfileDetails.value,
                                )
                              ] : [
                                CustomButton(
                                  isPrimary: true,
                                  width: 100,
                                  onPressed: (){
                                    controller.isEditAllowed.value = true;
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: AppColors.whiteColor,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Edit",
                                        style: TextStyle(color: AppColors.whiteColor),
                                      ),
                                    ],
                                  )) ],
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
