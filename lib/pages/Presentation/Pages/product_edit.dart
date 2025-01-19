import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Widgets/custom_image_field.dart';
import 'package:raithan_serviceapp/Widgets/multiple_option_input_field.dart';
import 'package:raithan_serviceapp/Widgets/textField.dart';
import 'package:raithan_serviceapp/common/custom_button.dart';
import 'package:raithan_serviceapp/constants/enums/business_category.dart';
import 'package:raithan_serviceapp/constants/enums/drone_type.dart';
import 'package:raithan_serviceapp/constants/enums/machinery_type.dart';
import 'package:raithan_serviceapp/controller/product_edit_controller.dart';

import '../../../Utils/app_style.dart';
import '../../../Utils/utils.dart';
import '../../../Widgets/dropDownTextFeild.dart';
import '../../../common/custom_appbar.dart';

class ProductEdit extends GetView<ProductEditController> {
  ProductEdit({super.key}) {
    Get.lazyPut(() => ProductEditController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      customAppBar(controller.businessType.value, context, options: false),
      body: Obx(
            () => SingleChildScrollView(
            controller: controller.scrollController,
            child: controller.isLoading.value
                ? Utils.getLoadingWidget()
                : Container(
              padding: EdgeInsets.all(AppDimensions.formFieldPadding),
              child: Form(
                key: controller.productDetailsFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.businessType.value + " Details",
                              style: robotoBold.copyWith(
                                color: black,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        CustomTextfield(
                            focusNode: controller.modelNoFocusNode,
                            type: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please write Model Number";
                              }
                              return null; // No errors
                            },
                            onFieldSubmitted: (value)
                            {
                              if(controller.businessType.value != BusinessCategory.DRONES.name) {
                                      Utils.changeNodeFocus(
                                          context,
                                          controller.modelNoFocusNode,
                                          controller.hpFocusNode);
                                    }
                              else{
                                Utils.changeNodeFocus(
                                    context,
                                    controller.modelNoFocusNode,
                                    controller.typeFocusNode);
                              }
                              },
                            controller: controller.modelNoController,
                            label: "Model No"),
                        sizedBox(),
                        if(controller.businessType.value != BusinessCategory.DRONES.name)
                        CustomTextfield(
                            focusNode: controller.hpFocusNode,
                            type: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please write horse power";
                              }
                              if (int.tryParse(value) == null) {
                                return "Horse power must be a valid number";
                              }
                              return null; // No errors
                            },
                            onFieldSubmitted: (value)
                            {
                               controller.hpFocusNode.unfocus();
                               if(controller.businessType.value == BusinessCategory.HARVESTORS.name
                                   || controller.businessType.value == BusinessCategory.EARTH_MOVERS.name)
                                 {
                                   FocusScope.of(context).requestFocus(controller.typeFocusNode);
                                 }
                            },
                            controller: controller.hpController,
                            label: "Horse Power"),
                        if(controller.businessType.value != BusinessCategory.DRONES.name)
                        sizedBox(),
                        if(controller.businessType.value == BusinessCategory.HARVESTORS.name
                         || controller.businessType.value == BusinessCategory.EARTH_MOVERS.name
                         || controller.businessType.value == BusinessCategory.DRONES.name)
                        DropdownTextField(
                          controller: controller.typeController,
                          label: "Select an ${controller.businessType} Type",
                          focusNode: controller.typeFocusNode,
                          onFieldSubmitted: (value) {
                            controller.typeFocusNode.unfocus();
                          },
                          options: controller.businessType.value == BusinessCategory.DRONES.name ?
                               DroneType.values.map((type) => type.description,).toList() :
                               MachineryType.values.map((type) => type.description,).toList()
                          ,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an option';
                            }
                            return null;
                          },
                        ),
                        if(controller.businessType.value == BusinessCategory.HARVESTORS.name
                            || controller.businessType.value == BusinessCategory.EARTH_MOVERS.name
                            || controller.businessType.value == BusinessCategory.DRONES.name)
                        sizedBox(),
                        CustomImageField(
                            controller: controller.frontViewImageController,
                            title: "Front View Image"),
                        sizedBox(),
                        CustomImageField(
                            controller: controller.leftViewImageController,
                            title: "Left View Image"),
                        sizedBox(),
                        CustomImageField(
                            controller: controller.backViewImageController,
                            title: "Back View Image"),
                        sizedBox(),
                        CustomImageField(
                            controller: controller.rightViewImageController,
                            title: "Right View Image"),
                        sizedBox(),
                        CustomImageField(
                            controller: controller.rcBookImageController,
                            title: controller.businessType.value == BusinessCategory.DRONES.name  ?  "Drone Bill Image" : "RC Book Image"

                        ),
                        sizedBox(),
                        if(controller.businessType.value != BusinessCategory.DRONES.name)
                        CustomImageField(
                            controller: controller.drivingLicenseImageController,
                            title: "Driving License Image"),
                      ],
                    ),
                    sizedBox(),
                    sizedBox(),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        CustomButton(
                          child: Text("Cancel"),
                          isPrimary: false,
                          width: 100,
                          onPressed: () {
                            Navigator.of(context).pop();
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
                            controller.saveProductDetails(context);
                          },
                          isLoading:
                          controller.savingProductDetails.value,
                        )
                      ] ,
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget sizedBox() {
    return const SizedBox(
      height: 15,
    );
  }
}
