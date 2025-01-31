import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Utils/utils.dart';
import 'package:raithan_serviceapp/Widgets/textField.dart';
import 'package:raithan_serviceapp/constants/enums/business_type.dart';
import 'package:raithan_serviceapp/constants/regex_constant.dart';

import '../../../Widgets/dropDownTextFeild.dart';

enum Gender { male, female, other }

class Businessdetailspage extends StatefulWidget {

  final TextEditingController businessNameController;
  final TextEditingController pincodeController;
  final TextEditingController blockNumberController;
  final TextEditingController streetController;
  final TextEditingController areaController;
  final TextEditingController landmarkController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final TextEditingController workingDaysController;
  final TextEditingController businessTypeController;


  final Map<String, bool> workingDays ;

  // Form key
  final GlobalKey<FormState> formKey;

   Businessdetailspage({
    super.key,
     required this.businessNameController,
     required this.pincodeController,
     required this.blockNumberController,
     required this.streetController,
     required this.areaController,
     required this.landmarkController,
     required this.cityController,
     required this.stateController,
     required this.startTimeController,  // New parameter
     required this.endTimeController,
     required this.workingDaysController,
     required this.workingDays,
     required this.formKey,  // For
     required this.businessTypeController
  });

  @override
  State<Businessdetailspage> createState() => _BusinessDetailsPageState();


}

class _BusinessDetailsPageState extends State<Businessdetailspage> {

  late FocusNode businessNameFocusNode;
  late FocusNode businessTypeFocusNode;
  late FocusNode pincodeFocusNode;
  late FocusNode blockNumberFocusNode;
  late FocusNode streetFocusNode;
  late FocusNode areaFocusNode;
  late FocusNode landmarkFocusNode;
  late FocusNode cityFocusNode;
  late FocusNode stateFocusNode;
  late FocusNode categoryFocusNode;
  late FocusNode workingTimeFocusNode;

  void initState() {
    super.initState();

    // Initialize FocusNodes
    businessNameFocusNode = FocusNode();
    pincodeFocusNode = FocusNode();
    blockNumberFocusNode = FocusNode();
    streetFocusNode = FocusNode();
    areaFocusNode = FocusNode();
    landmarkFocusNode = FocusNode();
    cityFocusNode = FocusNode();
    stateFocusNode = FocusNode();
    categoryFocusNode = FocusNode();
    workingTimeFocusNode = FocusNode();
    businessTypeFocusNode = FocusNode();

  }


  @override
  void dispose() {
    businessNameFocusNode.dispose();
    pincodeFocusNode.dispose();
    blockNumberFocusNode.dispose();
    streetFocusNode.dispose();
    areaFocusNode.dispose();
    landmarkFocusNode.dispose();
    cityFocusNode.dispose();
    stateFocusNode.dispose();
    categoryFocusNode.dispose();

    super.dispose();
  }



  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child1) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child1!,
        );
      },
    );
    if (selectedTime != null) {
      String formattedTime = selectedTime.format(context);
      controller.value = TextEditingValue(text:Utils.convertTo12HourFormat(formattedTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.formFieldPadding),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Business Information".tr,
                    style: robotoBold.copyWith(
                      color: black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              sizedBox(),
              CustomTextfield(
                controller: widget.businessNameController,
                type: TextInputType.name,
                focusNode: businessNameFocusNode,
                onFieldSubmitted: (value){
                   businessNameFocusNode.unfocus();
                },
                onChanged: (value){
                  widget.formKey.currentState?.validate();
                },
                label: "Business Name ( Optional )".tr,
              ),
              sizedBox(),
              DropdownTextField(
                controller: widget.businessTypeController,
                label: "Select an Business Type".tr,
                focusNode: businessTypeFocusNode,
                onFieldSubmitted: (value) {
                  businessTypeFocusNode.unfocus();
                },
                options: BusinessType.values.map((type) => type.toString()).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an option'.tr;
                  }
                  return null;
                },
              ),
            sizedBox(),
            // Container(
            //   padding: const EdgeInsets.only(top:0,bottom: 0,right:10.0,left: 10),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(color: Colors.grey),
            //   ),
            //   child: Theme(
            //     data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            //     child: ExpansionTile(
            //       onExpansionChanged: (isExpanding)
            //         {
            //            if(isExpanding)
            //              {
            //                FocusScope.of(context).requestFocus(categoryFocusNode);
            //              }
            //         },
            //         tilePadding: EdgeInsets.zero, // Removes padding around the tile
            //         collapsedBackgroundColor: Colors.transparent,
            //         title: const Text("Select Business Categories",  style: TextStyle(
            //           fontSize: AppDimensions.regularFontSize,
            //           fontWeight: FontWeight.bold,
            //         )),
            //         children: [ ...widget.categories.keys.map((category) {
            //           return CheckboxListTile(
            //             title: Text(category),
            //             value: widget.categories[category],
            //             onChanged: (bool? value) {
            //               setState(() {
            //                 widget.categories[category] = value!;
            //               });
            //             },
            //           );
            //         }).toList(), ]
            //     ),
            //   ),
            // ),
            //   sizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Business Address".tr,
                    style: robotoBold.copyWith(
                      color: black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              sizedBox(),
              CustomTextfield(
                controller: widget.blockNumberController,
                type: TextInputType.text,
                label: "House Number".tr,
                focusNode: blockNumberFocusNode,
                onFieldSubmitted: (value){
                  Utils.changeNodeFocus(context, blockNumberFocusNode, streetFocusNode);
                },
                onChanged: (value){
                  widget.formKey.currentState?.validate();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write your home Number'.tr;
                  }
                  return null;
                },
              ),
              sizedBox(),
              CustomTextfield(
                controller: widget.streetController,
                type: TextInputType.text,
                label: "Street".tr,
                focusNode: streetFocusNode,
                onFieldSubmitted: (value){
                  Utils.changeNodeFocus(context,streetFocusNode,areaFocusNode);
                },
                onChanged: (value){
                  widget.formKey.currentState?.validate();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write your street'.tr;
                  }
                  return null;
                },
              ),
              sizedBox(),
              CustomTextfield(
                controller: widget.areaController,
                type: TextInputType.text,
                label: "Area".tr,
                focusNode: areaFocusNode,
                onFieldSubmitted: (value){
                  Utils.changeNodeFocus(context,areaFocusNode,landmarkFocusNode);
                },
                onChanged: (value){
                  widget.formKey.currentState?.validate();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write your area'.tr;
                  }
                  return null;
                },
              ),
              sizedBox(),
              CustomTextfield(
                controller: widget.landmarkController,
                type: TextInputType.text,
                label: "Landmark".tr,
                focusNode: landmarkFocusNode,
                onFieldSubmitted: (value){
                  Utils.changeNodeFocus(context,landmarkFocusNode,cityFocusNode);
                },
                onChanged: (value){
                  widget.formKey.currentState?.validate();
                },
              ),
              sizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Container(
                width: AppDimensions.width*0.43,
                child: CustomTextfield(
                  controller: widget.cityController,
                  type: TextInputType.text,
                  label: "City".tr,
                  focusNode: cityFocusNode,
                  onFieldSubmitted: (value){
                    Utils.changeNodeFocus(context,cityFocusNode,stateFocusNode);
                  },
                  onChanged: (value){
                    widget.formKey.currentState?.validate();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please write your city'.tr;
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 3,),
              Container(
                width: AppDimensions.width*0.43,
                child: CustomTextfield(
                  controller: widget.stateController,
                  type: TextInputType.text,
                  label: "State".tr,
                  focusNode: stateFocusNode,
                  onFieldSubmitted: (value){
                    Utils.changeNodeFocus(context,stateFocusNode,pincodeFocusNode);
                  },
                  onChanged: (value){
                    widget.formKey.currentState?.validate();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please write your state'.tr;
                    }
                    return null;
                  },
                ),
              )]
              ),
              sizedBox(),
              CustomTextfield(
                controller: widget.pincodeController,
                type: TextInputType.number,
                label: "Pincode".tr,
                onChanged: (value){
                  widget.formKey.currentState?.validate();
                },
                focusNode: pincodeFocusNode,
                onFieldSubmitted: (value){
                  pincodeFocusNode.unfocus();
                },
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write your pincode'.tr;
                  }
                  if(!RegExp(RegexConstant.otpOrPincodeValidationRegex).hasMatch(value))
                  {
                    return 'Pincode must be 6 digits only'.tr;
                  }
                  return null;
                },
              ),

              sizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Working Time".tr,
                    style: robotoBold.copyWith(
                      color: black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              sizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: AppDimensions.width*0.43,
                    child: CustomTextfield(
                      controller: widget.startTimeController,
                      type: TextInputType.number,
                      readOnly : true,
                      onTap :  () {
                        _selectTime(context, widget.startTimeController);
                      },
                      suffixIcon : Icon(Icons.access_time),
                      label: "Start Time".tr,
                      onChanged: (value){
                        widget.formKey.currentState?.validate();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Start Time'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  SizedBox(
                    width: AppDimensions.width*0.43,
                    child: CustomTextfield(
                      controller: widget.endTimeController,
                      type: TextInputType.number,
                      readOnly : true,
                      onTap :  () {
                        _selectTime(context, widget.endTimeController);
                      },
                      suffixIcon : Icon(Icons.access_time),
                      label: "End Time".tr,
                      onChanged: (value){
                        widget.formKey.currentState?.validate();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select End Time'.tr;
                        }
                        return null;
                      },
                    ),
                  ),

                ],

              ),
              sizedBox(),
              Container(
                padding: const EdgeInsets.only(top:0,bottom: 0,right:10.0,left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                      onExpansionChanged: (isExpansion)
                      {
                        if(isExpansion)
                          {
                            FocusScope.of(context).requestFocus(workingTimeFocusNode);
                          }
                      },
                      tilePadding: EdgeInsets.zero, // Removes padding around the tile
                      collapsedBackgroundColor: Colors.transparent,
                    title: Text("Select Working Days".tr, style: const TextStyle(
                      fontSize: AppDimensions.regularFontSize,
                      fontWeight: FontWeight.bold,
                    )),
                    children: [ ...widget.workingDays.keys.map((day) {
                      return CheckboxListTile(
                        title: Text(day.tr),
                        value: widget.workingDays[day],
                        onChanged: (bool? value) {
                          setState(() {
                            widget.workingDays[day] = value!;
                          });
                        },
                      );
                    }).toList(), ]
                  ),
                ),
              ),

              sizedBox()
      
            ],
          ),
        ),
      ),
    );
  }

  Widget sizedBox() {
    return const SizedBox(
      height: 15,
    );
  }
}
