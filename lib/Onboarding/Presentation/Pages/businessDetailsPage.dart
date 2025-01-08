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
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.width*0.03),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Business Details",
                style: robotoBold.copyWith(
                  color: black,
                  fontSize: 20,
                ),
              ),
              sizedBox(),
              CustomTextfield(
                controller: widget.businessNameController,
                type: TextInputType.name,
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
              CustomTextfield(
                controller: widget.pincodeController,
                type: TextInputType.number,
                label: "Pincode",
                onChanged: (value){
                  widget.formKey.currentState?.validate();
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
              CustomTextfield(
                controller: widget.blockNumberController,
                type: TextInputType.text,
                label: "Block Number",
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Title for the working days
                    const Text(
                      'Select Working Days',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
      
                    // Container to wrap the checkboxes with title
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
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
              sizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: AppDimensions.width*0.43,
                    child: TextFormField(
                      controller: widget.startTimeController,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select Start Time';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Start Time',
                        suffixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
      
                      onTap: () {
                        _selectTime(context, widget.startTimeController);
                      },
                    ),
                  ),
                  SizedBox(width: 5,),
                  Container(
                    width: AppDimensions.width*0.43,
                    child: TextFormField(
                      controller: widget.endTimeController,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select End Time';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        suffixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onTap: () {
                        _selectTime(context, widget.endTimeController);
                      },
                    ),
                  ),
      
                ],
      
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
