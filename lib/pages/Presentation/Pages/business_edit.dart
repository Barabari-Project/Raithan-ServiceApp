import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/utils.dart';
import 'package:raithan_serviceapp/common/custom_appbar.dart';
import 'package:raithan_serviceapp/common/custom_button.dart';
import 'package:raithan_serviceapp/controller/business_edit_controller.dart';
import 'package:raithan_serviceapp/controller/profile_controller.dart';
import 'package:raithan_serviceapp/pages/Presentation/Pages/business.dart';

import '../../../Utils/app_colors.dart';
import 'businessDetailsPage.dart';

class BusinessEdit extends GetView<BusinessEditController> {
  BusinessEdit({super.key}) {
    Get.lazyPut(() => BusinessEditController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Edit Business Details", context, options: false),
      body: Obx(
            () => SingleChildScrollView(
          controller: controller.scrollController,
          child: controller.isLoading.value
              ? Utils.getLoadingWidget()
              : Column(
                children: [
                  Businessdetailspage(
                              businessNameController: controller.businessNameController,
                              pincodeController: controller.pincodeController,
                              blockNumberController: controller.blockNumberController,
                              streetController: controller.streetController,
                              areaController: controller.areaController,
                              landmarkController: controller.landmarkController,
                              cityController: controller.cityController,
                              stateController: controller.stateController,
                              categoryController: controller.categoryController,
                              startTimeController: controller.startTimeController,
                              endTimeController: controller.endTimeController,
                              workingDaysController: controller.workingDaysController,
                              workingDays: controller.workingDays,
                              categories: controller.categories,
                              formKey: controller.businessDetailFormKey,
                            ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0,
                        left: AppDimensions.formFieldPadding,
                        right: AppDimensions.formFieldPadding,
                        bottom: AppDimensions.formFieldPadding),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        CustomButton(
                          child: Text("Cancel"),
                          isPrimary: false,
                          width: 100,
                          onPressed: () {
                            Get.back();
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
                            controller.saveBusinessDetails();
                          },
                          isLoading:
                          controller.savingBusinessDetails.value,
                        )
                      ] ,
                    ),
                  ),
                  // CustomButton(child: child, isPrimary: isPrimary)
                ],
              )
          ),
        ),
    );
  }
}
