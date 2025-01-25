import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Widgets/custom_image_field.dart';
import 'package:raithan_serviceapp/Widgets/multiple_option_input_field.dart';
import 'package:raithan_serviceapp/Widgets/textField.dart';
import 'package:raithan_serviceapp/common/custom_button.dart';
import 'package:raithan_serviceapp/controller/labor_edit_controller.dart';

import '../../../Utils/app_style.dart';
import '../../../Utils/utils.dart';
import '../../../common/custom_appbar.dart';

class LaborEdit extends GetView<LaborEditController> {
  LaborEdit({super.key}) {
    Get.lazyPut(() => LaborEditController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          customAppBar(controller.businessType.value.tr, context, options: false),
      body: Obx(
        () => SingleChildScrollView(
            controller: controller.scrollController,
            child: controller.isLoading.value
                ? Utils.getLoadingWidget()
                : Container(
                    padding: EdgeInsets.all(AppDimensions.formFieldPadding),
                    child: Form(
                      key: controller.laborDetailFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.businessType.value.tr + " ${'Details'.tr}",
                                    style: robotoBold.copyWith(
                                      color: black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              sizedBox(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.formFieldPadding * 0.5),
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title:  Text(
                                    'Ready to travel within 10 km'.tr,
                                    style:const  TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  value: controller.readyToTravelIn10Km.value,
                                  onChanged: (bool? value) {
                                    controller.readyToTravelIn10Km.value = value!;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.formFieldPadding * 0.5),
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Individual Worker'.tr,
                                    style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  value: controller.isIndividual.value,
                                  onChanged: (bool? value) {
                                    controller.isIndividual.value = value!;
                                  },
                                ),
                              ),
                              if (!controller.isIndividual.value)
                                CustomTextfield(
                                    type: TextInputType.number,
                                    focusNode: controller.numberOfWorkerFocusNode,
                                    onFieldSubmitted: (value)
                                    {
                                      Utils.changeNodeFocus(context, controller.numberOfWorkerFocusNode, controller.shramCardNumberFocusNode);
                                    },
                                    validator: (value)
                                    {
                                      if(!controller.isIndividual.value) {
                                        if(value == null || value.isEmpty)
                                          {
                                            return "Please write number of workers".tr;
                                          }
                                        else if (int.tryParse(value) == null) {
                                          return "Please enter a valid number".tr;
                                        }
                                      }
                                    },
                                    controller: controller.numberOfWorkers,
                                    label: "No of Workers".tr),
                              if (!controller.isIndividual.value) sizedBox(),
                              CustomTextfield(
                                  focusNode: controller.shramCardNumberFocusNode,
                                  maxLength: 12,
                                  type: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your Shram Card Number".tr;
                                    }
                                    if (value.length != 12) {
                                      return "Shram Card Number must be 12 digits long".tr;
                                    }
                                    if (int.tryParse(value) == null) {
                                      return "Shram Card Number must be a valid number".tr;
                                    }
                                    return null; // No errors
                                  },
                                  onFieldSubmitted: (value)
                                  {
                                    Utils.changeNodeFocus(context, controller.shramCardNumberFocusNode, controller.serviceTypeFocusNode);
                                  },
                                  controller: controller.shramCardNumber,
                                  label: "Shram Card Number".tr),
                              sizedBox(),
                              MultipleOptionInputField(
                                  focusNode: controller.serviceTypeFocusNode,
                                  title: "${'Select'.tr} ${controller.businessType.value.tr} ${'Service Type'.tr}",
                                  categories: controller.serviceTypes),
                              sizedBox(),
                              CustomImageField(
                                  controller: controller.shramCardController,
                                  title: "Shram Card Image".tr),
                            ],
                          ),
                          sizedBox(),
                          sizedBox(),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              CustomButton(
                                child: Text("Cancel".tr),
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
                                child: Text("Apply For Verification".tr),
                                isPrimary: true,
                                width: 200,
                                onPressed: () {
                                  controller.saveProductDetailsDetails(context);
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
