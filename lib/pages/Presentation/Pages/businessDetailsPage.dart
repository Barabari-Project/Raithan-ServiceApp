import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Utils/utils.dart';
import 'package:raithan_serviceapp/Widgets/dobInputField.dart';
import 'package:raithan_serviceapp/Widgets/dropDownTextFeild.dart';
import 'package:raithan_serviceapp/Widgets/imageInputFeild.dart';
import 'package:raithan_serviceapp/Widgets/textField.dart';
import 'package:raithan_serviceapp/constants/enums/business_category.dart';

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
  final TextEditingController categoryController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final TextEditingController workingDaysController;



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
     required this.categoryController,
     required this.startTimeController,  // New parameter
     required this.endTimeController,
     required this.workingDaysController,
     required this.workingDays,
     required this.formKey,  // For
  });

  @override
  State<Businessdetailspage> createState() => _BusinessDetailsPageState();


}

class _BusinessDetailsPageState extends State<Businessdetailspage> {

  late FocusNode businessNameFocusNode;
  late FocusNode pincodeFocusNode;
  late FocusNode blockNumberFocusNode;
  late FocusNode streetFocusNode;
  late FocusNode areaFocusNode;
  late FocusNode landmarkFocusNode;
  late FocusNode cityFocusNode;
  late FocusNode stateFocusNode;
  late FocusNode categoryFocusNode;

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
                    "Business Information",
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
                label: "Business Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Business name';
                  }
                  return null;
                },
              ),
              sizedBox(),
              DropdownTextField(
                controller: widget.categoryController,
                label: "Select an Business Category",
                onChanged: (value){
                  widget.formKey.currentState?.validate();
                },
                options: BusinessCategory.values.map((e) {
                  return e.name;
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an Business Category';
                  }
                  return null;
                },
              ),
              sizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Business Address",
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
                label: "Block Number",
                focusNode: blockNumberFocusNode,
                onFieldSubmitted: (value){
                  Utils.changeNodeFocus(context, blockNumberFocusNode, streetFocusNode);
                },
                onChanged: (value){
                  widget.formKey.currentState?.validate();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write your block Number';
                  }
                  return null;
                },
              ),
              sizedBox(),
              CustomTextfield(
                controller: widget.streetController,
                type: TextInputType.text,
                label: "Street",
                focusNode: streetFocusNode,
                onFieldSubmitted: (value){
                  Utils.changeNodeFocus(context,streetFocusNode,areaFocusNode);
                },
                onChanged: (value){
                  widget.formKey.currentState?.validate();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write your street';
                  }
                  return null;
                },
              ),
              sizedBox(),
              CustomTextfield(
                controller: widget.areaController,
                type: TextInputType.text,
                label: "Area",
                focusNode: areaFocusNode,
                onFieldSubmitted: (value){
                  Utils.changeNodeFocus(context,areaFocusNode,landmarkFocusNode);
                },
                onChanged: (value){
                  widget.formKey.currentState?.validate();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write your area';
                  }
                  return null;
                },
              ),
              sizedBox(),
              CustomTextfield(
                controller: widget.landmarkController,
                type: TextInputType.text,
                label: "Landmark",
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
                  label: "City",
                  focusNode: cityFocusNode,
                  onFieldSubmitted: (value){
                    Utils.changeNodeFocus(context,cityFocusNode,stateFocusNode);
                  },
                  onChanged: (value){
                    widget.formKey.currentState?.validate();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please write your city';
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
                  label: "State",
                  focusNode: stateFocusNode,
                  onFieldSubmitted: (value){
                    Utils.changeNodeFocus(context,stateFocusNode,pincodeFocusNode);
                  },
                  onChanged: (value){
                    widget.formKey.currentState?.validate();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please write your state';
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
                label: "Pincode",
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
                    return 'Please write your pincode';
                  }
                  return null;
                },
              ),

              sizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Working Time",
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
                      label: "Start Time",
                      onChanged: (value){
                        widget.formKey.currentState?.validate();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Start Time';
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
                      label: "End Time",
                      onChanged: (value){
                        widget.formKey.currentState?.validate();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select End Time';
                        }
                        return null;
                      },
                    ),
                  ),

                ],

              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Title for the working days
                    const Text(
                      'Working Days',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
      
                    // Container to wrap the checkboxes with title
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5), // Whitesmoke color
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        children: [
                          // Loop through the working days to create checkboxes
                          ...widget.workingDays.keys.map((day) {
                            return CheckboxListTile(
                              title: Text(day),
                              value: widget.workingDays[day],
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.workingDays[day] = value!;
                                });
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
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
