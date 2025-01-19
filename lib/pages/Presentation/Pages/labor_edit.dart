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
          customAppBar(controller.businessType.value, context, options: false),
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
                                    controller.businessType.value + " Details",
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
                                  title: const Text(
                                    'Ready To Travel In 10Km',
                                    style: TextStyle(fontWeight: FontWeight.bold),
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
                                    'Is Individual Person',
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
                                            return "Please write number of workers";
                                          }
                                        else if (int.tryParse(value) == null) {
                                          return "Please enter a valid number";
                                        }
                                      }
                                    },
                                    controller: controller.numberOfWorkers,
                                    label: "No of Workers"),
                              if (!controller.isIndividual.value) sizedBox(),
                              CustomTextfield(
                                  focusNode: controller.shramCardNumberFocusNode,
                                  maxLength: 12,
                                  type: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your Shram Card Number";
                                    }
                                    if (value.length != 12) {
                                      return "Shram Card Number must be 12 digits long";
                                    }
                                    if (int.tryParse(value) == null) {
                                      return "Shram Card Number must be a valid number";
                                    }
                                    return null; // No errors
                                  },
                                  onFieldSubmitted: (value)
                                  {
                                    Utils.changeNodeFocus(context, controller.shramCardNumberFocusNode, controller.serviceTypeFocusNode);
                                  },
                                  controller: controller.shramCardNumber,
                                  label: "Shram Card Number"),
                              sizedBox(),
                              MultipleOptionInputField(
                                  focusNode: controller.serviceTypeFocusNode,
                                  title: "Select ${controller.businessType} Service Type",
                                  categories: controller.serviceTypes),
                              sizedBox(),
                              CustomImageField(
                                  controller: controller.shramCardController,
                                  title: "Shram Card Image"),
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
